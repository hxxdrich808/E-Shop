package eshop.dto;

import eshop.models.Product;
import lombok.Getter;

@Getter
public class ProductDTO {
    private Long id;
    private String title;
    private int price;
    private Long previewImageId;

    public ProductDTO(Product product) {
        this.id = product.getId();
        this.title = product.getTitle();
        this.price = product.getPrice();
        this.previewImageId = product.getPreviewImage() != null
                ? product.getPreviewImage().getId()
                : null;
    }
}
