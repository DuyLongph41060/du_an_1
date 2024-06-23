create table ChatLieu
(
    ID        int identity
        primary key,
    Ten       nvarchar(50),
    TrangThai bit
)
go

create table DeGiay
(
    ID        int identity
        primary key,
    Ten       nvarchar(50),
    TrangThai bit
)
go


create table GiamGia
(
    IDGiamGia  int identity
        primary key,
    Ten        nvarchar(50),
    ThoiGianBD date,
    ThoiGiaKT  date,
    TrangThai  nvarchar(50)
)
go

create table GioiTinh
(
    ID        int identity
        primary key,
    Ten       nvarchar(50),
    TrangThai bit
)
go

create table KhachHang
(
    IDKhachHang int identity
        primary key,
    Ten         nvarchar(50),
    SDT         nvarchar(50),
    email       nvarchar(50),
    NgaySinh    date,
    TichDiem    int
)
go

create table DiaChi
(
    IDDiaChi    int identity
        primary key,
    IDKhachHang int
        references KhachHang,
    Ten         nvarchar(255)
)
go

create table KichThuoc
(
    ID        int identity
        primary key,
    Ten       nvarchar(50),
    TrangThai bit
)
go

create table Lot
(
    ID        int identity
        primary key,
    Ten       nvarchar(50),
    TrangThai bit
)
go

create table MauSac
(
    ID        int identity
        primary key,
    Ten       nvarchar(50),
    TrangThai bit
)
go

create table PhuongThucThanhToan
(
    IDPhuongThuc int identity
        primary key,
    Ten          nvarchar(50),
    TrangThai    bit
)
go

create table ThongTinCN
(
    IDTTCN   int identity
        primary key,
    MaNV     nvarchar(10)
        unique,
    Ten      nvarchar(50),
    NgaySinh date,
    GioiTinh bit,
    SDT      varchar(15),
    email    nvarchar(50),
    DiaChi   nvarchar(255)
)
go

create table TaiKhoan
(
    IDTaiKhoan int identity
        primary key,
    Ten        nvarchar(50),
    MatKhau    nvarchar(100),
    VaiTro     bit,
    TrangThai  bit,
    IDTTCN     int
        references ThongTinCN
)
go

create table HoaDon
(
    IDHoaDon         int identity
        primary key,
    IDTaiKhoan       int
        references TaiKhoan,
    IDKhachHang      int
        references KhachHang,
    IDPhuongThuc     int
        references PhuongThucThanhToan,
    TrangThai        nvarchar(50),
    NgayMua          datetime,
    KhachTienMat     decimal(10, 2),
    KhachChuyenKhoan decimal(10, 2),
    TongTien         decimal(10, 2),
    TienGiam         decimal(10, 2),
    TienPhaiTra      decimal(10, 2)
)
go

create table DoiTra
(
    IDDoiTra  int identity
        primary key,
    IDHoaDon  int
        references HoaDon,
    NgayDoi   date,
    MoTa      nvarchar(50),
    TrangThai bit
)
go

create table ThuongHieu
(
    ID        int identity
        primary key,
    Ten       nvarchar(50),
    TrangThai bit
)
go

create table SanPham
(
    ID           int identity
        primary key,
    MaSP         varchar(50),
    TenSP        nvarchar(50),
    MoTa         nvarchar(255),
    TinhTrang    bit,
    IDThuongHieu int
        references ThuongHieu,
    IDChatLieu   int
        references ChatLieu,
    IDGioiTinh   int
        references GioiTinh,
    IDDeGiay     int
        references DeGiay,
    IDLot        int
        references Lot
)
go

create table GiamGiaChiTiet
(
    IDGiamGiaChiTiet int identity
        primary key,
    IDGiamGia        int
        references GiamGia,
    IDSPCT        int
        references SanPhamChiTiet,
    DonVi            nvarchar(10),
    SoTien           int
)
go

create table SanPhamChiTiet
(
    IDSPCT      int identity
        primary key,
    MaSPCT      varchar(50),
    IDSanPham   int
        references SanPham,
    IDMauSac    int
        references MauSac,
    IDKichThuoc int
        references KichThuoc,
    Anh         nvarchar(100),
    SoLuong     int,
    Gia         decimal(10),
    MaQR        nvarchar(255)
)
go

