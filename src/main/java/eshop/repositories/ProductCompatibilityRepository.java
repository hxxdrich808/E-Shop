package eshop.repositories;

import eshop.models.ProductCompatibility;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductCompatibilityRepository extends JpaRepository<ProductCompatibility, Long> {
    ProductCompatibility findByChipset(String chipset);
    ProductCompatibility findBySocket(String socket);
    ProductCompatibility findByDdr(String ddr);
    ProductCompatibility findByGddr(String gddr);
    ProductCompatibility findByFormat(String format);
    List<ProductCompatibility> findByM2slot(boolean m2slot);
}
