package eshop.repositories;

import eshop.models.User;
import eshop.models.enums.Role;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;

@DataJpaTest
@AutoConfigureMockMvc
@Slf4j
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
public class UserRepositoryTest {

    @Autowired
    private UserRepository userRepository;
    private static final String userEmail = "123123@mail.ru";
    @BeforeAll
    public static void setup(){
        log.info("startup - creating DB connection");
    }
    @BeforeEach
    public void before() {
        User user = new User();
        user.setId(666L);
        user.setName("hxxdrich");
        user.setPhoneNumber("+79999999999");
        user.setEmail("123123@mail.ru");
        user.setPassword(userEmail);
        user.setActive(true);
        user.getRoles().add(Role.ROLE_USER);
        userRepository.save(user);
    }

    @Test
    void getRealUserByEmail(){
        User user = userRepository.findByEmail(userEmail);
        if (user == null){
            assert(false);
        }else {
            assert(user.getEmail().equals(userEmail));
        }
    }
    @Test
    void getNotRealUserByEmail(){
        User user = userRepository.findByEmail("111@mail.ru");
        if (user == null){
            assert(true);
        }else {
            assert(false);
        }
    }
    @AfterEach
    public void after() {
        userRepository.deleteById(666L);
    }
    @AfterAll
    public static void dropDown(){
        log.info("closing DB connection");
    }
}
