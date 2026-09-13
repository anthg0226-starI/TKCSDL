-- Tạo Database
CREATE DATABASE DataCenterManagement_DB;
GO

-- Chuyển sang sử dụng Database vừa tạo
USE DataCenterManagement_DB;
GO

-- TẠO CẤU TRÚC BẢNG

CREATE TABLE Site (
    SiteID VARCHAR(50) PRIMARY KEY,
    SiteName NVARCHAR(100) NOT NULL,
    Location VARCHAR(255),
    Description NVARCHAR(255)
);

CREATE TABLE Room (
    RoomID VARCHAR(50) PRIMARY KEY,
    SiteID VARCHAR(50) FOREIGN KEY REFERENCES Site(SiteID),
    RoomName NVARCHAR(100) NOT NULL,
    FloorLevel VARCHAR(50)
);

CREATE TABLE Rack (
    RackID VARCHAR(50) PRIMARY KEY,
    RoomID VARCHAR(50) FOREIGN KEY REFERENCES Room(RoomID),
    RackName NVARCHAR(100) NOT NULL,
    MaxUnit INT,
    LocationInRoom VARCHAR(100)
);

CREATE TABLE Server (
    ServerID VARCHAR(50) PRIMARY KEY,
    RackID VARCHAR(50) FOREIGN KEY REFERENCES Rack(RackID),
    ServerName NVARCHAR(100) NOT NULL,
    IPAddress VARCHAR(50),
    QRCodeStamp VARCHAR(100),
    UPosition INT,
    Status VARCHAR(50),
    LastSeen DATETIME
);

CREATE TABLE AssetCategory (
    CategoryID VARCHAR(50) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    CategoryCode VARCHAR(50),
    Description NVARCHAR(255)
);

CREATE TABLE Asset (
    AssetID VARCHAR(50) PRIMARY KEY,
    CategoryID VARCHAR(50) FOREIGN KEY REFERENCES AssetCategory(CategoryID),
    ServerID VARCHAR(50) FOREIGN KEY REFERENCES Server(ServerID),
    AssetTag VARCHAR(50),
    AssetName NVARCHAR(100) NOT NULL,
    SerialNumber VARCHAR(100),
    Manufacturer VARCHAR(100),
    Model VARCHAR(100),
    CPUModel VARCHAR(100),
    RAMTotalGB INT,
    AcquisitionDate DATE,
    AcquisitionCost DECIMAL(18,2),
    Status VARCHAR(50)
);

CREATE TABLE Warranty (
    WarrantyID VARCHAR(50) PRIMARY KEY,
    AssetID VARCHAR(50) FOREIGN KEY REFERENCES Asset(AssetID),
    WarrantyType VARCHAR(50),
    WarrantyName NVARCHAR(100),
    ContractNumber VARCHAR(50),
    StartDate DATE,
    EndDate DATE,
    AlertBeforeDays INT,
    Status VARCHAR(50)
);

CREATE TABLE AssetStatusChange (
    ChangeID VARCHAR(50) PRIMARY KEY,
    AssetID VARCHAR(50) FOREIGN KEY REFERENCES Asset(AssetID),
    PreviousStatus VARCHAR(50),
    NewStatus VARCHAR(50),
    Reason NVARCHAR(255),
    ChangedAt DATETIME
);

CREATE TABLE [User] (
    UserID VARCHAR(50) PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) NULL,
    Status VARCHAR(50),
    CreatedAt DATETIME
);

CREATE TABLE [Role] (
    RoleID VARCHAR(50) PRIMARY KEY,
    RoleName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255)
);

CREATE TABLE UserRole (
    UserRoleID VARCHAR(50) PRIMARY KEY,
    UserID VARCHAR(50) FOREIGN KEY REFERENCES [User](UserID),
    RoleID VARCHAR(50) FOREIGN KEY REFERENCES [Role](RoleID)
);

CREATE TABLE Incident (
    IncidentID VARCHAR(50) PRIMARY KEY,
    CreatedID VARCHAR(50) FOREIGN KEY REFERENCES [User](UserID),
    Title NVARCHAR(150) NOT NULL,
    Description NVARCHAR(MAX),
    Severity VARCHAR(50),
    Status VARCHAR(50),
    CreatedAt DATETIME,
    ResolvedAt DATETIME
);

CREATE TABLE Workload (
    WorkloadID VARCHAR(50) PRIMARY KEY,
    ServerID VARCHAR(50) FOREIGN KEY REFERENCES Server(ServerID),
    WorkloadName NVARCHAR(100) NOT NULL,
    ContainerID INT,
    ServiceType VARCHAR(50),
    Status VARCHAR(50)
);

