1. Bối Cảnh & Lý Do Chấp Nhận Đánh Đổi

Hệ thống IoT SmartFactory liên tục ghi nhận dữ liệu cảm biến với tần suất cực lớn. Index cũ (idx_fat_covering) lưu trữ toàn bộ các cột làm cây B-Tree phình to ngốn đĩa cứng và đè nặng chi phí CPU/Disk I/O cho mỗi dòng log mới.

Việc chuyển sang Lean Index (chỉ giữ sensor_id, recorded_at) khiến câu lệnh SELECT của Dashboard mất tính chất Covering Index và phải thực hiện thao tác Bookmark Lookup vào bảng gốc. Tuy nhiên, thời gian đọc chỉ tăng khoảng 0.5 - 1 millisecond (mức người dùng không thể cảm nhận), đổi lại giải phóng hoàn toàn hạ tầng lưu trữ và tiến trình ghi log.

2. So Sánh Hiệu Năng Chi Tiết (Mô phỏng quy mô 1.000.000 dòng log)

Cấu trúc Index: Fat Index chứa 5 cột (béo phì) Lean Index giảm xuống 2 cột (tinh gọn 60% cột phụ tải).
Dung lượng Index (Index_length): Giảm từ ~420 MB xuống còn ~110 MB (tiết kiệm 74% đĩa cứng).
Tốc độ Ghi (INSERT Log): Tăng từ ~850 ops/sec lên ~4,200 ops/sec (tăng tốc 4.9 lần).
Thời gian Đọc (SELECT Dashboard): Chậm đi không đáng kể, từ ~1.2 ms lên ~1.8 ms (chỉ chênh lệch 0.6 ms).

3. Kết Luận
Đây là quyết định kiến trúc bắt buộc cho các hệ thống dạng IoT / Log-heavy: Chấp nhận hy sinh vài microsecond thời gian đọc của Dashboard để đổi lấy tốc độ ghi tăng gấp 5 lần và tiết kiệm 74% dung lượng ổ cứng, bảo vệ hệ thống khỏi nguy cơ tràn đĩa cứng và quá tải I/O.