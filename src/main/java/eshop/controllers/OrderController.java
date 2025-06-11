package eshop.controllers;

import eshop.models.Status;
import eshop.models.enums.OrderStatus;
import eshop.services.implementations.OrderServiceImpl;
import eshop.services.implementations.ProductServiceImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@Controller
@RequiredArgsConstructor
@RequestMapping("/orders")
public class OrderController {
    private final ProductServiceImpl productService;
    private final OrderServiceImpl orderService;

    @GetMapping("/listUserOrders")
    public String orders (@PathVariable Long userId,
                         Model model,
                         Principal principal){
        model.addAttribute("user", productService.getUserByPrincipal(principal));
        model.addAttribute("Orders", orderService.getOrdersByUserId(userId));
        model.addAttribute("Statuses", OrderStatus.values());
        return "/user-orders";
    }

    @PostMapping("/updateStatus")
    public String updateOrderStatus(@RequestParam("orderId") Long orderId,
                                    @RequestParam("status") Status status,
                                    Principal principal,
                                    Model model) {
        model.addAttribute("Orders", orderService.getOrders());
        model.addAttribute("user", productService.getUserByPrincipal(principal));
        orderService.updateOrderStatus(orderId, status);
        return "redirect:/orders/";
    }
}
