package eshop.services.implementations;

import eshop.models.Order;
import eshop.models.Status;
import eshop.repositories.OrderRepository;
import eshop.services.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {

    private final OrderRepository orderRepository;

    @Override
    public List<Order> getOrders(){
        return orderRepository.findAll();
    }

    @Override
    public Order updateOrderStatus(Long orderId, Status newStatus) {
        return orderRepository.findById(Math.toIntExact(orderId))
                .map(order -> {
                    order.setStatus(newStatus);
                    return orderRepository.save(order);
                })
                .orElseThrow(() -> new IllegalArgumentException("Order with ID " + orderId + " not found"));
    }

    @Override
    public List<Order> getOrdersByUserId(Long userId) {
        return orderRepository.findByUserId(userId);
    }
}
