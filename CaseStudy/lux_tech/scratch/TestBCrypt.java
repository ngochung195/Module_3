package scratch;

import com.electronicstore.model.User;
import com.electronicstore.service.UserService;

public class TestBCrypt {
    public static void main(String[] args) {
        UserService userService = new UserService();
        User adminUser = userService.login("admin", "123456");
        User staffUser = userService.login("staff", "123456");
        System.out.println("Admin login: " + adminUser);
        System.out.println("Staff login: " + staffUser);
    }
}
