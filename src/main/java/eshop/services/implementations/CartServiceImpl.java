package eshop.services.implementations;

import eshop.models.*;
import eshop.repositories.CartItemRepository;
import eshop.repositories.CartRepository;
import eshop.repositories.ProductRepository;
import eshop.services.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CartServiceImpl implements CartService {

    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;
    private final ProductRepository productRepository;

    @Override
    public Cart getCartByUser(User user) {
        return cartRepository.findByUser(user).orElseGet(() -> {
            Cart cart = new Cart();
            cart.setUser(user);
            return cartRepository.save(cart);
        });
    }

    @Override
    public void addProductToCart(User user, Product product) {
        Cart cart = getCartByUser(user);
        Optional<CartItem> cartItemOptional = cart.getItems().stream()
                .filter(item -> item.getProduct().getId().equals(product.getId()))
                .findFirst();

        if (cartItemOptional.isPresent()) {
            CartItem item = cartItemOptional.get();
            item.setQuantity(item.getQuantity() + 1);
            cartItemRepository.save(item);
        } else {
            CartItem item = new CartItem();
            item.setCart(cart);
            item.setProduct(product);
            item.setQuantity(1);
            cartItemRepository.save(item);
        }
    }

    @Override
    public void removeProductFromCart(User user, Product product) {
        Cart cart = getCartByUser(user);
        cart.getItems().removeIf(item -> item.getProduct().getId().equals(product.getId()));
        cartRepository.save(cart);
    }

    @Override
    public void incrementProduct(User user, Product product) {
        Cart cart = getCartByUser(user);
        for (CartItem item : cart.getItems()) {
            if (item.getProduct().getId().equals(product.getId())) {
                item.setQuantity(item.getQuantity() + 1);
                cartItemRepository.save(item);
            }
        }
    }

    @Override
    public void decrementProduct(User user, Product product) {
        Cart cart = getCartByUser(user);
        for (CartItem item : cart.getItems()) {
            if (item.getProduct().getId().equals(product.getId())) {
                if (item.getQuantity() > 1) {
                    item.setQuantity(item.getQuantity() - 1);
                    cartItemRepository.save(item);
                } else {
                    removeProductFromCart(user, product);
                }
            }
        }
    }

    @Override
    public double calculateTotalPrice(Cart cart) {
        return cart.getItems().stream()
                .mapToDouble(item -> item.getProduct().getPrice() * item.getQuantity())
                .sum();
    }
}
