USE master;
GO

CREATE DATABASE DataCenterManagement_DB COLLATE Vietnamese_CI_AS;
GO

USE DataCenterManagement_DB;
GO

CREATE TABLE Site (
    SiteID VARCHAR(20) PRIMARY KEY,
    SiteName NVARCHAR(100) NOT NULL,
    Location NVARCHAR(255),
    Description NVARCHAR(500)
);

CREATE TABLE Room (
    RoomID VARCHAR(20) PRIMARY KEY,
    SiteID VARCHAR(20) NOT NULL,
    RoomName NVARCHAR(100) NOT NULL,
    FloorLevel VARCHAR(20),
    FOREIGN KEY (SiteID) REFERENCES Site(SiteID)
);

CREATE TABLE Rack (
    RackID VARCHAR(20) PRIMARY KEY,
    RoomID VARCHAR(20) NOT NULL,
    RackName NVARCHAR(100) NOT NULL,
    MaxUnit INT,
    LocationInRoom NVARCHAR(100),
    FOREIGN KEY (RoomID) REFERENCES Room(RoomID)
);

CREATE TABLE Server (
    ServerID VARCHAR(20) PRIMARY KEY,
    RackID VARCHAR(20) NOT NULL,
    ServerName NVARCHAR(100) NOT NULL,
    IPAddress VARCHAR(50),
    QRCodeStamp VARCHAR(100),
    UPosition INT,
    Status NVARCHAR(50),
    LastSeen DATETIME,
    FOREIGN KEY (RackID) REFERENCES Rack(RackID)
);

CREATE TABLE AssetCategory (
    CategoryID VARCHAR(20) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    CategoryCode VARCHAR(50),
    Description NVARCHAR(500)
);

CREATE TABLE AlertThreshold (
    ThresholdID VARCHAR(20) PRIMARY KEY,
    MetricType NVARCHAR(50) NOT NULL,
    WarningValue FLOAT,
    CriticalValue FLOAT,
    IsActive INT
);

CREATE TABLE [Role] (
    RoleID VARCHAR(20) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(255)
);

CREATE TABLE [User] (
    UserID VARCHAR(20) PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Status NVARCHAR(20),
    CreatedAt DATETIME
);

CREATE TABLE UserRole (
    UserRoleID VARCHAR(20) PRIMARY KEY,
    UserID VARCHAR(20) NOT NULL,
    RoleID VARCHAR(20) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES [User](UserID),
    FOREIGN KEY (RoleID) REFERENCES [Role](RoleID)
);

CREATE TABLE Incident (
    IncidentID VARCHAR(20) PRIMARY KEY,
    CreatedID VARCHAR(20) NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX),
    Severity NVARCHAR(20),
    Status NVARCHAR(20),
    CreatedAt DATETIME,
    ResolvedAt DATETIME,
    FOREIGN KEY (CreatedID) REFERENCES [User](UserID)
);

CREATE TABLE MaintainTicket (
    TicketID VARCHAR(20) PRIMARY KEY,
    IncidentID VARCHAR(20) NOT NULL,
    ServerID VARCHAR(20) NOT NULL,
    AssignedTo VARCHAR(20) NOT NULL,
    CreatedBy VARCHAR(20) NOT NULL,
    Priority NVARCHAR(20),
    Status NVARCHAR(20),
    ScheduledAt DATETIME,
    StartedAt DATETIME,
    CompletedAt DATETIME,
    FOREIGN KEY (IncidentID) REFERENCES Incident(IncidentID),
    FOREIGN KEY (ServerID) REFERENCES Server(ServerID),
    FOREIGN KEY (AssignedTo) REFERENCES [User](UserID),
    FOREIGN KEY (CreatedBy) REFERENCES [User](UserID)
);

CREATE TABLE Asset (
    AssetID VARCHAR(20) PRIMARY KEY,
    CategoryID VARCHAR(20) NOT NULL,
    ServerID VARCHAR(20) NOT NULL,
    AssetTag VARCHAR(50),
    AssetName NVARCHAR(100) NOT NULL,
    SerialNumber VARCHAR(100),
    Manufacturer NVARCHAR(100),
    Model NVARCHAR(100),
    CPUModel NVARCHAR(100),
    RAMTotalGB INT,
    AcquisitionDate DATE,
    AcquisitionCost FLOAT,
    Status NVARCHAR(50),
    FOREIGN KEY (CategoryID) REFERENCES AssetCategory(CategoryID),
    FOREIGN KEY (ServerID) REFERENCES Server(ServerID)
);

