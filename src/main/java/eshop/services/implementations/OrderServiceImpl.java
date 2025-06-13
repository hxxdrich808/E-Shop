package eshop.services.implementations;

import eshop.models.CartItem;
import eshop.models.Order;
import eshop.models.OrderItem;
import eshop.models.User;
import eshop.models.enums.OrderStatus;
import eshop.repositories.CartItemRepository;
import eshop.repositories.OrderItemRepository;
import eshop.repositories.OrderRepository;
import eshop.repositories.ProductRepository;
import eshop.services.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {

    private final OrderRepository orderRepository;
    private final OrderItemRepository orderItemRepository;
    private final CartItemRepository cartItemRepository;
    private final ProductRepository productRepository;

    @Override
    public Order createOrderFromCart(User user) {
        List<CartItem> cartItems = cartItemRepository.findByCart(user.getCart());

        if (cartItems.isEmpty()) {
            throw new IllegalStateException("Корзина пуста.");
        }

        double totalPrice = cartItems.stream()
                .mapToDouble(item -> item.getProduct().getPrice() * item.getQuantity())
                .sum();

        Order order = Order.builder()
                .user(user)
                .status(OrderStatus.CREATED)
                .totalPrice(totalPrice)
                .date(LocalDateTime.now())
                .build();

        order = orderRepository.save(order);

        for (CartItem cartItem : cartItems) {
            OrderItem orderItem = OrderItem.builder()
                    .order(order)
                    .product(cartItem.getProduct())
                    .quantity(cartItem.getQuantity())
                    .price(cartItem.getProduct().getPrice())
                    .build();
            orderItemRepository.save(orderItem);
        }

        cartItemRepository.deleteAll(cartItems);

        return order;
    }
}
