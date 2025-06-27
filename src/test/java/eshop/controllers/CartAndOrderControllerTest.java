package eshop.controllers;

import eshop.models.CartItem;
import eshop.models.Product;
import eshop.models.User;
import eshop.repositories.ProductRepository;
import eshop.services.implementations.UserServiceImpl;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestBuilders;
import org.springframework.test.web.servlet.MockMvc;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestBuilders.formLogin;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.response.SecurityMockMvcResultMatchers.authenticated;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
class CartAndOrderControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private UserServiceImpl userService;

    @Autowired
    private ProductRepository productRepository;

    private SecurityMockMvcRequestBuilders.FormLoginRequestBuilder login() throws Exception {
        return formLogin()
                .user("test@mail.ru").password("testpass");
    }

    @Test
    void addToCart_ShouldIncreaseItemCount() throws Exception {
        Product p = productRepository.findById(1L).orElseThrow();

        mockMvc.perform(formLogin().user("test@mail.ru").password("testpass"))
                .andExpect(authenticated());

        mockMvc.perform(post("/cart/add/1").with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/"));

        User user = userService.getUserByPrincipal(null);
        assertEquals(1, user.getCart().getItems().size());
        assertEquals(1, user.getCart().getItems().get(0).getQuantity());
    }

    @Test
    void incrementAndDecrementCartItem_ShouldAdjustQuantity() throws Exception {
        mockMvc.perform(post("/login").param("username","test@mail.ru")
                .param("password","testpass")).andExpect(authenticated());

        mockMvc.perform(post("/cart/add/1").with(csrf()));
        mockMvc.perform(post("/cart/increment/1").with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/cart"));

        mockMvc.perform(post("/cart/decrement/1").with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/cart"));

        User user = userService.getUserByPrincipal(null);
        CartItem item = user.getCart().getItems().stream()
                .filter(i -> i.getProduct().getId().equals(1L))
                .findFirst().orElseThrow();
        // После increment и decrement вернётся к 1
        assertEquals(1, item.getQuantity());
    }

    @Test
    void removeFromCart_ShouldEmptyCart() throws Exception {
        mockMvc.perform(post("/cart/add/1").with(csrf()));
        mockMvc.perform(post("/cart/remove/1").with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/cart"));

        User user = userService.getUserByPrincipal(null);
        assertTrue(user.getCart().getItems().isEmpty());
    }

    @Test
    void createOrderFromCart_WithEmptyCart_ShouldReturnError() throws Exception {
        User user = userService.getUserByPrincipal(null);
        user.getCart().getItems().clear();

        mockMvc.perform(post("/order/create")
                        .param("customerFullName", "Test User")
                        .param("customerPhone", "+70000000000")
                        .param("address", "Москва, ул. Тестовая 1")
                        .param("postalCode", "101000")
                        .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(model().attributeExists("cartError"));
    }
}