package eshop.services.implementations;

import eshop.models.Image;
import eshop.models.Product;
import eshop.repositories.ImageRepository;
import eshop.repositories.ProductRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.core.ResponseInputStream;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectResponse;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import static eshop.utils.FileUtils.cleanFileName;

@Slf4j
@Service
@RequiredArgsConstructor
public class ImageServiceImpl {

    private final ImageRepository imageRepository;
    private final ProductRepository productRepository;
    private final S3Client s3Client;

    @Value("${cloud.aws.s3.bucket-name}")
    private String bucketName;

    public byte[] downloadImage(Long imageId) {
        Image image = imageRepository.findById(imageId)
                .orElseThrow(() -> new RuntimeException("Изображение не найдено"));

        String key = image.getS3Key();
        GetObjectRequest request = GetObjectRequest.builder()
                .bucket(bucketName)
                .key(key)
                .build();

        try (ResponseInputStream<GetObjectResponse> s3Object = s3Client.getObject(request)) {
            log.info("Downloading from S3: bucket={}, key={}", bucketName, key);
            return s3Object.readAllBytes();
        } catch (IOException e) {
            throw new RuntimeException("Ошибка при чтении изображения из S3", e);
        }
    }

    public void deleteImageById(Long imageId) {
        Image image = imageRepository.findById(imageId)
                .orElseThrow(() -> new RuntimeException("Изображение не найдено"));

        s3Client.deleteObject(DeleteObjectRequest.builder()
                .bucket(bucketName)
                .key(image.getS3Key())
                .build());

        imageRepository.deleteById(imageId);
    }

    public Image uploadImageForProduct(Long productId, MultipartFile file) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Товар не найден"));
        String clearFileName = cleanFileName(Objects.requireNonNull(file.getOriginalFilename()));

        try {
            PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                    .bucket(bucketName)
                    .key(clearFileName)
                    .contentType(file.getContentType())
                    .build();

            s3Client.putObject(putObjectRequest, RequestBody.fromInputStream(file.getInputStream(), file.getSize()));

            String url = String.format("http://localhost:9000/%s/%s", bucketName, clearFileName);

            Image image = new Image();
            image.setName(file.getName());
            image.setFileName(clearFileName);
            image.setSize(file.getSize());
            image.setContentType(file.getContentType());
            image.setS3Key(clearFileName);
            image.setUrl(url);
            image.setProduct(product);

            return imageRepository.save(image);
        } catch (IOException e) {
            throw new RuntimeException("Ошибка при загрузке изображения", e);
        }
    }

    public List<Image> uploadMultipleImagesForProduct(Long productId, List<MultipartFile> files) {
        List<Image> uploadedImages = new ArrayList<>();
        for (MultipartFile file : files) {
            Image image = uploadImageForProduct(productId, file);
            uploadedImages.add(image);
        }
        return uploadedImages;
    }

}
