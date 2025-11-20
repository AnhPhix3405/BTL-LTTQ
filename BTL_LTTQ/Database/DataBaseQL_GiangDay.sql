
create database QL_GiangDay
use QL_GiangDay
-- 1. Khoa (Tạo trước vì các bảng khác tham chiếu)
CREATE TABLE Khoa (
    MaKhoa VARCHAR(10) PRIMARY KEY,
    TenKhoa NVARCHAR(100) NOT NULL
);
go
-- 2. Môn Học (Tham chiếu Khoa)
CREATE TABLE MonHoc (
    MaMH VARCHAR(10) PRIMARY KEY,
    TenMH NVARCHAR(100) NOT NULL,
    SoTC INT,
    SoTietLT INT,
    SoTietTH INT,
    HeSoDQT DECIMAL(3,2) NOT NULL,
    HeSoThi DECIMAL(3,2) NOT NULL,
    MaKhoa VARCHAR(10),
    FOREIGN KEY (MaKhoa) REFERENCES Khoa(MaKhoa)
);
go
-- 3. Giảng Viên (Tham chiếu Khoa)
CREATE TABLE GiangVien (
    MaGV VARCHAR(10) PRIMARY KEY,
    TenGV NVARCHAR(100) NOT NULL,
    SDT VARCHAR(15),
    DiaChi NVARCHAR(255),
    NgaySinh DATE,
    TinhTrang NVARCHAR(50),
    HocHam NVARCHAR(50),
    HocVi NVARCHAR(50),
    MaKhoa VARCHAR(10),
    -- Các cột đã thêm
    GioiTinh NVARCHAR(10) NULL,
    Email VARCHAR(100) NULL,
    FOREIGN KEY (MaKhoa) REFERENCES Khoa(MaKhoa)
);
go
-- 4. Sinh Viên (Tham chiếu Khoa)
CREATE TABLE SinhVien (
    MaSV VARCHAR(10) PRIMARY KEY,
    TenSV NVARCHAR(100) NOT NULL,
    NgaySinh DATE,
    SDT NVARCHAR(15),
    Email NVARCHAR(100),
    GioiTinh NVARCHAR(10) CHECK (GioiTinh IN (N'Nam', N'Nữ')),
    QueQuan NVARCHAR(100),
    NgayNhapHoc DATE,
    MaKhoa VARCHAR(10),
    FOREIGN KEY (MaKhoa) REFERENCES Khoa(MaKhoa)
);
go
-- 11. Bảng Học Kỳ (Tạo trước)
-- Bảng này có khóa chính (HocKy, NamHoc) kiểu INT
-- để khớp chính xác với form của bạn.
CREATE TABLE HocKy (
    HocKy INT NOT NULL,          -- Ví dụ: 1, 2, 3 (là số học kỳ)
    NamHoc INT NOT NULL,         -- Ví dụ: 2025 (là năm học bắt đầu của học kỳ)

    TenHocKy NVARCHAR(100) NULL, -- Tên mô tả, ví dụ: 'Học kỳ 1 (2025-2026)'
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE NOT NULL,

    -- Khóa chính MỚI, khớp với các control trên form
    PRIMARY KEY (HocKy, NamHoc),

    CONSTRAINT CK_HocKy_NgayHoc CHECK (NgayKetThuc >= NgayBatDau),
    CONSTRAINT CK_HocKy_GiaTri CHECK (HocKy IN (1, 2, 3))
);
GO

