package eshop.services.implementations;

import eshop.mappers.S3BucketObjectMapper;
import eshop.models.*;
import eshop.models.enums.ProductType;
import eshop.repositories.ImageRepository;
import eshop.repositories.ProductCompatibilityRepository;
import eshop.repositories.ProductRepository;
import eshop.repositories.UserRepository;
import eshop.services.ProductService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.Principal;
import java.util.List;
import java.util.Objects;

import static eshop.utils.FileUtils.cleanFileName;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductServiceImpl implements ProductService {

    @Value("${cloud.aws.s3.bucket-name}")
    private String bucketName;

    private final ProductRepository productRepository;
    private final UserRepository userRepository;
    private final ProductCompatibilityRepository productCompatibilityRepository;
    private final ImageRepository imageRepository;
    private final S3ServiceImpl s3Service;

    @Override
    public List<Product> listProducts(String title) {
        if (title != null) return productRepository.findByTitle(title);
        return productRepository.findAll();
    }

    @Override
    @Transactional
    public void saveProduct(ProductType productType, Product product, ProductCompatibility productCompatibility, List<MultipartFile> images) throws IOException {
        Product savedProduct = productRepository.save(product);
        if (images != null && !images.isEmpty()) {
            for (int i = 0; i < images.size(); i++) {
                MultipartFile file = images.get(i);
                Image image = uploadImageToS3(file, savedProduct);
                image = imageRepository.save(image);
                savedProduct.addImageToProduct(image);

                if (i == 0) {
                    savedProduct.setPreviewImage(image);
                }
            }

            productRepository.save(savedProduct);
        }
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

    private Image uploadImageToS3(MultipartFile file, Product product) throws IOException {
        String clearFileName = cleanFileName(Objects.requireNonNull(file.getOriginalFilename()));
        String key = String.format("products/%d/%s", product.getId(), clearFileName);

        s3Service.putObject(bucketName, new S3BucketObjectMapper(key, file.getInputStream()));

        Image image = new Image();
        image.setName(file.getName());
        image.setFileName(clearFileName);
        image.setContentType(file.getContentType());
        image.setSize(file.getSize());
        image.setS3Key(key);
        String url = String.format("http://localhost:9000/%s/%s", bucketName, key);
        image.setUrl(url);
        image.setProduct(product);

        return image;
    }
}
