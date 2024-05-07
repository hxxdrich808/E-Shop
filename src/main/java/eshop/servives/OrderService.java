package eshop.servives;

import eshop.models.Orders;
import eshop.repositories.OrderRepository;
import eshop.repositories.ProductRepository;
import eshop.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class OrderService {

    private final ProductRepository productRepository;
    private final UserRepository userRepository;
    private final OrderRepository orderRepository;

    private List<Orders> listOrders(Long id){
        List<Orders> orders = orderRepository.findAll();
        if (id != null)return orderRepository.findAllById(id);
        return orderRepository.findAll();
    }
}
