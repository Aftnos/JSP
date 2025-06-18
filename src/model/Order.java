package model;

import java.util.Date;

public class Order {
    private int id;
    private int userId;
    private Date orderDate;
    private String status;
    private double total;

    public Order() {}

    public Order(int id, int userId, Date orderDate, String status, double total) {
        this.id = id;
        this.userId = userId;
        this.orderDate = orderDate;
        this.status = status;
        this.total = total;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }
}
