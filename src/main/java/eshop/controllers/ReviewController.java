package eshop.controllers;

import eshop.models.User;
import eshop.services.ReviewService;
import eshop.services.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;

@Slf4j
@Controller
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;
    private final UserService userService;
    private static final String REVIEW = "Добавлен отзыв для продукта \" + id + \": \" + comment + \" [\" + rating + \"]";

    @PostMapping("/Product/{id}/review")
    public String addReview(@PathVariable Long id,
                            @RequestParam String comment,
                            @RequestParam int rating,
                            Principal principal) {
        User user = userService.getUserByPrincipal(principal);
        reviewService.addReview(id, comment, rating, user);
        log.info(REVIEW);
        return "redirect:/Product/" + id;
    }

}