CREATE TABLE TelemetryMetric (
    MetricID VARCHAR(50) PRIMARY KEY,
    ServerID VARCHAR(50) FOREIGN KEY REFERENCES Server(ServerID),
    CPUUsage FLOAT,
    RAMUsage FLOAT,
    NetworkTraffic FLOAT,
    ContainerStates VARCHAR(50)
);

CREATE TABLE AlertThreshold (
    ThresholdID VARCHAR(50) PRIMARY KEY,
    MetricType VARCHAR(50),
    WarningValue FLOAT,
    CriticalValue FLOAT,
    IsActive INT
);

CREATE TABLE Alert (
    AlertID VARCHAR(50) PRIMARY KEY,
    ServerID VARCHAR(50) FOREIGN KEY REFERENCES Server(ServerID),
    ThresholdID VARCHAR(50) FOREIGN KEY REFERENCES AlertThreshold(ThresholdID),
    AcknowledgedBy VARCHAR(50) FOREIGN KEY REFERENCES [User](UserID),
    Alerttype VARCHAR(50),
    Severity VARCHAR(50),
    State VARCHAR(50),
    Message NVARCHAR(255),
    TriggeredAt DATETIME,
    ResolvedAt DATETIME
);

CREATE TABLE MaintainTicket (
    TicketID VARCHAR(50) PRIMARY KEY,
    IncidentID VARCHAR(50) FOREIGN KEY REFERENCES Incident(IncidentID),
    ServerID VARCHAR(50) FOREIGN KEY REFERENCES Server(ServerID),
    AssignedTo VARCHAR(50) FOREIGN KEY REFERENCES [User](UserID),
    CreatedBy VARCHAR(50) FOREIGN KEY REFERENCES [User](UserID),
    Priority VARCHAR(50),
    Status VARCHAR(50),
    ScheduledAt DATETIME,
    StartedAt DATETIME,
    CompletedAt DATETIME
);

CREATE TABLE MaintenanceLog (
    LogID VARCHAR(50) PRIMARY KEY,
    TicketID VARCHAR(50) FOREIGN KEY REFERENCES MaintainTicket(TicketID),
    TechnicianID VARCHAR(50) FOREIGN KEY REFERENCES [User](UserID),
    AssetID VARCHAR(50) FOREIGN KEY REFERENCES Asset(AssetID),
    ARSessionUsed VARCHAR(50),
    InvestigationNotes NVARCHAR(MAX),
    RootCause NVARCHAR(MAX),
    CorrectiveAction NVARCHAR(MAX),
    LoggedAt DATETIME
);

CREATE TABLE AuditLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    IncidentID VARCHAR(50) FOREIGN KEY REFERENCES Incident(IncidentID),
    UserID VARCHAR(50) FOREIGN KEY REFERENCES [User](UserID),
    Action VARCHAR(50),
    EntityType VARCHAR(50),
    EntityID VARCHAR(50),
    Timestamp DATETIME,
    IPAddress VARCHAR(50),
    Details NVARCHAR(255)
);
GO


-- CHÈN DỮ LIỆU MẪU (DML - CÓ HỖ TRỢ TIẾNG VIỆT ĐẦY ĐỦ)

-- 1. Site
INSERT INTO Site (SiteID, SiteName, Location, Description) VALUES
('S001', N'DC Ho Chi Minh Q1', '123 Nguyen Hue, Q1, TP.HCM', N'Trung tâm dữ liệu chính miền Nam'),
('S002', N'DC Ha Noi Cau Giay', '45 Duy Tan, Cau Giay, Ha Noi', N'Trung tâm dữ liệu chính miền Bắc'),
('S003', N'DC Da Nang Hai Chau', '78 Bach Dang, Hai Chau, Da Nang', N'Trung tâm dữ liệu khu vực miền Trung');

-- 2. Room
INSERT INTO Room (RoomID, SiteID, RoomName, FloorLevel) VALUES
('R001', 'S001', 'Server Room A1', 'Floor 2'),
('R002', 'S001', 'Server Room A2', 'Floor 3'),
('R003', 'S002', 'Server Room B1', 'Floor 1'),
('R004', 'S003', 'Server Room C1', 'Floor 2');

