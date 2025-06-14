package eshop.controllers;

import eshop.models.Cart;
import eshop.models.Order;
import eshop.models.User;
import eshop.repositories.OrderRepository;
import eshop.services.OrderService;
import eshop.services.implementations.CartServiceImpl;
import eshop.services.implementations.ProductServiceImpl;
import eshop.services.implementations.UserServiceImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;
    private final UserServiceImpl userService;
    private final OrderRepository orderRepository;
    private final ProductServiceImpl productService;
    private final CartServiceImpl cartService;


    @GetMapping("/orders/my")
    public String myOrders(Principal principal, Model model) {
        User user = userService.getUserByPrincipal(principal);
        List<Order> orders = orderRepository.findAllByUser(user);
        model.addAttribute("orders", orders);
        model.addAttribute("user", user);
        return "my-orders";
    }

    @PostMapping("/order/create")
    public String createOrder(
            @RequestParam String customerFullName,
            @RequestParam String customerPhone,
            @RequestParam String address,
            @RequestParam String postalCode,
            Principal principal,
            Model model
    ) {
        // Простая валидация адреса
        if (address == null || !address.contains(",") || address.length() < 7) {
            model.addAttribute("addressError", "Адрес должен быть в формате: Город, улица и номер дома");
            // Добавим обратно значения, чтобы не терять их при ошибке
            model.addAttribute("customerFullName", customerFullName);
            model.addAttribute("customerPhone", customerPhone);
            model.addAttribute("address", address);
            model.addAttribute("postalCode", postalCode);

            // Подгружаем корзину, пользователя и цену, чтобы страница не была пустой
            User user = productService.getUserByPrincipal(principal);
            Cart cart = cartService.getCartByUser(user);
            model.addAttribute("cart", cart);
            model.addAttribute("totalPrice", cartService.calculateTotalPrice(cart));
            model.addAttribute("user", user);

            return "cart";
        }

        // Получаем пользователя и корзину
        User user = productService.getUserByPrincipal(principal);
        Cart cart = cartService.getCartByUser(user);

        // Проверяем, что корзина не пуста
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            model.addAttribute("cartError", "Корзина пуста.");
            model.addAttribute("cart", cart);
            model.addAttribute("totalPrice", 0);
            model.addAttribute("user", user);
            return "cart";
        }

        // Оформляем заказ, передавая все данные
        orderService.createOrderFromCart(cart, customerFullName, customerPhone, address, postalCode);

        return "redirect:/orders/my";

    }


}
