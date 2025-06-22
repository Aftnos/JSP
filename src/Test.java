import java.util.Scanner;

import com.entity.Order;
import com.entity.Product;
import com.entity.ProductImage;

public class Test {
    public static void main(String[] args) throws Exception {
        Scanner scanner = new Scanner(System.in);
        System.out.print("请输入一个商品ID: ");
        int productId = scanner.nextInt();
        Order sp = com.ServiceLayer.getOrderById(productId);
        System.out.println("商品ID: " + sp.getId());
    }
}
