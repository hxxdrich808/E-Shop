package eshop.services;

import eshop.models.Build;
import eshop.models.Product;
import eshop.models.enums.ProductType;

import java.util.List;

public interface PcBuilderService {
    List<Product> getNeededType(ProductType productType);

    List<Product> getCompatibleProduct(ProductType productType);

    void addToBuild(String productId, ProductType productType, Build build);

    Build saveBuild(Build build);
}
