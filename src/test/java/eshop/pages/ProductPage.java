package eshop.pages;

import org.openqa.selenium.*;
import org.openqa.selenium.support.ui.*;

import java.time.Duration;

public class ProductPage {
    private final WebDriver driver;
    private final WebDriverWait wait;

    public ProductPage(WebDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(5));
    }

    public ProductPage open(Long productId) {
        driver.get("http://localhost:8080/Product/" + productId);
        return this;
    }

    public ProductPage leaveReview(int rating, String comment) {
        wait.until(d -> d.findElement(By.name("rating"))).click();
        WebElement radio = driver.findElement(By.cssSelector("input[name=rating][value='"+rating+"']"));
        radio.click();
        WebElement textarea = driver.findElement(By.name("comment"));
        textarea.clear();
        textarea.sendKeys(comment);
        driver.findElement(By.cssSelector("form.review-form button[type=submit]")).click();
        return this;
    }

    public boolean isReviewPresent(String comment) {
        return driver.findElements(By.xpath("//div[@class='review-block' and contains(., '"+comment+"')]")).size() > 0;
    }
}
