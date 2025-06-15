package eshop.services;

import eshop.models.Product;
import eshop.models.ProductCompatibility;
import eshop.models.User;
import eshop.models.enums.ProductType;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.Principal;
import java.util.List;

public interface ProductService {
    List<Product> listProducts(String title);

    void saveProduct(ProductType productType, Product product, ProductCompatibility productCompatibility, List<MultipartFile> images) throws IOException;

    User getUserByPrincipal(Principal principal);

    void deleteProduct(Long id);

    Product getProductById(Long id);

    ProductCompatibility getProductCompatibilityByProductId(Long productId);

    List<String> getAllManufacturers();

    List<Product> filterProducts(String type, String manufacturer, Double minPrice, Double maxPrice, Boolean inStock);
}
