Create Database duAn1_v2
GO
Use duAn1_v2
GO
create table ChatLieu
(
    ID        int identity
        primary key,
    Ten       nvarchar(50),
    TrangThai bit,
    Ma        varchar(5)
)
go

CREATE TRIGGER UpdateSanPhamStatus_ChatLieu
    ON ChatLieu
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(TrangThai)
        BEGIN
            -- Cập nhật trạng thái của sản phẩm liên quan
            UPDATE sp
            SET TinhTrang = i.TrangThai
            FROM SanPham sp
                     INNER JOIN inserted i ON sp.IDChatLieu = i.ID
            WHERE i.TrangThai = 0; -- 0 là giá trị mới của trạng thái (false)
        END
END;
go

create table DeGiay
(
    ID        int identity
        primary key,
    Ten       nvarchar(50),
    TrangThai bit,
    Ma        varchar(5)
)
go

CREATE TRIGGER UpdateSanPhamStatus_DeGiay
    ON DeGiay
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(TrangThai)
        BEGIN
            -- Cập nhật trạng thái của sản phẩm liên quan
            UPDATE sp
            SET TinhTrang = i.TrangThai
            FROM SanPham sp
                     INNER JOIN inserted i ON sp.IDDeGiay = i.ID
            WHERE i.TrangThai = 0; -- 0 là giá trị mới của trạng thái (false)
        END
END;
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
    TrangThai bit,
    Ma        varchar(5)
)
go

CREATE TRIGGER UpdateSanPhamStatus_GioiTinh
    ON GioiTinh
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(TrangThai)
        BEGIN
            -- Cập nhật trạng thái của sản phẩm liên quan
            UPDATE sp
            SET TinhTrang = i.TrangThai
            FROM SanPham sp
                     INNER JOIN inserted i ON sp.IDGioiTinh = i.ID
            WHERE i.TrangThai = 0; -- 0 là giá trị mới của trạng thái (false)
        END
END;
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
    TrangThai bit,
    Ma        varchar(5)
)
go

create table Lot
(
    ID        int identity
        primary key,
    Ten       nvarchar(50),
    TrangThai bit,
    Ma        varchar(5)
)
go

CREATE TRIGGER UpdateSanPhamStatus_Lot
    ON Lot
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(TrangThai)
        BEGIN
            -- Cập nhật trạng thái của sản phẩm liên quan
            UPDATE sp
            SET TinhTrang = i.TrangThai
            FROM SanPham sp
                     INNER JOIN inserted i ON sp.IDLot = i.ID
            WHERE i.TrangThai = 0; -- 0 là giá trị mới của trạng thái (false)
        END
END;
go