CREATE TABLE TelemetryMetric (
    MetricID VARCHAR(20) PRIMARY KEY,
    ServerID VARCHAR(20) NOT NULL,
    CPUUsage FLOAT,
    RAMUsage FLOAT,
    NetworkTraffic FLOAT,
    ContainerStates NVARCHAR(50),
    FOREIGN KEY (ServerID) REFERENCES Server(ServerID)
);

CREATE TABLE Alert (
    AlertID VARCHAR(20) PRIMARY KEY,
    ServerID VARCHAR(20) NOT NULL,
    ThresholdID VARCHAR(20) NOT NULL,
    AcknowledgedBy VARCHAR(20),
    Alerttype NVARCHAR(50),
    Severity NVARCHAR(20),
    State NVARCHAR(20),
    Message NVARCHAR(MAX),
    TriggeredAt DATETIME,
    ResolvedAt DATETIME,
    FOREIGN KEY (ServerID) REFERENCES Server(ServerID),
    FOREIGN KEY (ThresholdID) REFERENCES AlertThreshold(ThresholdID),
    FOREIGN KEY (AcknowledgedBy) REFERENCES [User](UserID)
);

CREATE TABLE AuditLog (
    LogID VARCHAR(20) PRIMARY KEY,
    IncidentID VARCHAR(20),
    UserID VARCHAR(20) NOT NULL,
    Action NVARCHAR(50),
    EntityType NVARCHAR(50),
    EntityID VARCHAR(20),
    Timestamp DATETIME,
    IPAddress VARCHAR(50),
    Details NVARCHAR(MAX),
    FOREIGN KEY (IncidentID) REFERENCES Incident(IncidentID),
    FOREIGN KEY (UserID) REFERENCES [User](UserID)
);

CREATE TABLE AssetStatusChange (
    ChangeID VARCHAR(20) PRIMARY KEY,
    AssetID VARCHAR(20) NOT NULL,
    PreviousStatus NVARCHAR(50),
    NewStatus NVARCHAR(50),
    Reason NVARCHAR(255),
    ChangedAt DATETIME,
    FOREIGN KEY (AssetID) REFERENCES Asset(AssetID)
);

CREATE TABLE Warranty (
    WarrantyID VARCHAR(20) PRIMARY KEY,
    AssetID VARCHAR(20) NOT NULL,
    WarrantyType NVARCHAR(50),
    WarrantyName NVARCHAR(100),
    ContractNumber VARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (AssetID) REFERENCES Asset(AssetID)
);

CREATE TABLE Workload (
    WorkloadID VARCHAR(20) PRIMARY KEY,
    ServerID VARCHAR(20) NOT NULL,
    WorkloadName NVARCHAR(100),
    ContainerID INT,
    ServiceType NVARCHAR(50),
    Status NVARCHAR(50),
    FOREIGN KEY (ServerID) REFERENCES Server(ServerID)
);

CREATE TABLE MaintenanceLog (
    LogID VARCHAR(20) PRIMARY KEY,
    TicketID VARCHAR(20) NOT NULL,
    TechnicianID VARCHAR(20) NOT NULL,
    AssetID VARCHAR(20) NOT NULL,
    ARSessionUsed VARCHAR(10),
    InvestigationNotes NVARCHAR(MAX),
    RootCause NVARCHAR(MAX),
    CorrectiveAction NVARCHAR(MAX),
    LoggedAt DATETIME,
    FOREIGN KEY (TicketID) REFERENCES MaintainTicket(TicketID),
    FOREIGN KEY (TechnicianID) REFERENCES [User](UserID),
    FOREIGN KEY (AssetID) REFERENCES Asset(AssetID)
);
GO

