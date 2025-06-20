package com.entity;

import java.util.Date;

public class Binding {
    private int id;
    private int userId;
    private String snCode;
    private Date bindTime;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getSnCode() { return snCode; }
    public void setSnCode(String snCode) { this.snCode = snCode; }

    public Date getBindTime() { return bindTime; }
    public void setBindTime(Date bindTime) { this.bindTime = bindTime; }
}
