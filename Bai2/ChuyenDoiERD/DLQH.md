Bước 1: Xác định các thực thể trong ERD
1. PHIEUXUAT (Phiếu xuất): Lưu thông tin chung của phiếu xuất kho.
2. VATTU (Vật tư): Lưu thông tin danh mục vật tư/hàng hóa.
3. PHIEUNHAP (Phiếu nhập): Lưu thông tin chung của phiếu nhập.
4. DONDH (Đơn đặt hàng): Lưu thông tin đơn đặt hàng.
5. NHACC (Nhà cung cấp): Lưu thông tin nhà cung cấp.

Bước 2: Xác định các mối quan hệ và tạo bảng
1. Mối quan hệ nhiều nhiều
- (1) Chi tiết phiếu xuất: PHIEUXUAT và VATTU (N - N)
    + Tạo bảng CHITIETPHIEUXUAT
    + Khóa chính: SoPX, MaVTU
    + Các trường: SoPX, MaVTU, DGXuat, SLXuat
- (2) Chi tiết phiếu nhập: PHIEUNHAPvà VATTU(N - N)
    + Tạo bảng: CHITIETPHIEUNHAP
    + Khóa chính: SoPN, MaVTU
    + Các trường: SoPN, MaVTU, DGNhap, SLNhap
- (3) Chi tiết đơn hàng: DONDHvà VATTU(N - N)
    + Tạo bảng: CHITIETDONDH
    + Khóa chính: SoDH, MaVTU
    + Các trường: SoDH, MaVTU
2. Mối quan hệ một nhiều
- (4) Cung cấp: NHACC(1) và DONDH(N)
    + Bổ sung khóa chính của bên "1" MaNCC vào bên "N" DONDH làm khóa ngoại
    + Bảng DONDH sẽ chứa các trường: SoDH, NgayDH, MaNCC

Bước 3: XáC định giá trị đa thuộc tính và tạo bảng mới
- NHACC có thuộc tính SĐT vẽ bằng dấu đôi là thuộc tính đa giá trị.
    + Tạo bảng mới: NHACC_SDT
    + Khóa chính: MaNCC, SDT
    + Các trường: MaNCC, SDT

Bước 4: Danh sách các bảng sau khi chuyển đổi
1. PHIEUXUAT (SoPX , NgayXuat)
2. VATTU (MaVTU , TenVTU)
3. PHIEUNHAP (SoPN , NgayNhap)
4. NHACC (MaNCC , TenNCC, DiaChi)
5. DONDH (SoDH , NgàyDH, MaNCC (FK) )
6. CHITIETPHIEUXUAT (SoPX (FK) , MaVTU (FK) , DGXuat, SLXuat)
7. CHITIETPHIEUNHAP (SoPN (FK) , MaVTU (FK) , DGNhap, SLNhap)
8. CHITIETDONDH (SoDH (FK) , MaVTU (FK) )
9. NHACC_SDT (MaNCC (FK) , SDT )