-- 3. Rack
INSERT INTO Rack (RackID, RoomID, RackName, MaxUnit, LocationInRoom) VALUES
('RK001', 'R001', 'Rack-Row1-01', 42, 'Corner Left'),
('RK002', 'R001', 'Rack-Row1-02', 42, 'Corner Left'),
('RK003', 'R002', 'Rack-Row2-01', 48, 'Center Room'),
('RK004', 'R003', 'Rack-HN-01', 42, 'North Wall');

-- 4. Server
INSERT INTO Server (ServerID, RackID, ServerName, IPAddress, QRCodeStamp, UPosition, Status, LastSeen) VALUES
('SRV001', 'RK001', 'SRV-WEB-01', '192.168.1.10', 'QR-SRV-001', 10, 'Active', '2026-09-13 10:00:00'),
('SRV002', 'RK001', 'SRV-DB-01', '192.168.1.11', 'QR-SRV-002', 15, 'Active', '2026-09-13 10:05:00'),
('SRV003', 'RK002', 'SRV-APP-01', '192.168.1.20', 'QR-SRV-003', 12, 'Maintenance', '2026-09-13 09:30:00'),
('SRV004', 'RK004', 'SRV-CACHE-01', '192.168.2.10', 'QR-SRV-004', 8, 'Active', '2026-09-13 10:02:00');

-- 5. AssetCategory
INSERT INTO AssetCategory (CategoryID, CategoryName, CategoryCode, Description) VALUES
('CAT001', N'Rack Server', 'SRV-RACK', N'May chu rack hieu nang cao'),
('CAT002', N'Network Switch', 'NET-SW', N'Thiet bi chuyen mach mang'),
('CAT003', N'UPS Power', 'PWR-UPS', N'Bo luu dien du phong'),
('CAT004', N'Firewall Appliance', 'SEC-FW', N'Thiet bi tuong lua bao mat');

-- 6. Asset
INSERT INTO Asset (AssetID, CategoryID, ServerID, AssetTag, AssetName, SerialNumber, Manufacturer, Model, CPUModel, RAMTotalGB, AcquisitionDate, AcquisitionCost, Status) VALUES
('AST001', 'CAT001', 'SRV001', 'TAG-001', 'Dell PowerEdge R750', 'SN-DELL-9981', 'Dell', 'R750', 'Intel Xeon Gold 6330', 128, '2024-05-15', 3500.50, 'In Use'),
('AST002', 'CAT001', 'SRV002', 'TAG-002', 'HPE ProLiant DL380', 'SN-HPE-5542', 'HPE', 'DL380 Gen10', 'Intel Xeon Platinum 8280', 256, '2024-06-20', 4800.00, 'In Use'),
('AST003', 'CAT002', NULL, 'TAG-003', 'Cisco Catalyst 9300', 'SN-CSC-1123', 'Cisco', 'C9300-48T', NULL, 16, '2023-11-10', 2200.00, 'In Use'),
('AST004', 'CAT003', NULL, 'TAG-004', 'APC Smart-UPS 3000VA', 'SN-APC-7789', 'APC', 'SMT3000I', NULL, 0, '2023-12-01', 1500.00, 'In Storage');

-- 7. Warranty
INSERT INTO Warranty (WarrantyID, AssetID, WarrantyType, WarrantyName, ContractNumber, StartDate, EndDate, AlertBeforeDays, Status) VALUES
('WAR001', 'AST001', 'Vendor', N'Dell ProSupport 3 Years', 'CTR-2024-001', '2024-05-15', '2027-05-15', 30, 'Active'),
('WAR002', 'AST002', 'Vendor', N'HPE Care Pack 3Y', 'CTR-2024-015', '2024-06-20', '2027-06-20', 30, 'Active'),
('WAR003', 'AST003', 'Extended', N'Cisco Smart Net 2Y', 'CTR-2023-089', '2023-11-10', '2025-11-10', 15, 'Expired'),
('WAR004', 'AST004', 'Vendor', N'APC Standard Warranty', 'CTR-2023-102', '2023-12-01', '2026-12-01', 30, 'Active');

-- 8. AssetStatusChange
INSERT INTO AssetStatusChange (ChangeID, AssetID, PreviousStatus, NewStatus, Reason, ChangedAt) VALUES
('ASC001', 'AST001', 'In Storage', 'In Use', N'Trien khai vao phong server A1', '2024-05-18 09:00:00'),
('ASC002', 'AST002', 'In Storage', 'In Use', N'Trien khai vao phong server A1', '2024-06-25 14:30:00'),
('ASC003', 'AST003', 'In Storage', 'In Use', N'Lap dat vao he thong mang core', '2023-11-12 08:15:00'),
('ASC004', 'AST004', 'In Use', 'In Storage', N'Thu hoi bao tri dinh ky', '2025-01-10 11:00:00');