create table HoaDonChiTiet
(
    ID        int identity
        primary key,
    IDHoaDon  int
        references HoaDon,
    IDSPCT    int
        references SanPhamChiTiet,
    IDGiamGia int
        references GiamGia,
    IDHDCT    int
        references HoaDonChiTiet,
    SoLuong   int
)
go

CREATE TRIGGER trg_huy_hdct
    ON HoaDonChiTiet
    FOR DELETE AS
BEGIN
    UPDATE s
    SET s.SoLuong = s.SoLuong + (SELECT SoLuong FROM deleted WHERE IDSPCT = s.IDSPCT)
    FROM SanPhamChiTiet s
             JOIN deleted ON s.IDSPCT = deleted.IDSPCT
END
go

CREATE TRIGGER trg_insert_hdct
    ON HoaDonChiTiet
    AFTER INSERT AS
BEGIN
    UPDATE s
    SET s.SoLuong = s.SoLuong - i.SoLuong
    FROM SanPhamChiTiet s
             JOIN inserted i ON i.IDSPCT = s.IDSPCT
END;
go

CREATE TRIGGER trg_update_hdct
    on HoaDonChiTiet
    AFTER UPDATE AS
BEGIN
    UPDATE s
    SET s.SoLuong = s.SoLuong -
                    (SELECT SoLuong FROM inserted WHERE IDSPCT = s.IDSPCT) +
                    (SELECT SoLuong FROM deleted WHERE IDSPCT = s.IDSPCT)
    FROM SanPhamChiTiet s
             JOIN deleted ON s.IDSPCT = deleted.IDSPCT
END
go
CREATE PROCEDURE dbo.AddAttribute(
    @tableName NVARCHAR(50),
    @column1 NVARCHAR(50),
    @column2 Bit
)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = 'INSERT INTO ' + QUOTENAME(@tableName) +
               '  VALUES (@column1, @column2)';

    EXEC sp_executesql @sql,
         N'@column1 NVARCHAR(50), @column2 Bit',
         @column1, @column2;
END
go

CREATE PROCEDURE dbo.GetAllAttribute @tableName NVARCHAR(255)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX)
    SET @sql = 'SELECT * FROM ' + QUOTENAME(@tableName)
    EXEC sp_executesql @sql
END
go

CREATE PROCEDURE dbo.GetIDByTen @TableName NVARCHAR(50),
                                @Ten NVARCHAR(50)
AS
BEGIN
    DECLARE @sql NVARCHAR(250)
    SET @sql = N'SELECT * FROM ' + QUOTENAME(@TableName) + ' WHERE Ten = @Ten'

    EXEC sp_executesql @sql, N'@Ten NVARCHAR(50)', @Ten
END
go

CREATE PROCEDURE dbo.GetOneAttribute(@TableName NVARCHAR(255),
                                     @RecordId INT)
AS
BEGIN
    DECLARE @SqlQuery NVARCHAR(MAX)
    SET @SqlQuery = 'SELECT * FROM ' + QUOTENAME(@TableName) + ' WHERE Id = @RecordId'
    EXEC sp_executesql @SqlQuery, N'@RecordId INT', @RecordId
END
go

CREATE PROCEDURE dbo.UpdateAttribute(
    @tableName NVARCHAR(50),
    @id INT,
    @newValue1 NVARCHAR(50),
    @newValue2 BIT
)
AS
BEGIN
    DECLARE @sql NVARCHAR(250)
    SET @sql = 'UPDATE ' + QUOTENAME(@tableName) + ' SET Ten = @newValue1, TrangThai = @newValue2 WHERE ID = @id'
    EXEC sp_executesql @sql,
         N'@id INT, @newValue1 NVARCHAR(50), @newValue2 BIT',
         @id, @newValue1, @newValue2
END
go
select*from SanPhamChiTiet

---------------------------------------------------------------------
INSERT ChatLieu
VALUES (N'Da',0),
       (N'Vải',1),
       (N'Cao su',1),
       (N'Nylon',0),
       (N'Polyester',1),
       (N'Cotton',0),
       (N'Suede',1),
       (N'Leather',1),
       (N'Mesh',0)