-- 5. Lớp tín chỉ (Tham chiếu Môn Học)
CREATE TABLE LopTinChi (
    MaLop VARCHAR(10) PRIMARY KEY,
    NamHoc INT,
    MaMH VARCHAR(10),

    -- Các cột đã thêm
    TinhTrangLop BIT DEFAULT 0, -- 0: chưa phân công, 1: đã phân công
    HocKy INT NULL, -- Sửa thành INT để khớp với HocKy trong bảng HocKy

    FOREIGN KEY (MaMH) REFERENCES MonHoc(MaMH), -- Đã thêm dấu phẩy
    FOREIGN KEY (HocKy, NamHoc) REFERENCES HocKy(HocKy, NamHoc) -- Đã sửa lỗi cú pháp
);
go
-- 6. Tài Khoản (Tham chiếu Giảng Viên)
CREATE TABLE TaiKhoan (
    MaTK VARCHAR(10) PRIMARY KEY,
    TenDangNhap VARCHAR(50) NOT NULL UNIQUE,
    MatKhau VARCHAR(255) NOT NULL,
    LoaiTaiKhoan NVARCHAR(50),
    MaGV VARCHAR(10),
    FOREIGN KEY (MaGV) REFERENCES GiangVien(MaGV)
);
go
-- 7. Khu Vực
CREATE TABLE KhuVuc (
    MaKhuVuc VARCHAR(10) PRIMARY KEY,
    TenKhuVuc NVARCHAR(50) NOT NULL
);
go
-- 8. Phòng học
CREATE TABLE PhongHoc (
    MaPhong VARCHAR(20) PRIMARY KEY,  -- Ví dụ: A1-101, B-204, C-301
    MaKhuVuc VARCHAR(10),
    CONSTRAINT FK_PhongHoc_KhuVuc FOREIGN KEY (MaKhuVuc)
        REFERENCES KhuVuc(MaKhuVuc) ON DELETE CASCADE
);
go
-- 9. Phân công giảng dạy (Tham chiếu GV, Khoa, Lớp TC)
CREATE TABLE PhanCongGiangDay (
    MaPC VARCHAR(10) PRIMARY KEY,
    NgayPC DATE NOT NULL,
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE NOT NULL,
    CaHoc TINYINT NOT NULL,         -- 1..5
    Thu TINYINT NOT NULL,           -- 2..8 (2=Thứ Hai ... 8=Chủ Nhật)
    MaPhong VARCHAR(20) NOT NULL,
    MaGV VARCHAR(10) NOT NULL,
    MaLop VARCHAR(10) NOT NULL,
    CONSTRAINT FK_PhanCong_PhongHoc FOREIGN KEY (MaPhong)
        REFERENCES PhongHoc(MaPhong) ON DELETE CASCADE,
    CONSTRAINT FK_PhanCong_GiangVien FOREIGN KEY (MaGV)
        REFERENCES GiangVien(MaGV) ON DELETE CASCADE,
    CONSTRAINT FK_PhanCong_LopTinChi FOREIGN KEY (MaLop)
        REFERENCES LopTinChi(MaLop) ON DELETE CASCADE,
    CONSTRAINT CK_PhanCong_NgayHoc CHECK (NgayKetThuc >= NgayBatDau),
    CONSTRAINT CK_PhanCong_CaHoc CHECK (CaHoc BETWEEN 1 AND 5),
    CONSTRAINT CK_PhanCong_Thu CHECK (Thu BETWEEN 2 AND 8)
);
go
-- 10. Điểm (Tham chiếu Sinh Viên, Lớp TC)
CREATE TABLE Diem (
    MaSV VARCHAR(10),
    MaLop VARCHAR(10),
    DiemCC DECIMAL(4, 2),
    DiemGK DECIMAL(4, 2),
    DiemThi DECIMAL(4, 2),
    DiemKTHP DECIMAL(4, 2), -- Đã sửa từ DiemTB sang DiemKTHP

    PRIMARY KEY (MaSV, MaLop),
    FOREIGN KEY (MaSV) REFERENCES SinhVien(MaSV),
    FOREIGN KEY (MaLop) REFERENCES LopTinChi(MaLop)
);
go
-- ********************************************
-- 3. CHÈN DỮ LIỆU MẪU (SAMPLE DATA)
-- ********************************************

