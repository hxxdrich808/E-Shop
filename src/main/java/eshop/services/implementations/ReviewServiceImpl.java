package eshop.services.implementations;

import eshop.models.Product;
import eshop.models.Review;
import eshop.models.User;
import eshop.repositories.ProductRepository;
import eshop.repositories.ReviewRepository;
import eshop.services.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ReviewServiceImpl implements ReviewService {

    private final ReviewRepository reviewRepository;
    private final ProductRepository productRepository;

    @Override
    public List<Review> getReviewsByProductId(Long productId) {
        return reviewRepository.findByProductId(productId);
    }

    @Override
    public void addReview(Long productId, String comment, int rating, User author) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));
        Review review = new Review();
        review.setProduct(product);
        review.setComment(comment);
        review.setRating(rating);
        review.setAuthor(author);
        reviewRepository.save(review);
    }
}