package eshop.controllers;

import eshop.models.ProductCompatibility;
import eshop.models.enums.ProductType;
import eshop.models.Product;
import eshop.services.implementations.ProductServiceImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.Principal;

@Controller
@RequiredArgsConstructor
public class ProductController {
    private final ProductServiceImpl productService;

    @GetMapping("/")
    public String products(@RequestParam(name = "title", required = false) String Title, Principal principal, Model model) {
        model.addAttribute("Products", productService.listProducts(Title));
        model.addAttribute("ProductType", ProductType.class);
        model.addAttribute("user", productService.getUserByPrincipal(principal));
        return "products";
    }

    @PostMapping("/Product/create")
    public String createProduct(@RequestParam("file1") MultipartFile file1, @RequestParam("file2") MultipartFile file2, @RequestParam("file3") MultipartFile file3, Product product, ProductCompatibility productCompatibility, ProductType productType) throws IOException {
        productService.saveProduct(productType, product, productCompatibility, file1, file2, file3);
        return "redirect:/";
    }

    @PostMapping("/Product/delete/{id}")
    public String deleteProduct(@PathVariable Long id) {
        productService.deleteProduct(id);
        return "redirect:/";
    }

    @GetMapping("/Product/{id}")
    public String infoProduct(@PathVariable Long id, Model model, Principal principal) {
        Product product = productService.getProductById(id);
        ProductCompatibility productCompatibility = productService.getProductCompatibilityByProductId(id);
        model.addAttribute("product", product);
        model.addAttribute("images", product.getImages());
        model.addAttribute("user", productService.getUserByPrincipal(principal));
        model.addAttribute("productCompatibility", productCompatibility);
        return "product-info";
    }
}
