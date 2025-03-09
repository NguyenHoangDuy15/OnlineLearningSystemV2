/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import Model.Category;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;

/**
 *
 * @author Administrator
 */
public class CategoryDao extends DBContext {

    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT CategoryID, CategoryName, Description FROM Category";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                categories.add(new Category(rs.getInt("CategoryID"), rs.getString("CategoryName"), rs.getString("Description")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    public static void main(String[] args) {

        CategoryDao dao = new CategoryDao();
        List<Category> categories = dao.getAllCategories();

        if (categories.isEmpty()) {
            System.out.println("Không có danh mục nào trong cơ sở dữ liệu.");
        } else {
            System.out.println("Danh sách danh mục:");
            for (Category category : categories) {
                System.out.println("ID: " + category.getCategoryId()
                        + ", Name: " + category.getDescription()
                        + ", Description: " + category.getDescription());
            }
        }
    }
}