INSERT INTO Site (SiteID, SiteName, Location, Description) VALUES
('S001', N'DC Ho Chi Minh Q1', '123 Nguyen Hue, Q1, TP.HCM', N'Trung tâm dữ liệu chính miền Nam'),
('S002', N'DC Ha Noi Cau Giay', '45 Duy Tan, Cau Giay, Ha Noi', N'Trung tâm dữ liệu chính miền Bắc'),
('S003', N'DC Da Nang Hai Chau', '78 Bach Dang, Hai Chau, Da Nang', N'Trung tâm dữ liệu khu vực miền Trung'),
('S004', N'DC Can Tho Ninh Kieu', '12 Hoa Bien, Ninh Kieu, Can Tho', N'Trung tâm dữ liệu miền Tây'),
('S005', N'DC Hai Phong Hong Bang', '99 Dien Bien Phu, Hai Phong', N'Trung tâm dữ liệu thành phố cảng'),
('S006', N'DC Binh Duong Di An', '15 DT743, Di An, Binh Duong', N'Trung tâm dữ liệu vệ tinh công nghiệp'),
('S007', N'DC Dong Nai Bien Hoa', '45 Nguyen Ai Quoc, Bien Hoa', N'Trung tâm dữ liệu công nghiệp Biên Hòa'),
('S008', N'DC Nha Trang Vinh Hai', '23 Pham Van Dong, Nha Trang', N'Trung tâm dữ liệu duyên hải miền Trung'),
('S009', 'DC Hue Phu Hoi', '10 Hung Vuong, TP. Hue', N'Trung tâm dữ liệu cố đô'),
('S010', 'DC Quang Ninh Ha Long', '56 Le Thanh Tong, Ha Long', N'Trung tâm dữ liệu vùng mỏ'),
('S011', 'DC Vung Tau Thang Tam', '89 Hoang Hoa Tham, Vũng Tàu', N'Trung tâm dữ liệu dầu khí'),
('S012', 'DC Buon Ma Thuot', '12 Le Duan, Buon Ma Thuot', N'Trung tâm dữ liệu Tây Nguyên'),
('S013', 'DC Quy Nhon Tran Hung Dao', '34 An Duong Vuong, Quy Nhon', N'Trung tâm dữ liệu Bình Định'),
('S014', 'DC Vinh Hung Hoa', '78 Le Nin, TP. Vinh, Nghe An', N'Trung tâm dữ liệu Bắc Trung Bộ'),
('S015', 'DC Bac Ninh Tu Son', '120 Tran Phu, Tu Son', N'Trung tâm dữ liệu công nghiệp phía Bắc');

INSERT INTO Room (RoomID, SiteID, RoomName, FloorLevel) VALUES
('R001', 'S001', 'Server Room A1', 'Floor 2'), ('R002', 'S001', 'Server Room A2', 'Floor 3'),
('R003', 'S002', 'Server Room B1', 'Floor 1'), ('R004', 'S002', 'Server Room B2', 'Floor 2'),
('R005', 'S003', 'Server Room C1', 'Floor 2'), ('R006', 'S004', 'Server Room D1', 'Floor 1'),
('R007', 'S005', 'Server Room E1', 'Floor 2'), ('R008', 'S006', 'Server Room F1', 'Floor 1'),
('R009', 'S007', 'Server Room G1', 'Floor 2'), ('R010', 'S008', 'Server Room H1', 'Floor 1'),
('R011', 'S009', 'Server Room I1', 'Floor 2'), ('R012', 'S010', 'Server Room J1', 'Floor 1'),
('R013', 'S011', 'Server Room K1', 'Floor 2'), ('R014', 'S012', 'Server Room L1', 'Floor 1'),
('R015', 'S013', 'Server Room M1', 'Floor 2'), ('R016', 'S014', 'Server Room N1', 'Floor 1'),
('R017', 'S015', 'Server Room O1', 'Floor 2'), ('R018', 'S001', 'Server Room A3', 'Floor 4'),
('R019', 'S002', 'Server Room B3', 'Floor 3'), ('R020', 'S003', 'Server Room C2', 'Floor 3');

