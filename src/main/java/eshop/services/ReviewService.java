package eshop.services;

import eshop.models.Review;
import eshop.models.User;

import java.util.List;

public interface ReviewService {
    List<Review> getReviewsByProductId(Long productId);
    void addReview(Long productId, String comment, int rating, User author);
}