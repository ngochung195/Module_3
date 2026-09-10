package com.codegym.dao;

import com.codegym.model.User;
import java.sql.SQLException;
import java.util.List;

/**
 * Interface IUserDAO định nghĩa các phương thức CRUD cơ bản cho đối tượng User.
 * 
 * NGƯỜI HỌC TỰ THỰC HÀNH:
 * - Định nghĩa chữ ký cho các hàm:
 * + insertUser(User user): Thêm người dùng mới vào Database.
 * + selectUser(int id): Lấy thông tin người dùng theo ID.
 * + selectAllUsers(): Lấy danh sách toàn bộ người dùng.
 * + deleteUser(int id): Xóa người dùng theo ID.
 * + updateUser(User user): Cập nhật thông tin người dùng.
 */
public interface IUserDAO {
    public void insertUser(User user) throws Exception;

    public User selectUser(int id);

    public List<User> selectAllUsers();

    public boolean deleteUser(int id) throws Exception;

    public boolean updateUser(User user) throws Exception;

    public List<User> selectUsersByCountry(String country);

    public List<User> selectAllUsersSortedByName();

    public User getUserById(int id);

    public void insertUserStore(User user) throws SQLException;

    public void addUserTransaction(User user, int[] permissionIds) throws SQLException;

    public void insertUpdateWithoutTransaction() throws SQLException;

}
