package eshop.models;

import eshop.models.enums.OrderStatus;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Entity(name = "orders")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private User user;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    private List<OrderItem> items;

    private LocalDateTime date;

    @Enumerated(EnumType.STRING)
    private OrderStatus status;

    private double totalPrice;

    private String customerFullName;
    private String customerPhone;
    private String address;
    private String postalCode;

    @Transient
    private String formattedDate;

    public String getFormattedDate() {
        if (this.date != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm");
            return this.date.format(formatter);
        }
        return "";
    }
}