INSERT INTO Rack (RackID, RoomID, RackName, MaxUnit, LocationInRoom) VALUES
('RK001', 'R001', 'Rack-Row1-01', 42, 'Corner Left'), ('RK002', 'R001', 'Rack-Row1-02', 42, 'Corner Left'),
('RK003', 'R002', 'Rack-Row2-01', 48, 'Center Room'), ('RK004', 'R003', 'Rack-HN-01', 42, 'North Wall'),
('RK005', 'R004', 'Rack-HN-02', 42, 'South Wall'), ('RK006', 'R005', 'Rack-DN-01', 42, 'East Wall'),
('RK007', 'R006', 'Rack-CT-01', 42, 'Room Center'), ('RK008', 'R007', 'Rack-HP-01', 42, 'Corner Right'),
('RK009', 'R008', 'Rack-BD-01', 48, 'Row A'), ('RK010', 'R009', 'Rack-DN2-01', 42, 'Row B'),
('RK011', 'R010', 'Rack-NT-01', 42, 'Main Hall'), ('RK012', 'R011', 'Rack-HU-01', 42, 'Wall Side'),
('RK013', 'R012', 'Rack-QN-01', 48, 'Center'), ('RK014', 'R013', 'Rack-VT-01', 42, 'Zone 1'),
('RK015', 'R014', 'Rack-BMT-01', 42, 'Zone 2'), ('RK016', 'R015', 'Rack-QN2-01', 42, 'Zone 3'),
('RK017', 'R016', 'Rack-VINH-01', 42, 'Zone 4'), ('RK018', 'R017', 'Rack-BN-01', 48, 'Zone 5'),
('RK019', 'R018', 'Rack-Row3-01', 42, 'Row C'), ('RK020', 'R020', 'Rack-Row4-01', 42, 'Row D');

INSERT INTO AssetCategory (CategoryID, CategoryName, CategoryCode, Description) VALUES
('CAT001', 'Rack Server', 'SRV-RACK', N'Máy chủ rack hiệu năng cao'),
('CAT002', 'Network Switch', 'NET-SW', N'Thiết bị chuyển mạch mạng'),
('CAT003', 'UPS Power', 'PWR-UPS', N'Bộ lưu điện dự phòng'),
('CAT004', 'Firewall Appliance', 'SEC-FW', N'Thiết bị tường lửa bảo mật'),
('CAT005', 'Storage SAN', 'STO-SAN', N'Hệ thống lưu trữ mạng SAN'),
('CAT006', 'Router Core', 'NET-RTR', N'Thiết bị định tuyến core'),
('CAT007', 'Patch Panel', 'NET-PP', N'Thanh quản lý cáp mạng'),
('CAT008', 'PDU Power Strip', 'PWR-PDU', N'Thanh phân phối nguồn điện'),
('CAT009', 'Load Balancer', 'NET-LB', N'Thiết bị cân bằng tải'),
('CAT010', 'KVM Console', 'ACC-KVM', N'Thiết bị điều khiển màn hình tập trung');

INSERT INTO AlertThreshold (ThresholdID, MetricType, WarningValue, CriticalValue, IsActive) VALUES
('THR001', 'CPU', 80.0, 95.0, 1),
('THR002', 'RAM', 85.0, 92.0, 1),
('THR003', 'Network', 500.0, 800.0, 1),
('THR004', 'DiskIO', 75.0, 90.0, 1),
('THR005', 'Temperature', 65.0, 85.0, 1),
('THR006', 'PowerDraw', 2500.0, 3000.0, 1),
('THR007', 'Latency', 50.0, 150.0, 1),
('THR008', 'PacketLoss', 2.0, 10.0, 1),
('THR009', 'FanSpeed', 3000.0, 1000.0, 1),
('THR010', 'Voltage', 210.0, 190.0, 1);

INSERT INTO [Role] (RoleID, RoleName, Description) VALUES
('ROLE_ADMIN', 'Administrator', N'Quản trị viên hệ thống'),
('ROLE_TECH', 'Technician', N'Kỹ thuật viên bảo trì');

INSERT INTO [User] (UserID, Username, PasswordHash, FullName, Email, Status, CreatedAt) VALUES
('USR001', 'giaan', 'hash_pwd_01', N'Trần Huỳnh Gia An', 'anthg0226@ut.edu.vn', 'Active', '2025-01-01 00:00:00'),
('USR002', 'kyanh', 'hash_pwd_02', N'Hoàng Kỳ Anh', 'anhhk791149@ut.edu.vn', 'Active', '2025-01-01 00:00:00'),
('USR003', 'giabao', 'hash_pwd_03', N'Lê Gia Bảo', 'baolg799255@ut.edu.vn', 'Active', '2025-01-01 00:00:00'),
('USR004', 'tuyetphuong', 'hash_pwd_04', N'Nguyễn Hoàng Tuyết Phương', 'phuongnht2533@ut.edu.vn', 'Active', '2025-01-01 00:00:00'),
('USR005', 'huyhieu', 'hash_pwd_05', N'Nguyễn Huy Hiệu', 'hieunh1857@ut.edu.vn', 'Active', '2025-01-01 00:00:00');

