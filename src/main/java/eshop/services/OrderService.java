package eshop.services;

import eshop.models.Cart;
import eshop.models.Order;
import eshop.models.User;

public interface OrderService {
    void createOrderFromCart(Cart cart, String fullName, String phone, String address, String postalCode);
}
