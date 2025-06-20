package com.entity;

public class AfterSale {
    private int id;
    private int userId;
    private String snCode;
    private String type;
    private String reason;
    private String status;
    private String remark;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getSnCode() { return snCode; }
    public void setSnCode(String snCode) { this.snCode = snCode; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
}
