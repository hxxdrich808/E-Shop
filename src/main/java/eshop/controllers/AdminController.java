package eshop.controllers;

import eshop.models.Order;
import eshop.models.User;
import eshop.models.enums.OrderStatus;
import eshop.models.enums.Role;
import eshop.repositories.OrderRepository;
import eshop.repositories.UserRepository;
import eshop.services.implementations.UserServiceImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@PreAuthorize("hasAuthority('ROLE_ADMIN')")
public class AdminController {
    private final UserServiceImpl userService;
    private final OrderRepository orderRepository;
    private final UserRepository userRepository;

    @GetMapping("/admin")
    public String admin(Model model, Principal principal) {
        model.addAttribute("users", userService.userList());
        model.addAttribute("user", userService.getUserByPrincipal(principal));
        return "admin";
    }

    @PostMapping("/admin/user/ban/{id}")
    public String ban(@PathVariable("id") Long id) {
        userService.banUser(id);
        return "redirect:/admin";
    }

    @GetMapping("/admin/user/edit/{user}")
    public String userEdit(@PathVariable("user") User user, Model model, Principal principal) {
        model.addAttribute("user", user);
        model.addAttribute("roles", Role.values());
        model.addAttribute("user", userService.getUserByPrincipal(principal));
        return "user-edit";
    }

    @PostMapping("/admin/user/edit")
    public String userEdit(@RequestParam("userId") User user, @RequestParam Map<String, String> form) {
        userService.changeUserRoles(user, form);
        return "redirect:/admin";
    }

    @GetMapping("/orders/user/{userId}")
    public String userOrders(@PathVariable Long userId, Model model, Principal principal) {
        User admin = userService.getUserByPrincipal(principal);
        User user = userRepository.findUserById(userId);
        List<Order> orders = orderRepository.findAllByUser(user);

        model.addAttribute("user", admin);
        model.addAttribute("orders", orders);
        model.addAttribute("userId", userId);
        model.addAttribute("statuses", OrderStatus.values());
        return "user-orders";
    }

    @PostMapping("/orders/updateStatus")
    public String updateOrderStatus(
            @RequestParam("orderId") Long orderId,
            @RequestParam("status") String status,
            @RequestParam(value = "userId", required = false) Long userId // Для редиректа обратно
    ) {
        // Найти заказ
        Order order = orderRepository.findById(orderId).orElse(null);
        if (order == null) {
            return "redirect:/admin";
        }
        // Обновить статус
        order.setStatus(OrderStatus.valueOf(status));
        orderRepository.save(order);

        // Редирект обратно на страницу заказов пользователя
        if (userId != null) {
            return "redirect:/orders/user/" + userId;
        } else {
            return "redirect:/admin";
        }
    }
}
