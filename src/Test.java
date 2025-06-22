import java.security.Provider;
import java.util.List;
import java.util.Scanner;

import com.ServiceLayer;
import com.entity.CartItem;
import com.entity.Category;
import com.dao.CategoryDAO;

public class Test {
    public static void main(String[] args) throws Exception {
        Scanner scanner = new Scanner(System.in);
        System.out.print("请输入一个用户ID: ");
        int userId = scanner.nextInt();
        System.out.print("请输入一个商品ID: ");
        int productId = scanner.nextInt();
        System.out.print("请输入一个数量: ");
        int number = scanner.nextInt();

        com.entity.CartItem cartItem = new com.entity.CartItem();
        cartItem.setUserId(userId);
        cartItem.setProductId(productId);
        cartItem.setQuantity(number);

    }
}