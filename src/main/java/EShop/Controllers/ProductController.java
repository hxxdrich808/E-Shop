package EShop.Controllers;

import EShop.Models.Product;
import EShop.Servives.ProductService;
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
    private final ProductService productService;

    @GetMapping("/")
    public String Products(@RequestParam(name = "title",required = false) String Title,Principal principal, Model model){
        model.addAttribute("Products",productService.listProducts(Title));
        model.addAttribute("user",productService.getUserByPrincipal(principal));
        return "products";
    }

    @PostMapping("/Product/create")
    public String CreateProduct(@RequestParam("file1") MultipartFile file1,@RequestParam("file2") MultipartFile file2,@RequestParam("file3") MultipartFile file3, Product product) throws IOException {
        productService.SaveProduct(product, file1, file2, file3);
        return "redirect:/";
    }

    @PostMapping("/Product/delete/{id}")
    public String DeleteProduct(@PathVariable Long id){
        productService.DeleteProduct(id);
        return "redirect:/";
    }

    @GetMapping("/Product/{id}")
    public String InfoProduct(@PathVariable Long id, Model model, Principal principal){
        Product product = productService.getProductById(id);
        model.addAttribute("product",product);
        model.addAttribute("images", product.getImages());
        model.addAttribute("user", productService.getUserByPrincipal(principal));
        return "product-info";
    }
}
