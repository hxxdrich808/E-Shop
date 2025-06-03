package eshop.services;

import eshop.models.User;

import java.security.Principal;
import java.util.List;
import java.util.Map;

public interface UserService {
    boolean createUser(User user);

    List<User> userList();

    void banUser(Long id);

    void changeUserRoles(User user, Map<String, String> form);

    User getUserByPrincipal(Principal principal);
}
