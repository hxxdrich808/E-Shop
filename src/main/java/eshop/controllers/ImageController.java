package eshop.controllers;

import eshop.models.Image;
import eshop.repositories.ImageRepository;
import eshop.services.implementations.ImageServiceImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.io.ByteArrayInputStream;

@RestController
@RequiredArgsConstructor
@RequestMapping("/images")
public class ImageController {
    private final ImageRepository imageRepository;
    private final ImageServiceImpl imageService;
    private static final String FILENAME = "fileName";


    @GetMapping("/{imageId}")
    public ResponseEntity<?> getImageById(@PathVariable Long imageId) {
        Image image = imageRepository.findById(imageId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        "Изображение не найдено"
                ));

        byte[] bytes = imageService.downloadImage(imageId);

        return ResponseEntity.ok()
                .header(FILENAME, image.getFileName())
                .contentType(MediaType.valueOf(image.getContentType()))
                .contentLength(image.getSize())
                .body(new InputStreamResource(new ByteArrayInputStream(bytes)));
    }

}
