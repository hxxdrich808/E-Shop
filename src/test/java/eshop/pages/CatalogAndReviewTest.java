package eshop.pages;

import eshop.pages.*;
import org.junit.jupiter.api.*;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.*;

import static org.junit.jupiter.api.Assertions.*;

public class CatalogAndReviewTest {
    private static WebDriver driver;
    private CatalogPage catalog;
    private ProductPage product;

    @BeforeAll
    static void setupDriver() {
        System.setProperty("webdriver.chrome.driver", "/path/to/chromedriver");
        driver = new ChromeDriver();
    }

    @BeforeEach
    void initPages() {
        catalog = new CatalogPage(driver);
        product = new ProductPage(driver);
    }

    @AfterAll
    static void tearDown() {
        driver.quit();
    }

    @Test
    void leaveReviewTest() {
        product.open(5L)
                .leaveReview(5, "Автотестовый отзыв");
        assertTrue(product.isReviewPresent("Автотестовый отзыв"));
    }
}