INSERT INTO UserRole (UserRoleID, UserID, RoleID) VALUES
('UR001', 'USR001', 'ROLE_ADMIN'),
('UR002', 'USR002', 'ROLE_TECH'),
('UR003', 'USR003', 'ROLE_TECH'),
('UR004', 'USR004', 'ROLE_TECH'),
('UR005', 'USR005', 'ROLE_TECH');

INSERT INTO Incident (IncidentID, CreatedID, Title, Description, Severity, Status, CreatedAt, ResolvedAt) VALUES
('INC001', 'USR001', 'CPU High Load on Web Server', N'Server đạt ngưỡng CPU cao', 'High', 'Resolved', '2026-09-10 14:00:00', '2026-09-10 15:30:00'),
('INC002', 'USR004', 'Network Latency Spike', N'Phát hiện độ trễ mạng tăng cao', 'Medium', 'In Progress', '2026-09-12 08:00:00', NULL),
('INC003', 'USR002', 'RAM Overload on DB Server', N'Dung lượng RAM vượt ngưỡng', 'Critical', 'Open', '2026-09-13 11:10:00', NULL),
('INC004', 'USR003', 'Lost Connection to App Server', N'Mất kết nối tạm thời', 'Low', 'Resolved', '2026-09-08 22:00:00', '2026-09-08 22:45:00');
GO

-- Chèn dữ liệu tự động 1000 dòng
WITH NumberCTE AS (
    SELECT TOP 1000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
    FROM sys.all_columns ac1 CROSS JOIN sys.all_columns ac2
),
RackList AS (
    SELECT ROW_NUMBER() OVER (ORDER BY RackID) as rIndex, RackID FROM Rack
)
INSERT INTO Server (ServerID, RackID, ServerName, IPAddress, QRCodeStamp, UPosition, Status, LastSeen)
SELECT 
    'SRV_' + CAST(n.RowNum AS VARCHAR(10)),
    r.RackID,
    'Server-Node-' + CAST(n.RowNum AS VARCHAR(10)),
    '192.168.' + CAST((n.RowNum % 250) + 1 AS VARCHAR(3)) + '.' + CAST((n.RowNum % 250) + 1 AS VARCHAR(3)),
    'QR-CODE-' + CAST(n.RowNum AS VARCHAR(10)),
    (n.RowNum % 42) + 1,
    CASE WHEN n.RowNum % 10 = 0 THEN 'Maintenance' ELSE 'Active' END,
    DATEADD(DAY, -(n.RowNum % 30), GETDATE())
FROM NumberCTE n
JOIN RackList r ON (n.RowNum % (SELECT COUNT(*) FROM Rack)) + 1 = r.rIndex;
GO

WITH NumberCTE AS (
    SELECT TOP 1000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
    FROM sys.all_columns ac1 CROSS JOIN sys.all_columns ac2
),
CatList AS (
    SELECT ROW_NUMBER() OVER (ORDER BY CategoryID) as cIndex, CategoryID FROM AssetCategory
),
ServerList AS (
    SELECT ROW_NUMBER() OVER (ORDER BY ServerID) as sIndex, ServerID FROM Server
)
INSERT INTO Asset (AssetID, CategoryID, ServerID, AssetTag, AssetName, SerialNumber, Manufacturer, Model, CPUModel, RAMTotalGB, AcquisitionDate, AcquisitionCost, Status)
SELECT 
    'AST_' + CAST(n.RowNum AS VARCHAR(10)),
    c.CategoryID,
    s.ServerID,
    'TAG-' + CAST(10000 + n.RowNum AS VARCHAR(10)),
    N'Hardware Asset ' + CAST(n.RowNum AS VARCHAR(10)),
    'SN-GEN-' + CAST(100000 + n.RowNum AS VARCHAR(10)),
    CASE (n.RowNum % 3) WHEN 0 THEN 'Dell' WHEN 1 THEN 'HPE' ELSE 'Cisco' END,
    'Model-X' + CAST((n.RowNum % 10) AS VARCHAR(5)),
    'Intel Xeon Scalable',
    CASE WHEN n.RowNum % 2 = 0 THEN 128 ELSE 256 END,
    DATEADD(DAY, -(n.RowNum % 365), '2024-01-01'),
    2000.0 + (n.RowNum % 5000),
    'In Use'
FROM NumberCTE n
JOIN CatList c ON (n.RowNum % (SELECT COUNT(*) FROM AssetCategory)) + 1 = c.cIndex
JOIN ServerList s ON (n.RowNum % (SELECT COUNT(*) FROM Server)) + 1 = s.sIndex;
GO

