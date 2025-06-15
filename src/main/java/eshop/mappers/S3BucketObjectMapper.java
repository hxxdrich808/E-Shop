package eshop.mappers;

import java.io.InputStream;

public record S3BucketObjectMapper(String key, InputStream inputStream) {

}
