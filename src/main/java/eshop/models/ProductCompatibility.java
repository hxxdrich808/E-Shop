package eshop.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "ProductsCompatibility")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProductCompatibility {

    @Id
    @Column(name = "prod_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long prodId;

    @Column(name = "chipset")
    private String chipset;

    @Column(name = "socket")
    private String socket;

    @Column(name = "ddr")
    private String ddr;

    @Column(name = "gddr")
    private String gddr;

    @Column(name = "m2slot")
    private boolean m2slot;

    @Column(name = "format")
    private String format;

    @OneToOne
    @MapsId
    @JoinColumn(name = "prod_id", referencedColumnName = "id")
    private Product product;

}
