package eshop.controllers;


import eshop.models.enums.ProductType;
import eshop.models.User;
import eshop.servives.ProductService;
import eshop.servives.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import java.security.Principal;
import java.util.Arrays;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;
    private final ProductService productService;
    List<ProductType> productTypes = Arrays.asList(ProductType.values());

    @GetMapping("/login")
    public String login(Model model, Principal principal) {
        model.addAttribute("user", productService.getUserByPrincipal(principal));
        return "login";
    }

    @GetMapping("/registration")
    public String registration(Model model, Principal principal) {
        model.addAttribute("user", productService.getUserByPrincipal(principal));
        return "registration";
    }

    @GetMapping("/profile")
    public String profile(Principal principal, Model model) {
        User user = userService.getUserByPrincipal(principal);
        model.addAttribute("user", user);
        model.addAttribute("ProductType", productTypes);
        return "profile";
    }

    @PostMapping("/registration")
    public String createUser(User user, Model model) {
        if (!userService.createUser(user)) {
            model.addAttribute("errorMessage", "Пользователь с email: " + user.getEmail() + " уже существует");
            return "registration";
        }
        return "redirect:/login";
    }

    @GetMapping("/user/{user}")
    public String userInfo(@PathVariable("user") User user, Model model, Principal principal) {
        model.addAttribute("user", user);
        model.addAttribute("user", productService.getUserByPrincipal(principal));
        return "user-info";
    }
}
