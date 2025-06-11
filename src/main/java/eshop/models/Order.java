package eshop.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDateTime;
import java.util.List;


@Entity
@Table(name = "Orders")
@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(mappedBy = "order", cascade = CascadeType.ALL)
    private Status status;

    private LocalDateTime orderDate;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToMany
    @JoinTable(
            name = "order_products",
            joinColumns = @JoinColumn(name = "order_id"),
            inverseJoinColumns = @JoinColumn(name = "product_id")
    )
    private List<Product> products;

    @PrePersist
    private void init() {
        orderDate = LocalDateTime.now();
    }
}