create table MauSac
(
    ID        int identity
        primary key,
    Ten       nvarchar(50),
    TrangThai bit,
    Ma        varchar(5)
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
    TrangThai bit,
    Ma        varchar(5)
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

CREATE TRIGGER UpdateSanPhamStatus
    ON dbo.SanPham
    AFTER INSERT, UPDATE
    AS
BEGIN
    SET NOCOUNT ON;
    UPDATE sp
    SET TinhTrang = CASE
                        WHEN th.TrangThai = 0 OR cl.TrangThai = 0 OR gt.TrangThai = 0 OR dg.TrangThai = 0 OR
                             lt.TrangThai = 0 THEN 0
                        ELSE sp.TinhTrang
        END
    FROM dbo.SanPham sp
             INNER JOIN inserted i ON sp.ID = i.ID
             LEFT JOIN dbo.ThuongHieu th ON sp.IDThuongHieu = th.ID
             LEFT JOIN dbo.ChatLieu cl ON sp.IDChatLieu = cl.ID
             LEFT JOIN dbo.GioiTinh gt ON sp.IDGioiTinh = gt.ID
             LEFT JOIN dbo.DeGiay dg ON sp.IDDeGiay = dg.ID
             LEFT JOIN dbo.Lot lt ON sp.IDLot = lt.ID;
END;
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

create table GiamGiaChiTiet
(
    IDGiamGiaChiTiet int identity
        primary key,
    IDGiamGia        int
        references GiamGia,
    IDSPCT           int
        references SanPhamChiTiet,
    DonVi            nvarchar(10),
    SoTien           int
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

-- - - - - -- - -- - - -  - - - - - - - -- - - - - -
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

CREATE TRIGGER UpdateSanPhamStatus_ThuongHieu
    ON ThuongHieu
    AFTER UPDATE
    AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(TrangThai)
        BEGIN
            -- Cập nhật trạng thái của sản phẩm liên quan
            UPDATE sp
            SET TinhTrang = i.TrangThai
            FROM SanPham sp
                     INNER JOIN inserted i ON sp.IDThuongHieu = i.ID
            WHERE i.TrangThai = 0; -- 0 là giá trị mới của trạng thái (false)
        END
END;
go
CREATE PROCEDURE dbo.AddAttribute(
    @tableName NVARCHAR(50),
    @column1 VARCHAR(5),
    @column2 NVARCHAR(50),
    @column3 Bit
)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = 'INSERT ' + QUOTENAME(@tableName) + '(Ma, Ten, TrangThai)' +
               '  VALUES (@column1, @column2, @column3)';

    EXEC sp_executesql @sql,
         N'@column1 VARCHAR(5), @column2 NVARCHAR(50), @column3 BIT',
         @column1, @column2, @column3;
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
    @newValue1 VARCHAR(5),
    @newValue2 NVARCHAR(50),
    @newValue3 BIT
)
    AS
BEGIN
    DECLARE @sql NVARCHAR(250)
    SET @sql = 'UPDATE ' + QUOTENAME(@tableName) +
               ' SET Ma = @newValue1, Ten = @newValue2, TrangThai = @newValue3 WHERE ID = @id'
    EXEC sp_executesql @sql,
         N'@id INT, @newValue1 VARCHAR(5), @newValue2 NVARCHAR(50), @newValue3 BIT',
         @id, @newValue1, @newValue2, @newValue3
END
go


INSERT INTO ChatLieu (Ten, TrangThai, Ma) VALUES (N'Da', 1, N'DA');
INSERT INTO ChatLieu (Ten, TrangThai, Ma) VALUES (N'Vải', 1, N'VA');
INSERT INTO ChatLieu (Ten, TrangThai, Ma) VALUES (N'Cao su', 1, N'CS');
INSERT INTO ChatLieu (Ten, TrangThai, Ma) VALUES (N'Nylon', 0, N'NY');
INSERT INTO ChatLieu (Ten, TrangThai, Ma) VALUES (N'Polyester', 1, N'PO');

INSERT INTO DeGiay (Ten, TrangThai, Ma) VALUES (N'Đế cao su', 0, N'DC');
INSERT INTO DeGiay (Ten, TrangThai, Ma) VALUES (N'Đế da', 1, N'DD');
INSERT INTO DeGiay (Ten, TrangThai, Ma) VALUES (N'Đế EVA', 1, N'DE');
INSERT INTO DeGiay (Ten, TrangThai, Ma) VALUES (N'Đế PU', 1, N'DP');
INSERT INTO DeGiay (Ten, TrangThai, Ma) VALUES (N'Đế Vibram', 0, N'DV');
INSERT INTO DeGiay (Ten, TrangThai, Ma) VALUES (N'Đế Giày', 1, N'DG');

INSERT INTO GioiTinh (Ten, TrangThai, Ma) VALUES (N'Nam', 1, N'NA');
INSERT INTO GioiTinh (Ten, TrangThai, Ma) VALUES (N'Nữ', 1, N'NU');
INSERT INTO GioiTinh (Ten, TrangThai, Ma) VALUES (N'Unisex', 0, N'NN');

INSERT INTO KichThuoc (Ten, TrangThai, Ma) VALUES (N'36', 1, N'36');
INSERT INTO KichThuoc (Ten, TrangThai, Ma) VALUES (N'37', 1, N'37');
INSERT INTO KichThuoc (Ten, TrangThai, Ma) VALUES (N'38', 1, N'38');
INSERT INTO KichThuoc (Ten, TrangThai, Ma) VALUES (N'39', 1, N'39');
INSERT INTO KichThuoc (Ten, TrangThai, Ma) VALUES (N'40', 1, N'40');
INSERT INTO KichThuoc (Ten, TrangThai, Ma) VALUES (N'41', 1, N'41');
INSERT INTO KichThuoc (Ten, TrangThai, Ma) VALUES (N'42', 1, N'42');
INSERT INTO KichThuoc (Ten, TrangThai, Ma) VALUES (N'43', 0, N'43');
INSERT INTO KichThuoc (Ten, TrangThai, Ma) VALUES (N'44', 1, N'44');


INSERT INTO Lot (Ten, TrangThai, Ma) VALUES (N'Lót quế', 1, N'LQ');
INSERT INTO Lot (Ten, TrangThai, Ma) VALUES (N'Lót Orthotics', 1, N'LO');
INSERT INTO Lot (Ten, TrangThai, Ma) VALUES (N'Lót Memory Foam', 0, N'LM');
INSERT INTO Lot (Ten, TrangThai, Ma) VALUES (N'Lót Dr. Scholl''s', 1, N'LD');
INSERT INTO Lot (Ten, TrangThai, Ma) VALUES (N'Lót Giày', 1, N'LG');

INSERT INTO MauSac (Ten, TrangThai, Ma) VALUES (N'Đỏ', 1, N'Re');
INSERT INTO MauSac (Ten, TrangThai, Ma) VALUES (N'Đen', 1, N'Bl');
INSERT INTO MauSac (Ten, TrangThai, Ma) VALUES (N'Trắng', 1, N'Wh');
INSERT INTO MauSac (Ten, TrangThai, Ma) VALUES (N'Be', 1, N'Be');
INSERT INTO MauSac (Ten, TrangThai, Ma) VALUES (N'Xanh Lục', 0, N'Gr');
INSERT INTO MauSac (Ten, TrangThai, Ma) VALUES (N'Xanh Lam', 1, N'Bl');
INSERT INTO MauSac (Ten, TrangThai, Ma) VALUES (N'Nâu', 1, N'Br');
INSERT INTO MauSac (Ten, TrangThai, Ma) VALUES (N'Cam', 1, N'OR');

INSERT INTO PhuongThucThanhToan (Ten, TrangThai) VALUES (N'Tiền mặt', 1);

INSERT INTO SanPham (MaSP, TenSP, MoTa, TinhTrang, IDThuongHieu, IDChatLieu, IDGioiTinh, IDDeGiay, IDLot) VALUES (N'NI-CS-NA-DD-LO', N'Giày Nike', null, 1, 2, 3, 1, 2, 2);
INSERT INTO SanPham (MaSP, TenSP, MoTa, TinhTrang, IDThuongHieu, IDChatLieu, IDGioiTinh, IDDeGiay, IDLot) VALUES (N'PU-CS-NU-DC-LQ', N'Giày Puma', null, 0, 3, 3, 2, 1, 1);
INSERT INTO SanPham (MaSP, TenSP, MoTa, TinhTrang, IDThuongHieu, IDChatLieu, IDGioiTinh, IDDeGiay, IDLot) VALUES (N'TD-VA-NA-DD-LD', N'Giày Thượng Đình', null, 0, 8, 2, 1, 2, 4);
INSERT INTO SanPham (MaSP, TenSP, MoTa, TinhTrang, IDThuongHieu, IDChatLieu, IDGioiTinh, IDDeGiay, IDLot) VALUES (N'RE-NY-NU-DE-LQ', N'Giày Reebok', null, 0, 4, 4, 2, 3, 1);
INSERT INTO SanPham (MaSP, TenSP, MoTa, TinhTrang, IDThuongHieu, IDChatLieu, IDGioiTinh, IDDeGiay, IDLot) VALUES (N'NB-PO-NN-DP-LD', N'Giày New Balance', null, 0, 5, 5, 3, 4, 4);
INSERT INTO SanPham (MaSP, TenSP, MoTa, TinhTrang, IDThuongHieu, IDChatLieu, IDGioiTinh, IDDeGiay, IDLot) VALUES (N'VA-CS-NU-DV-LO', N'Giày Vans', null, 0, 6, 3, 2, 5, 2);
INSERT INTO SanPham (MaSP, TenSP, MoTa, TinhTrang, IDThuongHieu, IDChatLieu, IDGioiTinh, IDDeGiay, IDLot) VALUES (N'CO-PO-NU-DE-LM', N'Giày Converse', null, 0, 7, 5, 2, 3, 3);
INSERT INTO SanPham (MaSP, TenSP, MoTa, TinhTrang, IDThuongHieu, IDChatLieu, IDGioiTinh, IDDeGiay, IDLot) VALUES (N'TD-NY-NN-DV-LM', N'Giày Ngừng', null, 0, 8, 4, 3, 5, 3);
INSERT INTO SanPham (MaSP, TenSP, MoTa, TinhTrang, IDThuongHieu, IDChatLieu, IDGioiTinh, IDDeGiay, IDLot) VALUES (N'NI-NY-NU-DE-LO', N'Giày NiKE', null, 0, 2, 4, 2, 3, 2);
INSERT INTO SanPham (MaSP, TenSP, MoTa, TinhTrang, IDThuongHieu, IDChatLieu, IDGioiTinh, IDDeGiay, IDLot) VALUES (N'Thươn-VA-NU-DD-LO', N'Giày TH', null, 1, 1011, 2, 2, 2, 2);

INSERT INTO SanPhamChiTiet (MaSPCT, IDSanPham, IDMauSac, IDKichThuoc, Anh, SoLuong, Gia, MaQR) VALUES (N'CT14-Bl-38', 14, 21, 3, N'Nike-Air-Force-1-Black.png', 62, 300, N'211783601404661');
INSERT INTO SanPhamChiTiet (MaSPCT, IDSanPham, IDMauSac, IDKichThuoc, Anh, SoLuong, Gia, MaQR) VALUES (N'CT14-Re-40', 14, 20, 5, N'Nike-Air-Force-1-Red.png', 81, 300, N'767762236644570');
INSERT INTO SanPhamChiTiet (MaSPCT, IDSanPham, IDMauSac, IDKichThuoc, Anh, SoLuong, Gia, MaQR) VALUES (N'CT18-Bl-39', 18, 21, 4, N'Nike-Air-Force-1-Black.png', 34, 200, N'379406350161139');
INSERT INTO SanPhamChiTiet (MaSPCT, IDSanPham, IDMauSac, IDKichThuoc, Anh, SoLuong, Gia, MaQR) VALUES (N'CT18-Be-37', 18, 23, 2, N'Nike-Air-Force-1-Brown.png', 62, 320, N'994931205574435');

INSERT INTO ThuongHieu (Ten, TrangThai, Ma) VALUES (N'Adidas', 1, N'AD');
INSERT INTO ThuongHieu (Ten, TrangThai, Ma) VALUES (N'Nike', 1, N'NI');
INSERT INTO ThuongHieu (Ten, TrangThai, Ma) VALUES (N'Puma', 1, N'PU');
INSERT INTO ThuongHieu (Ten, TrangThai, Ma) VALUES (N'Reebok', 1, N'RE');
INSERT INTO ThuongHieu (Ten, TrangThai, Ma) VALUES (N'New Balance', 1, N'NB');
INSERT INTO ThuongHieu (Ten, TrangThai, Ma) VALUES (N'Vans', 1, N'VA');
INSERT INTO ThuongHieu (Ten, TrangThai, Ma) VALUES (N'Converse', 1, N'CO');
INSERT INTO ThuongHieu (Ten, TrangThai, Ma) VALUES (N'Thuong Dinh', 0, N'TD');
INSERT INTO ThuongHieu (Ten, TrangThai, Ma) VALUES (N'TH', 1, N'Thươn');


SELECT*FROM Sanpham