import java.util.Scanner;
import com.entity.Product;
import com.entity.ProductImage;

public class Test {
    public static void main(String[] args) throws Exception {
        Scanner scanner = new Scanner(System.in);
        System.out.print("请输入一个商品ID: ");
        int productId = scanner.nextInt();
        Product sp = com.ServiceLayer.getProductById(productId);
        ProductImage img = com.ServiceLayer.getProductImageById(productId);
        System.out.println("商品ID: " + sp.getId());
        System.out.println("商品名称: " + sp.getName());
        System.out.println("商品数量: " + sp.getStock());
        System.out.println("商品价格: " + sp.getPrice());
        System.out.println("商品介绍: " + sp.getDescription());
        System.out.println("商品图片: " + (img != null ? img.getUrl() : "无图片"));
    }
}
