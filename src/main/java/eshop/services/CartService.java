package eshop.services;

import eshop.models.Cart;
import eshop.models.Product;
import eshop.models.User;

public interface CartService {
    Cart getCartByUser(User user);
    void addProductToCart(User user, Product product);
    void removeProductFromCart(User user, Product product);
    void incrementProduct(User user, Product product);
    void decrementProduct(User user, Product product);
    double calculateTotalPrice(Cart cart);
}
