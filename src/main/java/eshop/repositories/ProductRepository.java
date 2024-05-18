package eshop.repositories;

import eshop.models.Product;
import eshop.models.enums.ProductType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
@Repository
public interface ProductRepository extends JpaRepository<Product,Long> {
    List<Product> findByTitle(String title);
    List<Product> findByProductType(ProductType productType);
}
