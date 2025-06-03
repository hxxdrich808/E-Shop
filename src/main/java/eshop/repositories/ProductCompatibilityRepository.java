package eshop.repositories;

import eshop.models.ProductCompatibility;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductCompatibilityRepository extends JpaRepository<ProductCompatibility, Long> {
    List<ProductCompatibility> findByChipset(String chipset);

    List<ProductCompatibility> findBySocket(String socket);

    List<ProductCompatibility> findByDdr(String ddr);

    List<ProductCompatibility> findByGddr(String gddr);

    List<ProductCompatibility> findByFormat(String format);

    List<ProductCompatibility> findByM2slot(boolean m2slot);

    ProductCompatibility findByProductId(Long productId);
}
