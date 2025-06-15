package eshop.services.implementations;

import eshop.mappers.S3BucketObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.*;

import java.io.InputStream;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class S3ServiceImpl {

    @Value("${cloud.aws.s3.bucket-name}")
    private String bucketName;

    private final S3Client s3Client;

    @PostConstruct
    public void createInitialBucket() {
        if (s3Client.listBuckets().buckets().stream().noneMatch(bucket -> bucket.name().equals(bucketName))) {
            s3Client.createBucket(CreateBucketRequest.builder().bucket(bucketName).build());
        }
    }

    public void putObject(String bucketName, S3BucketObjectMapper s3BucketObjectMapper) {
        try {
            InputStream inputStream = s3BucketObjectMapper.inputStream();
            String key = s3BucketObjectMapper.key();
            PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .build();

            s3Client.putObject(
                    putObjectRequest,
                    RequestBody.fromInputStream(inputStream, inputStream.available())
            );
            log.info("Object uploaded to bucket '{}' with key '{}'", bucketName, key);
        } catch (Exception e) {
            log.error("Error uploading object: {}", e.getMessage());
        }
    }

    public void deleteObject(String bucketName, String objectName) {
        DeleteObjectRequest deleteObjectRequest = DeleteObjectRequest.builder()
                .bucket(bucketName)
                .key(objectName)
                .build();

        try {
            s3Client.deleteObject(deleteObjectRequest);
            log.info("Object deleted: {}", deleteObjectRequest.key());
        } catch (S3Exception e) {
            log.error("Error deleting object: {}", e.awsErrorDetails().errorMessage());
        }
    }

    public void deleteFolderWithProductImages(Long id) {
        String prefix = String.format("products/%d/", id);
        ListObjectsV2Request listRequest = ListObjectsV2Request.builder()
                .bucket(bucketName)
                .prefix(prefix)
                .build();

        ListObjectsV2Response listResponse = s3Client.listObjectsV2(listRequest);

        List<ObjectIdentifier> objects = listResponse.contents().stream()
                .map(o -> ObjectIdentifier.builder().key(o.key()).build())
                .toList();


        if (!objects.isEmpty()) {
            DeleteObjectsRequest deleteRequest = DeleteObjectsRequest.builder()
                    .bucket(bucketName)
                    .delete(Delete.builder().objects(objects).build())
                    .build();
            s3Client.deleteObjects(deleteRequest);
        }
    }

}