WITH NumberCTE AS (
    SELECT TOP 1000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
    FROM sys.all_columns ac1 CROSS JOIN sys.all_columns ac2
),
ServerList AS (
    SELECT ROW_NUMBER() OVER (ORDER BY ServerID) as sIndex, ServerID FROM Server
)
INSERT INTO TelemetryMetric (MetricID, ServerID, CPUUsage, RAMUsage, NetworkTraffic, ContainerStates)
SELECT 
    'MET_' + CAST(n.RowNum AS VARCHAR(10)),
    s.ServerID,
    CAST((n.RowNum * 37) % 100 AS FLOAT) + 0.5,
    CAST((n.RowNum * 53) % 100 AS FLOAT) + 0.2,
    CAST((n.RowNum * 79) % 1000 AS FLOAT),
    CASE WHEN n.RowNum % 7 = 0 THEN 'Warning' ELSE 'Healthy' END
FROM NumberCTE n
JOIN ServerList s ON (n.RowNum % (SELECT COUNT(*) FROM Server)) + 1 = s.sIndex;
GO

WITH NumberCTE AS (
    SELECT TOP 1000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
    FROM sys.all_columns ac1 CROSS JOIN sys.all_columns ac2
),
ServerList AS (
    SELECT ROW_NUMBER() OVER (ORDER BY ServerID) as sIndex, ServerID FROM Server
),
ThresholdList AS (
    SELECT ROW_NUMBER() OVER (ORDER BY ThresholdID) as tIndex, ThresholdID FROM AlertThreshold
),
UserList AS (
    SELECT ROW_NUMBER() OVER (ORDER BY UserID) as uIndex, UserID FROM [User]
)
INSERT INTO Alert (AlertID, ServerID, ThresholdID, AcknowledgedBy, Alerttype, Severity, State, Message, TriggeredAt, ResolvedAt)
SELECT 
    'ALT_' + CAST(n.RowNum AS VARCHAR(10)),
    s.ServerID,
    t.ThresholdID,
    u.UserID,
    'Alert Type ' + CAST(t.tIndex AS VARCHAR(5)),
    CASE WHEN n.RowNum % 3 = 0 THEN 'Critical' ELSE 'Warning' END,
    CASE WHEN n.RowNum % 4 = 0 THEN 'Closed' ELSE 'Active' END,
    N'Thông số vượt ngưỡng hệ thống lần thứ ' + CAST(n.RowNum AS VARCHAR(10)),
    DATEADD(HOUR, -n.RowNum, GETDATE()),
    CASE WHEN n.RowNum % 4 = 0 THEN GETDATE() ELSE NULL END
FROM NumberCTE n
JOIN ServerList s ON (n.RowNum % (SELECT COUNT(*) FROM Server)) + 1 = s.sIndex
JOIN ThresholdList t ON (n.RowNum % (SELECT COUNT(*) FROM AlertThreshold)) + 1 = t.tIndex
JOIN UserList u ON (n.RowNum % (SELECT COUNT(*) FROM [User])) + 1 = u.uIndex;
GO

WITH NumberCTE AS (
    SELECT TOP 1000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
    FROM sys.all_columns ac1 CROSS JOIN sys.all_columns ac2
),
IncidentList AS (
    SELECT ROW_NUMBER() OVER (ORDER BY IncidentID) as iIndex, IncidentID FROM Incident
),
UserList AS (
    SELECT ROW_NUMBER() OVER (ORDER BY UserID) as uIndex, UserID FROM [User]
)
INSERT INTO AuditLog (LogID, IncidentID, UserID, Action, EntityType, EntityID, Timestamp, IPAddress, Details)
SELECT 
    'LOG_AUTO_' + CAST(n.RowNum AS VARCHAR(10)),
    i.IncidentID,
    u.UserID,
    CASE (n.RowNum % 3) WHEN 0 THEN 'INSERT' WHEN 1 THEN 'UPDATE' ELSE 'DELETE' END,
    'Server',
    'SRV_' + CAST((n.RowNum % 1000) + 1 AS VARCHAR(10)),
    DATEADD(MINUTE, -n.RowNum, GETDATE()),
    '192.168.1.' + CAST((n.RowNum % 250) + 1 AS VARCHAR(3)),
    N'Thực hiện thao tác hệ thống tự động bước ' + CAST(n.RowNum AS VARCHAR(10))
