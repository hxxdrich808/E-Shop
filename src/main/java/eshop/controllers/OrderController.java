package eshop.controllers;

import eshop.models.Order;
import eshop.models.User;
import eshop.repositories.OrderRepository;
import eshop.services.OrderService;
import eshop.services.implementations.ProductServiceImpl;
import eshop.services.implementations.UserServiceImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import java.security.Principal;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;
    private final UserServiceImpl userService;
    private final OrderRepository orderRepository;
    private final ProductServiceImpl productService;

    @PostMapping("/cart/checkout")
    public String checkout(Principal principal, Model model) {
        User user = userService.getUserByPrincipal(principal);
        orderService.createOrderFromCart(user);
        return "redirect:/orders/my";
    }

    @GetMapping("/orders/my")
    public String myOrders(Principal principal, Model model) {
        User user = userService.getUserByPrincipal(principal);
        List<Order> orders = orderRepository.findAllByUser(user);
        model.addAttribute("orders", orders);
        model.addAttribute("user", user);
        return "user-orders";  // создадим этот шаблон ниже
    }

    @PostMapping("/order/create")
    public String createOrder(Principal principal) {
        User user = productService.getUserByPrincipal(principal);
        orderService.createOrderFromCart(user);
        return "redirect:/my-orders";
    }
}