-- 3.1. Khoa
INSERT INTO Khoa (MaKhoa, TenKhoa) VALUES
('CNTT', N'Công nghệ Thông tin'),
('KT', N'Kinh tế'),
('XD', N'Xây dựng');

-- 3.2. Giảng Viên (Đã thêm GioiTinh, Email)
INSERT INTO GiangVien (MaGV, TenGV, SDT, DiaChi, NgaySinh, TinhTrang, HocHam, HocVi, MaKhoa, GioiTinh, Email) VALUES
('GV001', N'Nguyễn Văn A', '0912345678', N'Hà Nội', '1980-05-15', N'Đang làm việc', N'PGS', N'Tiến sĩ', 'CNTT', N'Nam', 'nguyenvana@example.com'),
('GV002', N'Trần Thị B', '0987654321', N'TP.HCM', '1985-11-20', N'Đang làm việc', N'TS', N'Thạc sĩ', 'CNTT', N'Nữ', 'tranthib@example.com'),
('GV003', N'Lê Văn C', '0901122334', N'Đà Nẵng', '1975-01-10', N'Đang làm việc', NULL, N'Thạc sĩ', 'KT', N'Nam', 'levanc@example.com');

-- 3.3. Sinh Viên (Đã thêm SDT, Email)
INSERT INTO SinhVien (MaSV, TenSV, NgaySinh, SDT, Email, GioiTinh, QueQuan, NgayNhapHoc, MaKhoa) VALUES
('SV001', N'Phạm Minh D', '2002-03-25', '0978123456', 'minhd@example.com', N'Nam', N'Hải Phòng', '2020-09-05', 'CNTT'),
('SV002', N'Hoàng Thị E', '2003-07-10', '0965789012', 'thie@example.com', N'Nữ', N'Hà Nội', '2021-09-05', 'CNTT'),
('SV003', N'Mai Văn F', '2002-01-01', '0919234567', 'vanf@example.com', N'Nam', N'Thanh Hóa', '2020-09-05', 'KT');

-- 3.4. Môn Học (Đã sửa HeSoDiem thành HeSoDQT và thêm HeSoThi)
INSERT INTO MonHoc (MaMH, TenMH, SoTC, SoTietLT, SoTietTH, HeSoDQT, HeSoThi, MaKhoa) VALUES
('MH001', N'Cơ sở Dữ liệu', 3, 30, 15, 0.40, 0.60, 'CNTT'),
('MH002', N'Lập trình Web', 3, 30, 15, 0.50, 0.50, 'CNTT'),
('MH003', N'Kinh tế Vĩ mô', 2, 30, 0, 0.30, 0.70, 'KT');

-- 3.9. Học kỳ (Đã sửa MaHK thành HocKy, NamHoc từ 'YYYY-YYYY' thành YYYY, thêm TenHocKy)
INSERT INTO HocKy (HocKy, NamHoc, TenHocKy, NgayBatDau, NgayKetThuc)
VALUES
  (1, 2025, N'Học kỳ 1 (2025-2026)', '2025-09-01', '2025-12-31'),
  (2, 2025, N'Học kỳ 2 (2025-2026)', '2026-01-01', '2026-04-30'),
  (3, 2025, N'Học kỳ 3 (2025-2026)', '2026-05-01', '2026-08-31'),
  (1, 2024, N'Học kỳ 1 (2024-2025)', '2024-09-01', '2024-12-31'); -- Thêm một kỳ của năm trước để dùng cho LTC003

-- 3.5. Khu Vực
INSERT INTO KhuVuc (MaKhuVuc, TenKhuVuc) VALUES
('A', N'Khu A'),
('B', N'Khu B'),
('C', N'Khu C');

-- 3.6. Phòng Học
INSERT INTO PhongHoc (MaPhong, MaKhuVuc) VALUES
('A101', 'A'),
('B101', 'B'),
('C205', 'C');