FROM NumberCTE n
JOIN IncidentList i ON (n.RowNum % (SELECT COUNT(*) FROM Incident)) + 1 = i.iIndex
JOIN UserList u ON (n.RowNum % (SELECT COUNT(*) FROM [User])) + 1 = u.uIndex;
GO

WITH NumberCTE AS (
    SELECT TOP 1000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
    FROM sys.all_columns ac1 CROSS JOIN sys.all_columns ac2
),
AssetList AS (
    SELECT ROW_NUMBER() OVER (ORDER BY AssetID) as aIndex, AssetID FROM Asset
)
INSERT INTO AssetStatusChange (ChangeID, AssetID, PreviousStatus, NewStatus, Reason, ChangedAt)
SELECT 
    'ASC_' + CAST(n.RowNum AS VARCHAR(10)),
    a.AssetID,
    CASE WHEN n.RowNum % 2 = 0 THEN 'In Use' ELSE 'Maintenance' END,
    CASE WHEN n.RowNum % 2 = 0 THEN 'Maintenance' ELSE 'In Use' END,
    N'Cập nhật trạng thái định kỳ lần ' + CAST(n.RowNum AS VARCHAR(10)),
    DATEADD(DAY, -(n.RowNum % 30), GETDATE())
FROM NumberCTE n
JOIN AssetList a ON (n.RowNum % (SELECT COUNT(*) FROM Asset)) + 1 = a.aIndex;
GO

WITH NumberCTE AS (
    SELECT TOP 1000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
    FROM sys.all_columns ac1 CROSS JOIN sys.all_columns ac2
),
AssetList AS (
    SELECT ROW_NUMBER() OVER (ORDER BY AssetID) as aIndex, AssetID FROM Asset
)
INSERT INTO Warranty (WarrantyID, AssetID, WarrantyType, WarrantyName, ContractNumber, StartDate, EndDate)
SELECT 
    'WAR_' + CAST(n.RowNum AS VARCHAR(10)),
    a.AssetID,
    CASE WHEN n.RowNum % 2 = 0 THEN 'Standard' ELSE 'Extended' END,
    N'Gói bảo hành VIP ' + CAST(n.RowNum AS VARCHAR(10)),
    'CTR-' + CAST(50000 + n.RowNum AS VARCHAR(10)),
    DATEADD(DAY, -(n.RowNum % 180), '2025-01-01'),
    DATEADD(DAY, 365 + (n.RowNum % 180), '2026-01-01')
FROM NumberCTE n
JOIN AssetList a ON (n.RowNum % (SELECT COUNT(*) FROM Asset)) + 1 = a.aIndex;
GO

WITH NumberCTE AS (
    SELECT TOP 1000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
    FROM sys.all_columns ac1 CROSS JOIN sys.all_columns ac2
),
ServerList AS (
    SELECT ROW_NUMBER() OVER (ORDER BY ServerID) as sIndex, ServerID FROM Server
)
INSERT INTO Workload (WorkloadID, ServerID, WorkloadName, ContainerID, ServiceType, Status)
SELECT 
    'WL_' + CAST(n.RowNum AS VARCHAR(10)),
    s.ServerID,
    'Microservice-App-' + CAST(n.RowNum AS VARCHAR(10)),
    n.RowNum * 15,
    CASE WHEN n.RowNum % 3 = 0 THEN 'Docker' WHEN n.RowNum % 3 = 1 THEN 'Kubernetes' ELSE 'Native' END,
    CASE WHEN n.RowNum % 5 = 0 THEN 'Stopped' ELSE 'Running' END
FROM NumberCTE n
JOIN ServerList s ON (n.RowNum % (SELECT COUNT(*) FROM Server)) + 1 = s.sIndex;
GO

