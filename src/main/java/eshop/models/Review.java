package eshop.models;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Entity(name = "reviews")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Review {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Рейтинг: только целые значения 1-5
    @Column(nullable = false)
    private int rating;

    // Текст отзыва до 350 символов
    @Column(length = 350)
    private String comment;

    // Дата создания
    private LocalDateTime createdAt;

    // Автор отзыва
    @ManyToOne(fetch = FetchType.LAZY)
    private User author;

    // Связь с продуктом
    @ManyToOne(fetch = FetchType.LAZY)
    private Product product;

    @Transient
    public String getFormattedCreatedDate() {
        return createdAt.format(DateTimeFormatter.ofPattern("dd.MM.yyyy HH:mm"));
    }

    @PrePersist
    public void onCreate() {
        createdAt = LocalDateTime.now();
    }
}