-- 3.7. Lớp tín chỉ (Đã xóa TenLop, thêm TinhTrangLop, HocKy; sửa NamHoc để khớp với HocKy)
INSERT INTO LopTinChi (MaLop, NamHoc, MaMH, TinhTrangLop, HocKy) VALUES
('LTC001', 2025, 'MH001', 1, 1), -- Lớp này thuộc Học kỳ 1 năm 2025
('LTC002', 2025, 'MH002', 1, 2), -- Lớp này thuộc Học kỳ 2 năm 2025
('LTC003', 2024, 'MH003', 0, 1); -- Lớp này thuộc Học kỳ 1 năm 2024, chưa phân công

-- 3.8. Phân công giảng dạy (Đã sửa cột, thêm CaHoc, Thu và giá trị MaPhong hợp lệ)
INSERT INTO PhanCongGiangDay (MaPC, NgayPC, NgayBatDau, NgayKetThuc, CaHoc, Thu, MaPhong, MaGV, MaLop) VALUES
('PC001', '2025-08-20', '2025-09-01', '2025-12-15', 1, 2, 'A101', 'GV001', 'LTC001'), -- Ca 1, Thứ 2, Phòng A101
('PC002', '2026-01-05', '2026-01-10', '2026-04-20', 3, 4, 'C205', 'GV002', 'LTC002'); -- Ca 3, Thứ 4, Phòng C205
-- LTC003 chưa được phân công (TinhTrangLop = 0) nên không có dữ liệu trong bảng này.

-- 3.9. Điểm (Đã sửa DiemTB thành DiemKTHP, dữ liệu khớp với LTC001, LTC002 đã phân công)
INSERT INTO Diem (MaSV, MaLop, DiemCC, DiemGK, DiemThi, DiemKTHP) VALUES
('SV001', 'LTC001', 9.00, 7.50, 8.00, 8.13),
('SV002', 'LTC001', 8.00, 6.50, 7.00, 7.00);
-- SV003 đang học môn LTC003 nhưng lớp này chưa được phân công hoặc chưa có điểm.

-- 3.10. Tài Khoản (Giữ nguyên)
INSERT INTO TaiKhoan (MaTK, TenDangNhap, MatKhau, LoaiTaiKhoan, MaGV) VALUES
('TKADM', 'admin', 'passadmin', N'Admin', NULL),
('TK001', 'nguyenvana', 'matkhau123', N'Giảng viên', 'GV001'),
('TK002', 'tranthib', 'matkhau456', N'Giảng viên', 'GV002');

INSERT INTO MonHoc (MaMH, TenMH, SoTC, SoTietLT, SoTietTH, HeSoDQT, HeSoThi, MaKhoa) VALUES
('MH004', N'Cấu trúc dữ liệu & GT', 3, 30, 15, 0.4, 0.6, 'CNTT'),
('MH005', N'Mạng máy tính', 3, 30, 15, 0.3, 0.7, 'CNTT'),
('MH006', N'Trí tuệ nhân tạo', 3, 30, 15, 0.4, 0.6, 'CNTT'),
('MH007', N'An toàn thông tin', 2, 30, 0, 0.5, 0.5, 'CNTT');

--thêm data

USE QL_GiangDay
GO

-- =============================================
-- BƯỚC 1: THÊM MÔN HỌC TRƯỚC (BẮT BUỘC CÓ TRƯỚC)
-- =============================================
IF NOT EXISTS (SELECT * FROM MonHoc WHERE MaMH = 'MH004')
    INSERT INTO MonHoc (MaMH, TenMH, SoTC, SoTietLT, SoTietTH, HeSoDQT, HeSoThi, MaKhoa) VALUES ('MH004', N'Cấu trúc dữ liệu & GT', 3, 30, 15, 0.4, 0.6, 'CNTT');