INSERT DeGiay
VALUES (N'Cứng',0),
       (N'gỗ',1),
       (N'Cao su mềm',1),
       (N'Cao su cứng',0)
INSERT GiamGia
VALUES (N'GG001','2023-10-25','2023-11-25',0),
		(N'GG002','2023-5-27','2023-6-25',1),
		(N'GG003','2023-11-25','2023-12-25',0),
		(N'GG004','2023-1-5','2023-3-15',1)
INSERT GioiTinh
VALUES	(N'Nam',1),
       (N'Nữ',0)
INSERT KhachHang
VALUES	(N'long','0984227203','longldbph41060@gmai.com','2004-09-27',100),
        (N'khánh','0984999203','khanhnguyen@gmai.com','2004-10-7',500),
		(N'Đại','0384527293','Daivan@gmai.com','1999-09-25',300),
		(N'Hùng','0984567203','hungoham@gmai.com','2005-2-7',100)
INSERT DiaChi
VALUES (1,'Hà Nội'),(1,'Hà Nam'),(2,'Thanh Hóa'),(3,'KCM City')

INSERT KichThuoc
VALUES ('36',1),
       ('37',1),
       ('38',1),
       ('39',1),
       ('40',0),
       ('41',1),
       ('42',1),
       ('43',0),
       ('44',1),
       ('45',1)
INSERT Lot
VALUES (N'Tăng chiều cao',1),
       (N'Cao su non',1),
	   (N'Cao su cứng',0),
	   (N'Thấm hút mùi',1)
INSERT MauSac
VALUES (N'Đỏ',1),
       (N'Lục',1),
       (N'Xám',0),
       (N'Trắng',0),
       (N'Đen',1),
       (N'Nâu',1),
       (N'Lam',1),
       (N'Tím',1),
       (N'Vàng',0),
       (N'Be',1)
INSERT PhuongThucThanhToan
VALUES (N'Chuyển khoản',1),(N'Tiền mặt',1)

INSERT ThongTinCN
VALUES ('NV01','Nguyen Van A','2000-9-30',N'Nam','0987136173','nguyenvana@gmail.com',N'Thái Bình'),
	   ('NV02','Nguyen Van B','1999-9-30',N'Nam','0987136003','nguyenvanb@gmail.com',N'Ninh Bình'),
	   ('NV03','Nguyen Thi C','2005-8-30',N'Nữ','0987137233','nguyenthic@gmail.com',N'Thanh Hóa'),
	   ('NV04','Nguyen Thi D','2004-10-30',N'Nữ','098713639','nguyenthid@gmail.com',N'Hà Nội'),
	   ('NV05','Nguyen Van E','2003-7-30',N'Nam','0987136233','nguyenvane@gmail.com',N'Hà Nội')
INSERT TaiKhoan
VALUES (N'taikhoan01', '123', 1, 1, 1),
	   (N'taikhoan02', '123', 1, 1, 2),
	   (N'taikhoan03', '123', 1, 1, 3),
	   (N'taikhoan04', '123', 1, 1, 4),
	   (N'taikhoan05', '123', 1, 1, 5)
INSERT HoaDon
VALUES	(1,1,1,1,'2023-5-12',200000,10000,190000),
		(2,2,1,1,'2023-5-12',2000000,null,200000),
		(3,3,1,1,'2023-5-13',300000,50000,250000),
		(4,4,1,1,'2023-5-14',400000,15000,385000),
		(2,5,1,1,'2023-5-14',300000,50000,250000),
		(1,2,2,1,'2023-5-15',200000,10000,190000),
		(5,1,2,1,'2023-5-16',1000000,100000,900000)

INSERT DoiTra
VALUES (1,'2023-5-13',N'Đổi sang size khác',1),
	   (3,'2023-5-20',N'Hàng lỗi',1),
	   (4,'2023-5-20',N'Đổi sang size khác',1)
INSERT ThuongHieu
VALUES ('Adidas',1),
       ('Nike',1),
       ('Puma',1),
       ('Reebok',0),
       ('New Balance',0),
       ('Vans',1),
       ('Converse',1)