-- 9. User (5 thành viên nhóm)
INSERT INTO [User] (UserID, Username, PasswordHash, FullName, Email, Status, CreatedAt) VALUES
('USR001', 'giaan', 'hash_pwd_01', N'Trần Huỳnh Gia An', NULL, 'Active', '2025-01-01 00:00:00'),
('USR002', 'kyanh', 'hash_pwd_02', N'Hoàng Kỳ Anh', NULL, 'Active', '2025-01-01 00:00:00'),
('USR003', 'giabao', 'hash_pwd_03', N'Lê Gia Bảo', NULL, 'Active', '2025-01-01 00:00:00'),
('USR004', 'tuyetphuong', 'hash_pwd_04', N'Nguyễn Hoàng Tuyết Phương', NULL, 'Active', '2025-01-01 00:00:00'),
('USR005', 'huyhieu', 'hash_pwd_05', N'Nguyễn Huy Hiệu', NULL, 'Active', '2025-01-01 00:00:00');

-- 10. Role
INSERT INTO [Role] (RoleID, RoleName, Description) VALUES
('ROL001', 'Administrator', N'Quan tri vien he thong toan quyen'),
('ROL002', 'Technician', N'Ky thuat vien van hanh va xu ly su co'),
('ROL003', 'Viewer', N'Nhan vien theo doi giam sat thong tin');

-- 11. UserRole
INSERT INTO UserRole (UserRoleID, UserID, RoleID) VALUES
('UR001', 'USR001', 'ROL001'), 
('UR002', 'USR002', 'ROL002'), 
('UR003', 'USR003', 'ROL002'), 
('UR004', 'USR004', 'ROL002'), 
('UR005', 'USR005', 'ROL002'); 

-- 12. Incident
INSERT INTO Incident (IncidentID, CreatedID, Title, Description, Severity, Status, CreatedAt, ResolvedAt) VALUES
('INC001', 'USR001', 'CPU High Load on Web Server', N'Server SRV-WEB-01 dat nguong CPU 95%', 'High', 'Resolved', '2026-09-10 14:00:00', '2026-09-10 15:30:00'),
('INC002', 'USR004', 'Network Latency Spike', N'Phat hien do tre mang tang cao tai switch core', 'Medium', 'In Progress', '2026-09-12 08:00:00', NULL),
('INC003', 'USR002', 'RAM Overload on DB Server', N'Dung luong RAM su dung vuot 90%', 'Critical', 'Open', '2026-09-13 11:10:00', NULL),
('INC004', 'USR003', 'Lost Connection to App Server', N'Mat ket noi tam thoi voi container ung dung', 'Low', 'Resolved', '2026-09-08 22:00:00', '2026-09-08 22:45:00');

-- 13. Workload
INSERT INTO Workload (WorkloadID, ServerID, WorkloadName, ContainerID, ServiceType, Status) VALUES
('WL001', 'SRV001', 'nginx-ingress', 101, 'Web Proxy', 'Running'),
('WL002', 'SRV002', 'postgresql-db', 102, 'Database', 'Running'),
('WL003', 'SRV003', 'api-backend-service', 103, 'Microservice', 'Stopped'),
('WL004', 'SRV004', 'redis-cache', 104, 'Cache', 'Running');

-- 14. TelemetryMetric
INSERT INTO TelemetryMetric (MetricID, ServerID, CPUUsage, RAMUsage, NetworkTraffic, ContainerStates) VALUES
('MET001', 'SRV001', 45.2, 68.5, 120.5, 'Healthy'),
('MET002', 'SRV002', 88.9, 91.2, 450.0, 'Warning'),
('MET003', 'SRV003', 12.0, 30.1, 15.2, 'Stopped'),
('MET004', 'SRV004', 22.4, 55.0, 85.3, 'Healthy');

-- 15. AlertThreshold
INSERT INTO AlertThreshold (ThresholdID, MetricType, WarningValue, CriticalValue, IsActive) VALUES
('THR001', 'CPU', 80.0, 95.0, 1),
('THR002', 'RAM', 85.0, 92.0, 1),
('THR003', 'Network', 500.0, 800.0, 1);

