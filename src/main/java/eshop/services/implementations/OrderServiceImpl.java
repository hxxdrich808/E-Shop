package eshop.services.implementations;

import eshop.models.*;
import eshop.models.enums.OrderStatus;
import eshop.repositories.*;
import eshop.services.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {

    private final OrderRepository orderRepository;
    private final CartRepository cartRepository;

    @Override
    public void createOrderFromCart(Cart cart, String fullName, String phone, String address, String postalCode) {
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            throw new IllegalStateException("Корзина пуста.");
        }

        // Создаём заказ
        Order order = new Order();
        order.setUser(cart.getUser());
        order.setDate(LocalDateTime.now());
        order.setStatus(OrderStatus.CREATED); // или другой статус по-умолчанию
        order.setTotalPrice(cart.getItems().stream()
                .mapToDouble(item -> item.getProduct().getPrice() * item.getQuantity())
                .sum());
        order.setCustomerFullName(fullName);
        order.setCustomerPhone(phone);
        order.setAddress(address);
        order.setPostalCode(postalCode);

        // Копируем товары из корзины в заказ
        List<OrderItem> orderItems = cart.getItems().stream().map(cartItem -> {
            OrderItem orderItem = new OrderItem();
            orderItem.setOrder(order);
            orderItem.setProduct(cartItem.getProduct());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setPrice(cartItem.getProduct().getPrice());
            return orderItem;
        }).collect(Collectors.toList());
        order.setItems(orderItems);

        // Сохраняем заказ
        orderRepository.save(order);

        // Очищаем корзину пользователя
        cart.getItems().clear();
        cartRepository.save(cart);
    }
}
