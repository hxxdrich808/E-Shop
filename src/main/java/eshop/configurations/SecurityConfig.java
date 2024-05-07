package eshop.configurations;


import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.LogoutConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@EnableWebSecurity
@Configuration
@RequiredArgsConstructor
@EnableMethodSecurity
public class SecurityConfig{
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests((requests -> requests
                        .requestMatchers("/", "/Product/**", "/images/**", "/registration", "/user/", "/static/", "/About", "/check-username", "/check-mail", "/check-phone", "/profile/**","/pcbuilder/**").permitAll()
                        .anyRequest().authenticated()
                ))
                .formLogin((form -> form
                        .loginPage("/login")
                        .defaultSuccessUrl("/")
                        .permitAll()
                ))
                .logout(LogoutConfigurer::permitAll);
        return http.build();
    }
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(8);
    }
}
