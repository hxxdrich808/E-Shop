package eshop.controllers;

import eshop.models.Product;
import eshop.models.ProductCompatibility;
import eshop.models.Review;
import eshop.models.enums.ProductType;
import eshop.services.implementations.ProductServiceImpl;
import eshop.services.implementations.ReviewServiceImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.Principal;
import java.util.Arrays;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class ProductController {
    private final ProductServiceImpl productService;
    private final ReviewServiceImpl reviewService;

    @GetMapping("/")
    public String products(
            @RequestParam(value = "type", required = false) String type,
            @RequestParam(value = "manufacturer", required = false) String manufacturer,
            @RequestParam(value = "minPrice", required = false) String minPrice,
            @RequestParam(value = "maxPrice", required = false) String maxPrice,
            @RequestParam(value = "inStock", required = false) String inStock,
            Model model, Principal principal
    ) {
        String typeValue = (type != null && !type.isEmpty()) ? type : null;
        String manufacturerValue = (manufacturer != null && !manufacturer.isEmpty()) ? manufacturer : null;
        Double minPriceValue = (minPrice != null && !minPrice.isEmpty()) ? Double.valueOf(minPrice) : null;
        Double maxPriceValue = (maxPrice != null && !maxPrice.isEmpty()) ? Double.valueOf(maxPrice) : null;

        model.addAttribute("type", typeValue);
        model.addAttribute("manufacturer", manufacturerValue);
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("ProductType", Arrays.asList(ProductType.values()));
        model.addAttribute("Manufacturers", productService.getAllManufacturers());

        Boolean inStockValue = "on".equals(inStock);
        model.addAttribute("inStock", inStock);

        List<Product> products = productService.filterProducts(
                typeValue, manufacturerValue, minPriceValue, maxPriceValue, inStockValue
        );
        model.addAttribute("Products", products);

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
        List<Review> reviews = reviewService.getReviewsByProductId(id);
        model.addAttribute("reviews", reviews);
        return "product-info";
    }

    @GetMapping("/products/sortByRating")
    public String sortByRating(Model model) {
        List<Product> products = productService.getProductsSortedByRating();
        products.forEach(p -> p.setAverageRating(p.getAverageRating()));
        model.addAttribute("Products", products);
        return "products";
    }
}
