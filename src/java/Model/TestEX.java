/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author CONG NINH
 */
import java.util.*;
import java.lang.*;
import java.io.*;

public class TestEX {

    int testID;
    String name;
    int status;
    String createdBy;
    int courseID;

    public TestEX(int testID, String name, int status, String createdBy, int courseID) {
        this.testID = testID;
        this.name = name;
        this.status = status;
        this.createdBy = createdBy;
        this.courseID = courseID;
    }

    public TestEX() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public int getTestID() {
        return testID;
    }

    public void setTestID(int testID) {
        this.testID = testID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public int getCourseID() {
        return courseID;
    }

    public void setCourseID(int courseID) {
        this.courseID = courseID;
    }

    @Override
    public String toString() {
        return "Test{" + "testID=" + testID + ", name=" + name + ", status=" + status + ", createdBy=" + createdBy + ", courseID=" + courseID + '}';
    }

}
