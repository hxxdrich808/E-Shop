package eshop.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "Orders")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Orders {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Long id;
    @Column(name = "date")
    private LocalDateTime dateOfOrder;
    @Column(name = "user_email")
    private String userEmail;

    @ManyToMany
    @JoinTable(
            name = "product_orders",
            joinColumns = @JoinColumn(name = "order_id"),
            inverseJoinColumns = @JoinColumn(name = "product_id"))
    private List<Product> products;

    @Column(name = "price")
    private int price;

    @PrePersist
    private void init(){
        dateOfOrder = LocalDateTime.now();
    }
}
