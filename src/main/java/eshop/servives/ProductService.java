package eshop.servives;

import eshop.models.ProductCompatibility;
import eshop.models.enums.ProductType;
import eshop.models.Image;
import eshop.models.Product;
import eshop.models.ProductCompatibility;
import eshop.models.User;
import eshop.repositories.ProductCompatibilityRepository;
import eshop.repositories.ProductRepository;
import eshop.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.Principal;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductService {

    private final ProductRepository productRepository;
    private final UserRepository userRepository;
    private final ProductCompatibilityRepository productCompatibilityRepository;

    public List<Product> listProducts(String title){
        if (title != null)return productRepository.findByTitle(title);
        return productRepository.findAll();
    }

    public void saveProduct(ProductType productType, Product product, ProductCompatibility productCompatibility, MultipartFile file1, MultipartFile file2, MultipartFile file3) throws IOException {
        Image image1;
        Image image2;
        Image image3;
        product.setProductType(productType);
        //возможно стоит вынести сохранение совместимости продукта в отдельный метод
        switch (productType){
            case CPU -> productCompatibilityRepository.save(productCompatibility);
            case MOTHERBOARD -> productCompatibilityRepository.save(productCompatibility);
            case CASE -> productCompatibilityRepository.save(productCompatibility);
            case GPU -> productCompatibilityRepository.save(productCompatibility);
            case RAM -> productCompatibilityRepository.save(productCompatibility);
            case DRIVE -> productCompatibilityRepository.save(productCompatibility);
        }
        if(file1.getSize() != 0){
            image1 = toImageEntity(file1);
            image1.setPreviewImage(true);
            product.addImageToProduct(image1);
        }
        if(file2.getSize() != 0){
            image2 = toImageEntity(file2);
            product.addImageToProduct(image2);
        }
        if(file3.getSize() != 0){
            image3 = toImageEntity(file3);
            product.addImageToProduct(image3);
        }
        log.info("Saving new Product. Title: {}", product.getTitle());
        Product productFromDB = productRepository.save(product);
        productFromDB.setPreviewImageId(productFromDB.getImages().get(0).getId());
        productRepository.save(product);
    }

    public User getUserByPrincipal(Principal principal){
        if(principal == null) return new User();
        return userRepository.findByEmail(principal.getName());
    }

    private Image toImageEntity(MultipartFile file) throws IOException {
        Image image = new Image();
        image.setName(file.getName());
        image.setFileName(file.getOriginalFilename());
        image.setContentType(file.getContentType());
        image.setSize(file.getSize());
        image.setBytes(file.getBytes());
        return image;
    }

    public void deleteProduct(Long id){
        log.info("Deleting product {}",id);
        productRepository.deleteById(id);
    }

    public Product getProductById(Long id) {
        log.info("Getting product by {}",id);
        return productRepository.findById(id).orElse(null);
    }
}