-- 16. Alert
INSERT INTO Alert (AlertID, ServerID, ThresholdID, AcknowledgedBy, Alerttype, Severity, State, Message, TriggeredAt, ResolvedAt) VALUES
('ALT001', 'SRV002', 'THR002', 'USR002', 'RAM High', 'Critical', 'Closed', N'RAM vuot nguong 92%', '2026-09-11 12:00:00', '2026-09-11 12:30:00'),
('ALT002', 'SRV001', 'THR001', 'USR001', 'CPU Spike', 'Warning', 'Active', N'CPU dat 85%', '2026-09-13 11:00:00', NULL),
('ALT003', 'SRV002', 'THR001', NULL, 'CPU Critical', 'Critical', 'Active', N'CPU dat 96%', '2026-09-13 11:05:00', NULL),
('ALT004', 'SRV004', 'THR003', 'USR003', 'Network Peak', 'Warning', 'Closed', N'Luu luong mang tang cao', '2026-09-09 15:00:00', '2026-09-09 16:00:00');

-- 17. MaintainTicket
INSERT INTO MaintainTicket (TicketID, IncidentID, ServerID, AssignedTo, CreatedBy, Priority, Status, ScheduledAt, StartedAt, CompletedAt) VALUES
('TCK001', 'INC001', 'SRV001', 'USR002', 'USR001', 'High', 'Completed', '2026-09-10 14:30:00', '2026-09-10 14:45:00', '2026-09-10 15:30:00'),
('TCK002', 'INC002', 'SRV003', 'USR003', 'USR004', 'Medium', 'In Progress', '2026-09-12 09:00:00', '2026-09-12 09:15:00', NULL),
('TCK003', 'INC003', 'SRV002', 'USR002', 'USR001', 'Critical', 'Open', '2026-09-13 12:00:00', NULL, NULL),
('TCK004', NULL, 'SRV004', 'USR003', 'USR002', 'Low', 'Completed', '2026-09-05 08:00:00', '2026-09-05 08:30:00', '2026-09-05 09:30:00');

-- 18. MaintenanceLog
INSERT INTO MaintenanceLog (LogID, TicketID, TechnicianID, AssetID, ARSessionUsed, InvestigationNotes, RootCause, CorrectiveAction, LoggedAt) VALUES
('LOG001', 'TCK001', 'USR002', 'AST001', 'AR-SES-991', N'Kiem tra tien trinh gay qua tai CPU', N'Tien trinh tien ich chay lap lai vo han', N'Restart lai tien trinh va gioi han resource', '2026-09-10 15:35:00'),
('LOG002', 'TCK002', 'USR003', 'AST003', 'AR-SES-992', N'Do dac lai cap quang va port switch', N'Loi long cap ket noi quang', N'Buoc lai cap va kiem tra tin hieu SFP', '2026-09-12 10:00:00'),
('LOG003', 'TCK004', 'USR003', 'AST004', NULL, N'Bao duong dinh ky UPS', N'Bui bam tich tu lau ngay', N'Ve sinh thiet bi va kiem tra ac quy', '2026-09-05 09:40:00'),
('LOG004', 'TCK001', 'USR002', 'AST001', 'AR-SES-993', N'Kiem tra bo nho cache sau xu ly', N'Khong con hien tuong ro ri bo nho', N'Hoan tat theo doi', '2026-09-10 16:00:00');

-- 19. AuditLog
INSERT INTO AuditLog (IncidentID, UserID, Action, EntityType, EntityID, Timestamp, IPAddress, Details) VALUES
('INC001', 'USR001', 'UPDATE', 'Incident', 'INC001', '2026-09-10 15:30:00', '192.168.1.100', N'Cap nhat trang thai su co sang Resolved'),
('INC002', 'USR004', 'INSERT', 'Incident', 'INC002', '2026-09-12 08:00:00', '192.168.1.105', N'Tao moi bao cao su co mang'),
(NULL, 'USR001', 'LOGIN', 'User', 'USR001', '2026-09-13 08:00:00', '192.168.1.100', N'Quan tri vien dang nhap he thong'),
('INC003', 'USR002', 'INSERT', 'Incident', 'INC003', '2026-09-13 11:10:00', '192.168.1.110', N'Phat sinh su co RAM server DB');
GO

-- TRUY VẤN KIỂM TRA THÔNG TIN USER & ROLE (bôi đen chỗ select để có thể query)
SELECT 
    i.IncidentID, 
    i.Title, 
    i.Severity, 
    i.Status, 
    i.CreatedAt, 
    u.FullName AS CreatedBy
FROM Incident i
JOIN [User] u ON i.CreatedID = u.UserID;
WHERE i.Status != 'Resolved';
