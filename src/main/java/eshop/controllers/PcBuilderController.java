package eshop.controllers;

import eshop.models.Build;
import eshop.models.Product;
import eshop.models.enums.ProductType;
import eshop.repositories.BuildRepository;
import eshop.services.implementations.PcBuilderServiceImpl;
import eshop.services.implementations.ProductServiceImpl;
import lombok.RequiredArgsConstructor;
import org.apache.commons.io.IOUtils;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.Principal;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class PcBuilderController {
    private final ProductServiceImpl productService;
    private final PcBuilderServiceImpl pcBuilderService;
    private final BuildRepository buildRepository;
    Build build;

    @GetMapping("pcbuilder")
    public String pcBuilder(@RequestParam(name = "title", required = false) String Title,
                            Principal principal, Model model) {
        model.addAttribute("user", productService.getUserByPrincipal(principal));
        model.addAttribute("Products", productService.listProducts(Title));
        model.addAttribute("ProductType", ProductType.class);
        List<Product> products = productService.listProducts(Title);
        return "pc-builder";
    }

    @GetMapping("/pcbuilder/compatibleProduct")
    @ResponseBody
    public List<Product> getCompatibleProducts(@RequestParam String productType) {
        ProductType type = ProductType.valueOf(productType.toUpperCase());
        return pcBuilderService.getCompatibleProduct(type);
    }

    @GetMapping("/pcbuilder/addToBuild")
    @ResponseBody
    public String addToBuild(@RequestParam Long productId, @RequestParam String productType, @RequestParam String cpu,
                             @RequestParam String motherboard, @RequestParam String systemUnit,
                             @RequestParam String gpu, @RequestParam String cooler, @RequestParam String ram,
                             @RequestParam String drive, @RequestParam String psu) {
        build = new Build(productId, cpu, motherboard, systemUnit, gpu, cooler, ram, drive, psu);
        ProductType type = ProductType.valueOf(productType.toUpperCase());
        pcBuilderService.addToBuild(String.valueOf(productId), type, build);
        return "product added";
    }

    @GetMapping("/pcbuilder/saveBuild")
    @ResponseBody
    public Build saveBuild() {
        return pcBuilderService.saveBuild(build);
    }

    @GetMapping(
            value = "/pcbuilder/download",
            produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
    public @ResponseBody byte[] getFile() throws IOException {
        InputStream in = new FileInputStream("C:\\Users\\hxxdrichXD\\IdeaProjects\\E-Shop\\src\\main\\resources\\files\\build.pdf");
        return IOUtils.toByteArray(in);
    }

}