WITH NumberCTE AS (
    SELECT TOP 1000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
    FROM sys.all_columns ac1 CROSS JOIN sys.all_columns ac2
),
IncidentList AS (
    SELECT ROW_NUMBER() OVER (ORDER BY IncidentID) as iIndex, IncidentID FROM Incident
),
ServerList AS (
    SELECT ROW_NUMBER() OVER (ORDER BY ServerID) as sIndex, ServerID FROM Server
),
UserList AS (
    SELECT ROW_NUMBER() OVER (ORDER BY UserID) as uIndex, UserID FROM [User]
)
INSERT INTO MaintainTicket (TicketID, IncidentID, ServerID, AssignedTo, CreatedBy, Priority, Status, ScheduledAt, StartedAt, CompletedAt)
SELECT 
    'TCK_' + CAST(n.RowNum AS VARCHAR(10)),
    i.IncidentID,
    s.ServerID,
    u1.UserID,
    u2.UserID,
    CASE WHEN n.RowNum % 3 = 0 THEN 'High' WHEN n.RowNum % 3 = 1 THEN 'Medium' ELSE 'Low' END,
    CASE WHEN n.RowNum % 4 = 0 THEN 'Completed' WHEN n.RowNum % 4 = 1 THEN 'In Progress' ELSE 'Pending' END,
    DATEADD(DAY, -(n.RowNum % 30), GETDATE()),
    DATEADD(HOUR, -2, DATEADD(DAY, -(n.RowNum % 30), GETDATE())),
    CASE WHEN n.RowNum % 4 = 0 THEN GETDATE() ELSE NULL END
FROM NumberCTE n
JOIN IncidentList i ON (n.RowNum % (SELECT COUNT(*) FROM Incident)) + 1 = i.iIndex
JOIN ServerList s ON (n.RowNum % (SELECT COUNT(*) FROM Server)) + 1 = s.sIndex
JOIN UserList u1 ON (n.RowNum % (SELECT COUNT(*) FROM [User])) + 1 = u1.uIndex
JOIN UserList u2 ON ((n.RowNum + 1) % (SELECT COUNT(*) FROM [User])) + 1 = u2.uIndex;
GO

WITH NumberCTE AS (
    SELECT TOP 1000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNum
    FROM sys.all_columns ac1 CROSS JOIN sys.all_columns ac2
),
TicketList AS (
    SELECT ROW_NUMBER() OVER (ORDER BY TicketID) as tIndex, TicketID FROM MaintainTicket
),
AssetList AS (
    SELECT ROW_NUMBER() OVER (ORDER BY AssetID) as aIndex, AssetID FROM Asset
),
UserList AS (
    SELECT ROW_NUMBER() OVER (ORDER BY UserID) as uIndex, UserID FROM [User]
)
INSERT INTO MaintenanceLog (LogID, TicketID, TechnicianID, AssetID, ARSessionUsed, InvestigationNotes, RootCause)
SELECT 
    'MLOG_' + CAST(n.RowNum AS VARCHAR(10)),
    t.TicketID,
    u.UserID,
    a.AssetID,
    CASE WHEN n.RowNum % 2 = 0 THEN '1' ELSE '0' END,
    N'Kiểm tra chi tiết thiết bị và xử lý sự cố định kỳ bước ' + CAST(n.RowNum AS VARCHAR(10)),
    N'Lỗi phát sinh do quá tải nhiệt độ và xung đột phần mềm hệ thống'
FROM NumberCTE n
JOIN TicketList t ON (n.RowNum % (SELECT COUNT(*) FROM MaintainTicket)) + 1 = t.tIndex
JOIN AssetList a ON (n.RowNum % (SELECT COUNT(*) FROM Asset)) + 1 = a.aIndex
JOIN UserList u ON (n.RowNum % (SELECT COUNT(*) FROM [User])) + 1 = u.uIndex;
GO

CREATE NONCLUSTERED INDEX IX_Server_IP_Status ON Server(IPAddress, Status);
CREATE NONCLUSTERED INDEX IX_Telemetry_Server_CPU ON TelemetryMetric(ServerID, CPUUsage);
CREATE NONCLUSTERED INDEX IX_Incident_Status_Severity ON Incident(Status, Severity);
CREATE NONCLUSTERED INDEX IX_Alert_TriggeredAt ON Alert(TriggeredAt);
GO

CREATE TRIGGER trg_Asset_Status_Change
ON Asset
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(Status)
    BEGIN
        INSERT INTO AssetStatusChange (ChangeID, AssetID, PreviousStatus, NewStatus, Reason, ChangedAt)
        SELECT 
            'CHG_' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(15)),
            inserted.AssetID,
            deleted.Status,
            inserted.Status,
            N'Tự động ghi nhận thay đổi trạng thái hệ thống',
            GETDATE()
        FROM inserted
        INNER JOIN deleted ON inserted.AssetID = deleted.AssetID
        WHERE ISNULL(inserted.Status, '') <> ISNULL(deleted.Status, '');
    END
END;
GO
