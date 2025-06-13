package eshop.services;

import eshop.models.Order;
import eshop.models.User;

public interface OrderService {
    Order createOrderFromCart(User user);
}