INSERT SanPham
VALUES ('AD02', 'Adidas Superstar', N'Giày sneaker cổ điển với thiết kế mũi giày đặc trưng.', 1, 1,1,2,1),
       ('AD03', 'Adidas Stan Smith', N'Giày sneaker đơn giản với thiết kế tối giản.', 1, 1,1,2,1),
       ('AD04', 'Adidas Ultraboost', N'Giày chạy bộ chuyên nghiệp với khả năng hỗ trợ tối đa.', 1, 1,1,2,1),
       ('NK01', 'Nike Air Force 1', N'Giày sneaker kinh điển với thiết kế đế Air nổi tiếng.', 2, 1,1,2,1),
       ('NK02', 'Nike Air Jordan 1', N'Giày bóng rổ biểu tượng với thiết kế cổ cao.', 2, 1,1,2,3),
       ('NK03', 'Nike Air Max 97', N'Giày chạy bộ với thiết kế đế Air Max ôm sát bàn chân.', 2, 4,1,2,1),
       ('PU01', 'Puma Suede', N'Giày sneaker cổ điển với thiết kế mũi giày tròn.',3, 1,1,2,1),
       ('PU02', 'Puma RS-X', N'Giày sneaker năng động với thiết kế đế RS-X nổi bật.',3, 1,1,2,1),

       ('PU03', 'Puma Future Rider', N'Giày chạy bộ với thiết kế đế Rider êm ái.',3, 3,1,1,1),
       ('RB01', 'Reebok Classic Leather', N'Giày sneaker cổ điển với thiết kế đơn giản.',3, 1,1,2,1),
       ('RB02', 'Reebok Instapump Fury', N'Giày sneaker năng động với thiết kế đế Instapump độc đáo.',3, 1,1,2,1),
       ('RB03', 'Reebok Zig Kinetica', N'Giày chạy bộ với thiết kế đế Zig Kinetica êm ái và năng động.', 3, 1,1,2,1),
       ('NB01', 'New Balance 990v5', N'Giày chạy bộ chuyên nghiệp với khả năng hỗ trợ tối đa.', 5, 1,1,2,1),
       ('NB02', 'New Balance 574', N'Giày sneaker cổ điển với thiết kế đơn giản.',5, 1,1,2,1),
       ('NB03', 'New Balance 2002R', N'Giày chạy bộ với thiết kế retro năng động.',5, 1,1,2,1),
       ('VN01', 'Vans Authentic', N'Giày sneaker cổ điển với thiết kế đơn giản.',6, 1,1,2,1),
       ('VN02', 'Vans Old Skool', N'Giày sneaker cổ điển với thiết kế mũi giày bo tròn.',6, 1,1,2,1),
       ('VN03', 'Vans Era', N'Giày sneaker cổ điển với thiết kế mũi giày bo tròn và đế cao su êm ái.',6, 1,1,2,1),
       ('AS01', 'ASICS Gel-Kayano 29', N'Giày chạy bộ chuyên nghiệp với khả năng hỗ trợ tối đa.',1, 3,1,2,1),
       ('AS02', 'ASICS Gel-Nimbus 24', N'Giày chạy bộ với khả năng êm ái và hỗ trợ tối đa.',1, 2,1,2,1),
       ('AS03', 'ASICS Gel-Kayano Lite', N'Giày chạy bộ nhẹ nhàng và năng động.',1, 4,1,2,1)
INSERT GiamGiaChiTiet
VALUES	(1,2,N'Vnd',10000),
		(2,4,N'Vnd',20000),
		(1,5,N'Vnd',15000),
		(2,6,N'Vnd',15000),
		(1,7,N'Vnd',50000),
		(1,8,N'Vnd',10000),
		(2,10,N'Vnd',15000)

INSERT SanPhamChiTiet
VALUES	('CT01',1,1,1,null,50,500000,null),
		('CT02',2,1,1,null,50,500000,null),
		('CT03',3,1,1,null,50,500000,null),
		('CT04',4,1,1,null,50,500000,null),
		('CT05',5,1,1,null,50,500000,null),
		('CT06',6,1,1,null,50,500000,null),
		('CT07',7,1,1,null,50,500000,null),
		('CT08',8,1,1,null,50,500000,null),
		('CT09',9,1,1,null,50,500000,null),
		('CT010',10,1,1,null,50,500000,null)

