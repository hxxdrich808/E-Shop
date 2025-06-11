package eshop.models;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "Statuses")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Status {

    @Id
    @Column(name = "order_id")
    private Long orderId;

    @OneToOne
    @MapsId
    @JoinColumn(name = "order_id")
    private Order order;

    @Column(name = "state", nullable = false)
    private String state;
}