IF NOT EXISTS (SELECT * FROM MonHoc WHERE MaMH = 'MH005')
    INSERT INTO MonHoc (MaMH, TenMH, SoTC, SoTietLT, SoTietTH, HeSoDQT, HeSoThi, MaKhoa) VALUES ('MH005', N'Mạng máy tính', 3, 30, 15, 0.3, 0.7, 'CNTT');

IF NOT EXISTS (SELECT * FROM MonHoc WHERE MaMH = 'MH006')
    INSERT INTO MonHoc (MaMH, TenMH, SoTC, SoTietLT, SoTietTH, HeSoDQT, HeSoThi, MaKhoa) VALUES ('MH006', N'Trí tuệ nhân tạo', 3, 30, 15, 0.4, 0.6, 'CNTT');

IF NOT EXISTS (SELECT * FROM MonHoc WHERE MaMH = 'MH007')
    INSERT INTO MonHoc (MaMH, TenMH, SoTC, SoTietLT, SoTietTH, HeSoDQT, HeSoThi, MaKhoa) VALUES ('MH007', N'An toàn thông tin', 2, 30, 0, 0.5, 0.5, 'CNTT');
GO

-- =============================================
-- BƯỚC 2: THÊM LỚP TÍN CHỈ (KHI ĐÃ CÓ MÔN HỌC)
-- =============================================
IF NOT EXISTS (SELECT * FROM LopTinChi WHERE MaLop = 'LTC004')
    INSERT INTO LopTinChi (MaLop, NamHoc, MaMH, TinhTrangLop, HocKy) VALUES ('LTC004', 2025, 'MH004', 1, 1);

IF NOT EXISTS (SELECT * FROM LopTinChi WHERE MaLop = 'LTC005')
    INSERT INTO LopTinChi (MaLop, NamHoc, MaMH, TinhTrangLop, HocKy) VALUES ('LTC005', 2025, 'MH005', 1, 1);

IF NOT EXISTS (SELECT * FROM LopTinChi WHERE MaLop = 'LTC006')
    INSERT INTO LopTinChi (MaLop, NamHoc, MaMH, TinhTrangLop, HocKy) VALUES ('LTC006', 2025, 'MH006', 1, 1);

IF NOT EXISTS (SELECT * FROM LopTinChi WHERE MaLop = 'LTC007')
    INSERT INTO LopTinChi (MaLop, NamHoc, MaMH, TinhTrangLop, HocKy) VALUES ('LTC007', 2025, 'MH007', 1, 1);
GO

-- =============================================
-- BƯỚC 3: PHÂN CÔNG GIẢNG DẠY (KHI ĐÃ CÓ LỚP VÀ GIẢNG VIÊN)
-- =============================================
-- Xóa dữ liệu phân công cũ nếu lỡ trùng ID để tránh lỗi, sau đó thêm mới
DELETE FROM PhanCongGiangDay WHERE MaPC IN ('PC003', 'PC004', 'PC005', 'PC006', 'PC007');

INSERT INTO PhanCongGiangDay (MaPC, NgayPC, NgayBatDau, NgayKetThuc, CaHoc, Thu, MaPhong, MaGV, MaLop) VALUES
-- Thứ 3, Ca 2
('PC003', '2025-08-20', '2025-09-05', '2025-12-31', 2, 3, 'B101', 'GV001', 'LTC004'),
-- Thứ 4, Ca 3
('PC004', '2025-08-20', '2025-09-05', '2025-12-31', 3, 4, 'C205', 'GV001', 'LTC005'),
-- Thứ 5, Ca 1
('PC005', '2025-08-20', '2025-09-05', '2025-12-31', 1, 5, 'A101', 'GV001', 'LTC006'),
-- Thứ 6, Ca 4
('PC006', '2025-08-20', '2025-09-05', '2025-12-31', 4, 6, 'B101', 'GV001', 'LTC007'),
-- Thứ 7, Ca 5
('PC007', '2025-08-20', '2025-09-05', '2025-12-31', 5, 7, 'C205', 'GV001', 'LTC004');
GO