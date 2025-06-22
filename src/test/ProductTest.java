package test;

import com.ServiceLayer;
import com.entity.Product;
import com.entity.Category;
import java.math.BigDecimal;
import java.util.List;

/**
 * 商品功能测试类
 * 测试 ServiceLayer 中与商品相关的所有方法
 */
public class ProductTest {
    
    public static void main(String[] args) {
        System.out.println("=== 商品功能测试开始 ===");
        
        // 测试所有功能
        testProductManagementIntegrity();
        testAddProduct();
        testListProducts();
        testGetProductById();
        testUpdateProduct();
        testDeleteProduct();
        testListProductsByCategory();
        
        System.out.println("=== 商品功能测试结束 ===");
    }
    
    /**
     * 测试商品管理功能的完整性
     */
    public static void testProductManagementIntegrity() {
        System.out.println("\n--- 测试商品管理功能完整性 ---");
        
        try {
            // 1. 获取所有商品
            List<Product> allProducts = ServiceLayer.listProducts();
            System.out.println("当前商品总数: " + (allProducts != null ? allProducts.size() : 0));
            
            // 2. 获取所有分类
            List<Category> allCategories = ServiceLayer.listCategories();
            System.out.println("当前分类总数: " + (allCategories != null ? allCategories.size() : 0));
            
            // 3. 显示现有商品
            if (allProducts != null && !allProducts.isEmpty()) {
                System.out.println("现有商品列表:");
                for (int i = 0; i < Math.min(5, allProducts.size()); i++) {
                    Product product = allProducts.get(i);
                    System.out.println("  ID: " + product.getId() + ", 名称: " + product.getName() + 
                                     ", 价格: " + product.getPrice() + ", 库存: " + product.getStock());
                }
                if (allProducts.size() > 5) {
                    System.out.println("  ... 还有 " + (allProducts.size() - 5) + " 个商品");
                }
            }
            
            System.out.println("商品管理功能基本正常");
            
        } catch (Exception e) {
            System.out.println("测试过程中发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 测试添加商品功能
     */
    public static void testAddProduct() {
        System.out.println("\n--- 测试添加商品功能 ---");
        
        try {
            // 获取分类ID用于测试
            List<Category> categories = ServiceLayer.listCategories();
            Integer categoryId = null;
            if (categories != null && !categories.isEmpty()) {
                categoryId = categories.get(0).getId();
            }
            
            // 创建测试商品
            Product testProduct = new Product();
            testProduct.setName("测试商品_" + System.currentTimeMillis());
            testProduct.setPrice(new BigDecimal("99.99"));
            testProduct.setStock(100);
            testProduct.setCategoryId(categoryId);
            testProduct.setDescription("这是一个测试商品，用于验证添加功能");
            
            System.out.println("正在添加测试商品: " + testProduct.getName());
            boolean result = ServiceLayer.addProduct(testProduct);
            
            if (result) {
                System.out.println("添加商品成功!");
                
                // 验证添加结果
                List<Product> products = ServiceLayer.listProducts();
                System.out.println("添加后商品总数: " + (products != null ? products.size() : 0));
                
                // 查找刚添加的商品
                if (products != null) {
                    for (Product p : products) {
                        if (p.getName().equals(testProduct.getName())) {
                            System.out.println("验证成功: 找到新添加的商品 ID: " + p.getId());
                            break;
                        }
                    }
                }
            } else {
                System.out.println("添加商品失败!");
            }
            
        } catch (Exception e) {
            System.out.println("测试添加商品时发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 测试获取商品列表功能
     */
    public static void testListProducts() {
        System.out.println("\n--- 测试获取商品列表功能 ---");
        
        try {
            List<Product> products = ServiceLayer.listProducts();
            
            if (products != null) {
                System.out.println("成功获取商品列表，共 " + products.size() + " 个商品");
                
                if (!products.isEmpty()) {
                    System.out.println("商品列表详情:");
                    for (Product product : products) {
                        System.out.println("  ID: " + product.getId() + 
                                         ", 名称: " + product.getName() + 
                                         ", 价格: " + product.getPrice() + 
                                         ", 库存: " + product.getStock() + 
                                         ", 分类ID: " + product.getCategoryId());
                    }
                }
            } else {
                System.out.println("获取商品列表失败，返回 null");
            }
            
        } catch (Exception e) {
            System.out.println("测试获取商品列表时发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 测试根据ID获取商品功能
     */
    public static void testGetProductById() {
        System.out.println("\n--- 测试根据ID获取商品功能 ---");
        
        try {
            // 先获取商品列表，选择一个商品进行测试
            List<Product> products = ServiceLayer.listProducts();
            
            if (products == null || products.isEmpty()) {
                System.out.println("没有商品可供测试");
                return;
            }
            
            Product firstProduct = products.get(0);
            int testId = firstProduct.getId();
            
            System.out.println("正在测试获取商品 ID: " + testId);
            Product retrievedProduct = ServiceLayer.getProductById(testId);
            
            if (retrievedProduct != null) {
                System.out.println("成功获取商品:");
                System.out.println("  ID: " + retrievedProduct.getId());
                System.out.println("  名称: " + retrievedProduct.getName());
                System.out.println("  价格: " + retrievedProduct.getPrice());
                System.out.println("  库存: " + retrievedProduct.getStock());
                System.out.println("  描述: " + retrievedProduct.getDescription());
                
                // 验证数据一致性
                if (retrievedProduct.getId() == firstProduct.getId() && 
                    retrievedProduct.getName().equals(firstProduct.getName())) {
                    System.out.println("数据一致性验证通过");
                } else {
                    System.out.println("警告: 数据一致性验证失败");
                }
            } else {
                System.out.println("获取商品失败，返回 null");
            }
            
            // 测试不存在的ID
            System.out.println("\n测试不存在的商品ID: 99999");
            Product nonExistentProduct = ServiceLayer.getProductById(99999);
            if (nonExistentProduct == null) {
                System.out.println("正确处理: 不存在的商品返回 null");
            } else {
                System.out.println("异常: 不存在的商品却返回了对象");
            }
            
        } catch (Exception e) {
            System.out.println("测试根据ID获取商品时发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 测试更新商品功能
     */
    public static void testUpdateProduct() {
        System.out.println("\n--- 测试更新商品功能 ---");
        
        try {
            // 先获取一个商品进行更新测试
            List<Product> products = ServiceLayer.listProducts();
            
            if (products == null || products.isEmpty()) {
                System.out.println("没有商品可供测试更新功能");
                return;
            }
            
            Product productToUpdate = products.get(0);
            System.out.println("选择商品进行更新测试: " + productToUpdate.getName() + " (ID: " + productToUpdate.getId() + ")");
            
            // 保存原始信息
            String originalName = productToUpdate.getName();
            BigDecimal originalPrice = productToUpdate.getPrice();
            int originalStock = productToUpdate.getStock();
            
            // 修改商品信息
            productToUpdate.setName(originalName + "_已更新");
            productToUpdate.setPrice(originalPrice.add(new BigDecimal("10.00")));
            productToUpdate.setStock(originalStock + 10);
            productToUpdate.setDescription("更新测试 - " + System.currentTimeMillis());
            
            System.out.println("正在更新商品信息...");
            boolean updateResult = ServiceLayer.updateProduct(productToUpdate);
            
            if (updateResult) {
                System.out.println("更新商品成功!");
                
                // 验证更新结果
                Product updatedProduct = ServiceLayer.getProductById(productToUpdate.getId());
                if (updatedProduct != null) {
                    System.out.println("验证更新结果:");
                    System.out.println("  新名称: " + updatedProduct.getName());
                    System.out.println("  新价格: " + updatedProduct.getPrice());
                    System.out.println("  新库存: " + updatedProduct.getStock());
                    System.out.println("  新描述: " + updatedProduct.getDescription());
                    
                    if (updatedProduct.getName().equals(productToUpdate.getName()) &&
                        updatedProduct.getPrice().equals(productToUpdate.getPrice()) &&
                        updatedProduct.getStock() == productToUpdate.getStock()) {
                        System.out.println("更新验证通过");
                    } else {
                        System.out.println("警告: 更新验证失败");
                    }
                }
                
                // 恢复原始信息
                productToUpdate.setName(originalName);
                productToUpdate.setPrice(originalPrice);
                productToUpdate.setStock(originalStock);
                ServiceLayer.updateProduct(productToUpdate);
                System.out.println("已恢复商品原始信息");
                
            } else {
                System.out.println("更新商品失败!");
            }
            
        } catch (Exception e) {
            System.out.println("测试更新商品时发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 测试删除商品功能
     */
    public static void testDeleteProduct() {
        System.out.println("\n--- 测试删除商品功能 ---");
        
        try {
            // 先添加一个测试商品用于删除
            Product testProduct = new Product();
            testProduct.setName("待删除测试商品_" + System.currentTimeMillis());
            testProduct.setPrice(new BigDecimal("1.00"));
            testProduct.setStock(1);
            testProduct.setDescription("这个商品将被删除");
            
            System.out.println("正在添加待删除的测试商品...");
            boolean addResult = ServiceLayer.addProduct(testProduct);
            
            if (!addResult) {
                System.out.println("无法添加测试商品，跳过删除测试");
                return;
            }
            
            // 找到刚添加的商品ID
            List<Product> products = ServiceLayer.listProducts();
            Product productToDelete = null;
            if (products != null) {
                for (Product p : products) {
                    if (p.getName().equals(testProduct.getName())) {
                        productToDelete = p;
                        break;
                    }
                }
            }
            
            if (productToDelete == null) {
                System.out.println("无法找到刚添加的测试商品");
                return;
            }
            
            int productId = productToDelete.getId();
            System.out.println("找到测试商品 ID: " + productId + ", 名称: " + productToDelete.getName());
            
            // 执行删除操作
            System.out.println("正在删除商品...");
            boolean deleteResult = ServiceLayer.deleteProduct(productId);
            
            if (deleteResult) {
                System.out.println("删除商品成功!");
                
                // 验证删除结果
                Product deletedProduct = ServiceLayer.getProductById(productId);
                if (deletedProduct == null) {
                    System.out.println("验证通过: 商品已被成功删除");
                } else {
                    System.out.println("警告: 删除操作返回成功，但商品仍然存在");
                }
                
                // 检查商品列表数量变化
                List<Product> productsAfterDelete = ServiceLayer.listProducts();
                System.out.println("删除后商品总数: " + (productsAfterDelete != null ? productsAfterDelete.size() : 0));
                
            } else {
                System.out.println("删除商品失败!");
            }
            
        } catch (Exception e) {
            System.out.println("测试删除商品时发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 测试按分类获取商品功能
     */
    public static void testListProductsByCategory() {
        System.out.println("\n--- 测试按分类获取商品功能 ---");
        
        try {
            // 获取所有分类
            List<Category> categories = ServiceLayer.listCategories();
            
            if (categories == null || categories.isEmpty()) {
                System.out.println("没有分类可供测试");
                return;
            }
            
            System.out.println("可用分类列表:");
            for (Category category : categories) {
                System.out.println("  分类ID: " + category.getId() + ", 名称: " + category.getName());
            }
            
            // 测试第一个分类
            Category firstCategory = categories.get(0);
            int categoryId = firstCategory.getId();
            
            System.out.println("\n正在获取分类 '" + firstCategory.getName() + "' (ID: " + categoryId + ") 下的商品...");
            List<Product> categoryProducts = ServiceLayer.listProductsByCategory(categoryId);
            
            if (categoryProducts != null) {
                System.out.println("该分类下共有 " + categoryProducts.size() + " 个商品");
                
                if (!categoryProducts.isEmpty()) {
                    System.out.println("商品列表:");
                    for (Product product : categoryProducts) {
                        System.out.println("  ID: " + product.getId() + 
                                         ", 名称: " + product.getName() + 
                                         ", 价格: " + product.getPrice());
                    }
                }
            } else {
                System.out.println("获取分类商品失败，返回 null");
            }
            
            // 测试不存在的分类ID
            System.out.println("\n测试不存在的分类ID: 99999");
            List<Product> nonExistentCategoryProducts = ServiceLayer.listProductsByCategory(99999);
            if (nonExistentCategoryProducts != null && nonExistentCategoryProducts.isEmpty()) {
                System.out.println("正确处理: 不存在的分类返回空列表");
            } else if (nonExistentCategoryProducts == null) {
                System.out.println("正确处理: 不存在的分类返回 null");
            } else {
                System.out.println("异常: 不存在的分类却返回了商品");
            }
            
        } catch (Exception e) {
            System.out.println("测试按分类获取商品时发生异常: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 测试单个商品删除功能
     * @param productId 要删除的商品ID
     * @return 测试结果信息
     */
    public static String testDeleteSingleProduct(int productId) {
        StringBuilder result = new StringBuilder();
        result.append("=== 测试删除商品功能 ===").append("\n");
        result.append("商品ID: ").append(productId).append("\n");
        
        try {
            // 1. 检查商品是否存在
            Product product = ServiceLayer.getProductById(productId);
            if (product == null) {
                result.append("错误: 商品不存在\n");
                return result.toString();
            }
            
            result.append("商品信息: ").append(product.getName()).append(" (价格: ").append(product.getPrice()).append(")\n");
            
            // 2. 执行删除操作
            result.append("正在执行删除操作...\n");
            boolean deleteResult = ServiceLayer.deleteProduct(productId);
            
            if (deleteResult) {
                result.append("删除成功!\n");
                
                // 3. 验证删除结果
                Product deletedProduct = ServiceLayer.getProductById(productId);
                if (deletedProduct == null) {
                    result.append("验证通过: 商品已被成功删除\n");
                } else {
                    result.append("警告: 删除操作返回成功，但商品仍然存在\n");
                }
            } else {
                result.append("删除失败!\n");
            }
            
        } catch (Exception e) {
            result.append("异常: ").append(e.getMessage()).append("\n");
            e.printStackTrace();
        }
        
        return result.toString();
    }
}