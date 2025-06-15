package eshop.controllers;


import eshop.models.User;
import eshop.models.enums.ProductType;
import eshop.services.implementations.ProductServiceImpl;
import eshop.services.implementations.UserServiceImpl;
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
    private final UserServiceImpl userService;
    private final ProductServiceImpl productService;
    private static final String USER = "user";
    List<ProductType> productTypes = Arrays.asList(ProductType.values());

    @GetMapping("/login")
    public String login(Model model, Principal principal) {
        model.addAttribute(USER, productService.getUserByPrincipal(principal));
        return "login";
    }

    @GetMapping("/registration")
    public String registration(Model model, Principal principal) {
        model.addAttribute(USER, productService.getUserByPrincipal(principal));
        return "registration";
    }

    @GetMapping("/profile")
    public String profile(Principal principal, Model model) {
        User user = userService.getUserByPrincipal(principal);
        model.addAttribute(USER, user);
        model.addAttribute("ProductType", productTypes);
        return "profile";
    }

    @PostMapping("/registration")
    public String createUser(User user, Model model) {
        if (!userService.createUser(user)) {

            model.addAttribute("errorMessage", String.format("Пользователь с email: %s уже сушествует", user.getEmail()));
            return "registration";
        }
        return "redirect:/login";
    }

    @GetMapping("/user/{user}")
    public String userInfo(@PathVariable(USER) User user, Model model, Principal principal) {
        model.addAttribute(USER, user);
        model.addAttribute(USER, productService.getUserByPrincipal(principal));
        return "user-info";
    }
}
