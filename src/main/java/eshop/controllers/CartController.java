package eshop.controllers;

import eshop.models.Product;
import eshop.models.User;
import eshop.repositories.ProductRepository;
import eshop.services.implementations.CartServiceImpl;
import eshop.services.implementations.UserServiceImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@Controller
@RequestMapping("/cart")
@RequiredArgsConstructor
public class CartController {

    private final CartServiceImpl cartService;
    private final ProductRepository productRepository;
    private final UserServiceImpl userService;

    @GetMapping
    public String viewCart(Model model, Principal principal) {
        User user = userService.getUserByPrincipal(principal);
        var cart = cartService.getCartByUser(user);
        model.addAttribute("cart", cart);
        model.addAttribute("totalPrice", cartService.calculateTotalPrice(cart));
        model.addAttribute("user", user);
        return "cart";
    }

    @PostMapping("/add/{productId}")
    public String addToCart(@PathVariable Long productId, Principal principal) {
        User user = userService.getUserByPrincipal(principal);
        Product product = productRepository.findById(productId).orElseThrow();
        cartService.addProductToCart(user, product);
        return "redirect:/";
    }

    @PostMapping("/addFromProduct/{productId}")
    public String addToCartFromProduct(@PathVariable Long productId, Principal principal) {
        User user = userService.getUserByPrincipal(principal);
        Product product = productRepository.findById(productId).orElseThrow();
        cartService.addProductToCart(user, product);
        return "redirect:/Product/" + productId;
    }

    @PostMapping("/increment/{productId}")
    public String increment(@PathVariable Long productId, Principal principal) {
        User user = userService.getUserByPrincipal(principal);
        Product product = productRepository.findById(productId).orElseThrow();
        cartService.incrementProduct(user, product);
        return "redirect:/cart";
    }

    @PostMapping("/decrement/{productId}")
    public String decrement(@PathVariable Long productId, Principal principal) {
        User user = userService.getUserByPrincipal(principal);
        Product product = productRepository.findById(productId).orElseThrow();
        cartService.decrementProduct(user, product);
        return "redirect:/cart";
    }

    @PostMapping("/remove/{productId}")
    public String remove(@PathVariable Long productId, Principal principal) {
        User user = userService.getUserByPrincipal(principal);
        Product product = productRepository.findById(productId).orElseThrow();
        cartService.removeProductFromCart(user, product);
        return "redirect:/cart";
    }
}
