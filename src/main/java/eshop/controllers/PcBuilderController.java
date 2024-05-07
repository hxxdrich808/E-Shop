package eshop.controllers;

import eshop.servives.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.ui.Model;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import java.security.Principal;

@Controller
@RequiredArgsConstructor
public class PcBuilderController {
    private final ProductService productService;
    @GetMapping("pcbuilder")
    public String pcBuilder(Principal principal, Model model){
        model.addAttribute("user", productService.getUserByPrincipal(principal));
        return "pc-builder";
    }
}

//TODO допиши остальные пост и гет методы для контроллера, создай Сервис Конструктора ПК