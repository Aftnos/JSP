import java.security.Provider;
import java.util.List;

import com.ServiceLayer;
import com.entity.Category;
import com.dao.CategoryDAO;

public class Test {
    public static void main(String[] args) throws Exception {
        List<Category>  fenlei  = ServiceLayer.listCategories();
        System.out.println("分类:"+ fenlei);
    }
}