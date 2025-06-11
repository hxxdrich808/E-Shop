package eshop.services;

import eshop.models.Order;
import eshop.models.Status;
import eshop.models.enums.OrderStatus;

import java.util.List;

public interface OrderService {
    List<Order> getOrders();

    Order updateOrderStatus(Long orderId, Status newStatus);

    List<Order> getOrdersByUserId(Long userId);
}
