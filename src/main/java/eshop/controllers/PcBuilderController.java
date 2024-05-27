package eshop.controllers;

import eshop.models.Build;
import eshop.models.Product;
import eshop.models.enums.ProductType;
import eshop.servives.PcBuilderService;
import eshop.servives.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.security.Principal;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class PcBuilderController {
    private final ProductService productService;
    private final PcBuilderService pcBuilderService;
    @GetMapping("pcbuilder")
    public String pcBuilder(@RequestParam(name = "title",required = false) String Title, Principal principal, Model model){
        model.addAttribute("user", productService.getUserByPrincipal(principal));
        model.addAttribute("Products",productService.listProducts(Title));
        model.addAttribute("ProductType", ProductType.class);
        List<Product> products = productService.listProducts(Title);
        for (Product product : products){
            System.out.println(product.getProductType());
        }
        return "pc-builder";
    }

    @GetMapping("/pcbuilder/compatibleProduct")
    @ResponseBody
    public List<Product> getCompatibleProducts(@RequestParam String productType) {
        ProductType type = ProductType.valueOf(productType.toUpperCase());
        return pcBuilderService.getCompatibleProduct(type);
    }

    @PostMapping("/pcbuilder/addToBuild")
    public ResponseEntity<Void> addToBuild(@RequestParam String productId, @RequestParam String productType, @RequestBody Build build) {
        ProductType type = ProductType.valueOf(productType.toUpperCase());
        pcBuilderService.addToBuild(productId, type, build);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/pcbuilder/saveBuild")
    public ResponseEntity<Void> saveBuild(@RequestBody Build build) {
        pcBuilderService.saveBuild(build);
        return ResponseEntity.ok().build();
    }
}
