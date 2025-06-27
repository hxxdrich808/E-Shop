package eshop.pages;

import org.openqa.selenium.*;
import org.openqa.selenium.support.ui.*;

import java.time.Duration;

public class CatalogPage {
    private final WebDriver driver;
    private final WebDriverWait wait;

    public CatalogPage(WebDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(5));
    }

    public CatalogPage open() {
        driver.get("http://localhost:8080/");
        return this;
    }

    public CatalogPage search(String term) {
        WebElement input = driver.findElement(By.id("searchWord"));
        input.clear();
        input.sendKeys(term);
        input.submit();
        return this;
    }

    public boolean isProductVisible(String title) {
        wait.until(d -> d.findElements(By.cssSelector(".product-card")).size() > 0);
        return driver.findElements(By.xpath("//h5[text()='"+title+"']")).size() > 0;
    }

    public CatalogPage filterByType(String type) {
        Select sel = new Select(driver.findElement(By.id("type")));
        sel.selectByVisibleText(type);
        driver.findElement(By.cssSelector(".filter-form button[type=submit]")).click();
        return this;
    }
}
