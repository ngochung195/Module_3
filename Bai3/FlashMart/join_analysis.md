Lý do dùng COUNT(o.order_id) thay vì COUNT(*):

Trong phép LEFT JOIN, những khách hàng chưa từng mua hàng (như Charlie) vẫn được giữ lại, nhưng dữ liệu bảng Orders tương ứng sẽ mang giá trị NULL.

COUNT(*) đếm tất cả các dòng trả về, nên sẽ đếm cả dòng chứa NULL này và cho ra kết quả sai là 1 đơn hàng.

COUNT(o.order_id) chỉ đếm các giá trị khác NULL tại cột order_id. Khi khách hàng chưa có đơn, cột này bằng NULL nên hàm đếm chính xác là 0 đơn hàng.