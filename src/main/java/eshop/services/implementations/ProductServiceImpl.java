package eshop.services.implementations;

import eshop.exceptions.ConvertationException;
import eshop.models.*;
import eshop.models.enums.ProductType;
import eshop.repositories.ProductCompatibilityRepository;
import eshop.repositories.ProductRepository;
import eshop.repositories.UserRepository;
import eshop.services.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.Principal;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductServiceImpl implements ProductService {

    private final ProductRepository productRepository;
    private final UserRepository userRepository;
    private final ProductCompatibilityRepository productCompatibilityRepository;

    @Override
    public List<Product> listProducts(String title) {
        if (title != null) return productRepository.findByTitle(title);
        return productRepository.findAll();
    }

    @Override
    @Transactional
    public void saveProduct(ProductType productType, Product product, ProductCompatibility productCompatibility, MultipartFile file1, MultipartFile file2, MultipartFile file3) {
        Image image1;
        Image image2;
        Image image3;
        product.setProductType(productType);
        if (file1.getSize() != 0) {
            image1 = toImageEntity(file1);
            image1.setPreviewImage(true);
            product.addImageToProduct(image1);
        }
        if (file2.getSize() != 0) {
            image2 = toImageEntity(file2);
            product.addImageToProduct(image2);
        }
        if (file3.getSize() != 0) {
            image3 = toImageEntity(file3);
            product.addImageToProduct(image3);
        }
        log.info("Saving new Product. Title: {}", product.getTitle());
        Product productFromDB = productRepository.save(product);
        productFromDB.setPreviewImageId(productFromDB.getImages().get(0).getId());
        productRepository.save(product);
        switch (productType) {
            case CPU, MOTHERBOARD, CASE, GPU, RAM, DRIVE, PSU -> {
                productCompatibility.setProduct(product);
                productCompatibilityRepository.save(productCompatibility);
            }
        }
    }

    @Override
    public User getUserByPrincipal(Principal principal) {
        if (principal == null) return new User();
        return userRepository.findByEmail(principal.getName());
    }

    @Override
    public void deleteProduct(Long id) {
        log.info("Deleting product {}", id);
        productCompatibilityRepository.deleteById(id);
        productRepository.deleteById(id);
    }

    @Override
    public Product getProductById(Long id) {
        log.info("Getting product by {}", id);
        return productRepository.findById(id).orElse(null);
    }

    @Override
    public ProductCompatibility getProductCompatibilityByProductId(Long productId) {
        return productCompatibilityRepository.findByProductId(productId);
    }

    private Image toImageEntity(MultipartFile file)  {
        Image image = new Image();
        image.setName(file.getName());
        image.setFileName(file.getOriginalFilename());
        image.setContentType(file.getContentType());
        image.setSize(file.getSize());
        try {
            image.setBytes(file.getBytes());
        } catch (IOException e) {
            log.error("Error while converting file to bytes", e);
            throw new ConvertationException(e.getMessage());
        }
        return image;
    }

    @Override
    public List<Product> filterProducts(String type, String manufacturer, Double minPrice, Double maxPrice, Boolean inStock) {

        return productRepository.findAll().stream()
                .filter(p -> type == null || p.getProductType().toString().equals(type))
                .filter(p -> manufacturer == null || p.getManufacturer().equals(manufacturer))
                .filter(p -> minPrice == null || p.getPrice() >= minPrice)
                .filter(p -> maxPrice == null || p.getPrice() <= maxPrice)
                .filter(p -> inStock == null || !inStock || p.getAmount() > 0)
                .toList();
    }

    @Override
    public List<String> getAllManufacturers() {
        return productRepository.findAllManufacturers();
    }

    public Double getAverageRating(Long productId) {
        Product product = productRepository.findById(productId).orElse(null);
        if (product == null || product.getReviews().isEmpty()) return 0.0;
        return product.getReviews().stream()
                .mapToInt(Review::getRating)
                .average()
                .orElse(0.0);
    }

    public List<Product> getProductsSortedByRating() {
        List<Product> products = productRepository.findAll();

        // сортируем по среднему рейтингу
        products.sort((p1, p2) -> {
            double r1 = getAverageRating(p1.getId());
            double r2 = getAverageRating(p2.getId());
            return Double.compare(r2, r1); // по убыванию
        });

        return products;
    }
}
