package eshop.models.enums;

public enum OrderStatus {
    CREATED("Создан"),
    CONFIRMED("Подтверждён"),
    IN_THE_ASSEMBLY("В сборке"),
    READY_TO_SHIP("Готов к отправке"),
    SENT("Отправлен"),
    READY_TO_RECEIVE("Готов к получению"),
    RECEIVED("Получен");

    private final String displayName;

    OrderStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}