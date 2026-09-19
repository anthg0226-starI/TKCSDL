-- Tạo Database
CREATE DATABASE DataCenterManagement_DB;
GO

-- Chuyển sang sử dụng Database vừa tạo
USE DataCenterManagement_DB;
GO

-- TẠO CẤU TRÚC BẢNG

CREATE TABLE Site (
    SiteID VARCHAR(36) PRIMARY KEY,
    SiteName VARCHAR(50) NOT NULL,
    Location VARCHAR(255),
    Description TEXT
);

CREATE TABLE Room (
    RoomID VARCHAR(36) PRIMARY KEY,
    SiteID VARCHAR(36) FOREIGN KEY REFERENCES Site(SiteID),
    RoomName VARCHAR(30) NOT NULL,
    FloorLevel VARCHAR(10)
);

CREATE TABLE Rack (
    RackID VARCHAR(36) PRIMARY KEY,
    RoomID VARCHAR(36) FOREIGN KEY REFERENCES Room(RoomID),
    RackName VARCHAR(30) NOT NULL,
    MaxUnit INT,
    LocationInRoom VARCHAR(50)
);

CREATE TABLE Server (
    ServerID VARCHAR(36) PRIMARY KEY,
    RackID VARCHAR(36) FOREIGN KEY REFERENCES Rack(RackID),
    ServerName VARCHAR(40) NOT NULL,
    IPAddress VARCHAR(45),
    QRCodeStamp VARCHAR(50),
    UPosition INT,
    Status VARCHAR(20),
    LastSeen DATETIME
);

CREATE TABLE AssetCategory (
    CategoryID VARCHAR(36) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL,
    CategoryCode VARCHAR(20),
    Description TEXT
);

CREATE TABLE Asset (
    AssetID VARCHAR(36) PRIMARY KEY,
    CategoryID VARCHAR(36) FOREIGN KEY REFERENCES AssetCategory(CategoryID),
    ServerID VARCHAR(36) FOREIGN KEY REFERENCES Server(ServerID),
    AssetTag VARCHAR(20),
    AssetName VARCHAR(50) NOT NULL,
    SerialNumber VARCHAR(50),
    Manufacturer VARCHAR(40),
    Model VARCHAR(40),
    CPUModel VARCHAR(40),
    RAMTotalGB INT,
    AcquisitionDate DATETIME,
    AcquisitionCost FLOAT,
    Status VARCHAR(20)
);

CREATE TABLE Warranty (
    WarrantyID VARCHAR(36) PRIMARY KEY,
    AssetID VARCHAR(36) FOREIGN KEY REFERENCES Asset(AssetID),
    WarrantyType VARCHAR(20),
    WarrantyName VARCHAR(50),
    ContractNumber VARCHAR(30),
    StartDate DATETIME,
    EndDate DATETIME,
    AlertBeforeDays INT,
    Status VARCHAR(20)
);

CREATE TABLE AssetStatusChange (
    ChangeID VARCHAR(36) PRIMARY KEY,
    AssetID VARCHAR(36) FOREIGN KEY REFERENCES Asset(AssetID),
    PreviousStatus VARCHAR(15),
    NewStatus VARCHAR(15),
    Reason TEXT,
    ChangedAt DATETIME
);

CREATE TABLE [User] (
    UserID VARCHAR(36) PRIMARY KEY,
    Username VARCHAR(30) NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    FullName VARCHAR(50) NOT NULL,
    Email VARCHAR(50) NULL,
    Status VARCHAR(15),
    CreatedAt DATETIME
);

CREATE TABLE [Role] (
    RoleID VARCHAR(36) PRIMARY KEY,
    RoleName VARCHAR(50) NOT NULL,
    Description TEXT
);

CREATE TABLE UserRole (
    UserRoleID VARCHAR(36) PRIMARY KEY,
    UserID VARCHAR(36) FOREIGN KEY REFERENCES [User](UserID),
    RoleID VARCHAR(36) FOREIGN KEY REFERENCES [Role](RoleID)
);

CREATE TABLE Incident (
    IncidentID VARCHAR(36) PRIMARY KEY,
    CreatedID VARCHAR(36) FOREIGN KEY REFERENCES [User](UserID),
    Title VARCHAR(100) NOT NULL,
    Description TEXT,
    Severity VARCHAR(20),
    Status VARCHAR(20),
    CreatedAt DATETIME,
    ResolvedAt DATETIME
);

CREATE TABLE Workload (
    WorkloadID VARCHAR(36) PRIMARY KEY,
    ServerID VARCHAR(36) FOREIGN KEY REFERENCES Server(ServerID),
    WorkloadName VARCHAR(50) NOT NULL,
    ContainerID INT,
    ServiceType VARCHAR(40),
    Status VARCHAR(20)
);

CREATE TABLE TelemetryMetric (
    MetricID VARCHAR(36) PRIMARY KEY,
    ServerID VARCHAR(36) FOREIGN KEY REFERENCES Server(ServerID),
    CPUUsage FLOAT,
    RAMUsage FLOAT,
    NetworkTraffic FLOAT,
    ContainerStates VARCHAR(50)
);

CREATE TABLE AlertThreshold (
    ThresholdID VARCHAR(36) PRIMARY KEY,
    MetricType VARCHAR(50),
    WarningValue FLOAT,
    CriticalValue FLOAT,
    IsActive BIT
);

CREATE TABLE Alert (
    AlertID VARCHAR(36) PRIMARY KEY,
    ServerID VARCHAR(36) FOREIGN KEY REFERENCES Server(ServerID),
    ThresholdID VARCHAR(36) FOREIGN KEY REFERENCES AlertThreshold(ThresholdID),
    AcknowledgedBy VARCHAR(36) FOREIGN KEY REFERENCES [User](UserID),
    Alerttype VARCHAR(30),
    Severity VARCHAR(15),
    State VARCHAR(15),
    Message TEXT,
    TriggeredAt DATETIME,
    ResolvedAt DATETIME
);

CREATE TABLE MaintainTicket (
    TicketID VARCHAR(36) PRIMARY KEY,
    IncidentID VARCHAR(36) FOREIGN KEY REFERENCES Incident(IncidentID),
    ServerID VARCHAR(36) FOREIGN KEY REFERENCES Server(ServerID),
    AssignedTo VARCHAR(36) FOREIGN KEY REFERENCES [User](UserID),
    CreatedBy VARCHAR(36) FOREIGN KEY REFERENCES [User](UserID),
    Priority VARCHAR(20),
    Status VARCHAR(20),
    ScheduledAt DATETIME,
    StartedAt DATETIME,
    CompletedAt DATETIME
);

CREATE TABLE MaintenanceLog (
    LogID VARCHAR(36) PRIMARY KEY,
    TicketID VARCHAR(36) FOREIGN KEY REFERENCES MaintainTicket(TicketID),
    TechnicianID VARCHAR(36) FOREIGN KEY REFERENCES [User](UserID),
    AssetID VARCHAR(36) FOREIGN KEY REFERENCES Asset(AssetID),
    ARSessionUsed VARCHAR(50),
    InvestigationNotes TEXT,
    RootCause TEXT,
    CorrectiveAction TEXT,
    LoggedAt DATETIME
);

CREATE TABLE AuditLog (
    LogID VARCHAR(36) PRIMARY KEY,
    IncidentID VARCHAR(36) FOREIGN KEY REFERENCES Incident(IncidentID),
    UserID VARCHAR(36) FOREIGN KEY REFERENCES [User](UserID),
    Action VARCHAR(30),
    EntityType VARCHAR(30),
    EntityID VARCHAR(36),
    Timestamp DATETIME,
    IPAddress VARCHAR(15),
    Details TEXT
);
GO


-- CHÈN DỮ LIỆU MẪU
INSERT INTO Site (SiteID, SiteName, Location, Description) VALUES
('S001', 'DC Ho Chi Minh Q1', '123 Nguyen Hue, Q1, TP.HCM', 'Trung tâm dữ liệu chính miền Nam'),
('S002', 'DC Ha Noi Cau Giay', '45 Duy Tan, Cau Giay, Ha Noi', 'Trung tâm dữ liệu chính miền Bắc'),
('S003', 'DC Da Nang Hai Chau', '78 Bach Dang, Hai Chau, Da Nang', 'Trung tâm dữ liệu khu vực miền Trung');

INSERT INTO Room (RoomID, SiteID, RoomName, FloorLevel) VALUES
('R001', 'S001', 'Server Room A1', 'Floor 2'),
('R002', 'S001', 'Server Room A2', 'Floor 3'),
('R003', 'S002', 'Server Room B1', 'Floor 1'),
('R004', 'S003', 'Server Room C1', 'Floor 2');

INSERT INTO Rack (RackID, RoomID, RackName, MaxUnit, LocationInRoom) VALUES
('RK001', 'R001', 'Rack-Row1-01', 42, 'Corner Left'),
('RK002', 'R001', 'Rack-Row1-02', 42, 'Corner Left'),
('RK003', 'R002', 'Rack-Row2-01', 48, 'Center Room'),
('RK004', 'R003', 'Rack-HN-01', 42, 'North Wall');

INSERT INTO Server (ServerID, RackID, ServerName, IPAddress, QRCodeStamp, UPosition, Status, LastSeen) VALUES
('SRV001', 'RK001', 'SRV-WEB-01', '192.168.1.10', 'QR-SRV-001', 10, 'Active', '2026-09-13 10:00:00'),
('SRV002', 'RK001', 'SRV-DB-01', '192.168.1.11', 'QR-SRV-002', 15, 'Active', '2026-09-13 10:05:00'),
('SRV003', 'RK002', 'SRV-APP-01', '192.168.1.20', 'QR-SRV-003', 12, 'Maintenance', '2026-09-13 09:30:00'),
('SRV004', 'RK004', 'SRV-CACHE-01', '192.168.2.10', 'QR-SRV-004', 8, 'Active', '2026-09-13 10:02:00');

INSERT INTO AssetCategory (CategoryID, CategoryName, CategoryCode, Description) VALUES
('CAT001', 'Rack Server', 'SRV-RACK', 'May chu rack hieu nang cao'),
('CAT002', 'Network Switch', 'NET-SW', 'Thiet bi chuyen mach mang'),
('CAT003', 'UPS Power', 'PWR-UPS', 'Bo luu dien du phong'),
('CAT004', 'Firewall Appliance', 'SEC-FW', 'Thiet bi tuong lua bao mat');

INSERT INTO Asset (AssetID, CategoryID, ServerID, AssetTag, AssetName, SerialNumber, Manufacturer, Model, CPUModel, RAMTotalGB, AcquisitionDate, AcquisitionCost, Status) VALUES
('AST001', 'CAT001', 'SRV001', 'TAG-001', 'Dell PowerEdge R750', 'SN-DELL-9981', 'Dell', 'R750', 'Intel Xeon Gold 6330', 128, '2024-05-15', 3500.50, 'In Use'),
('AST002', 'CAT001', 'SRV002', 'TAG-002', 'HPE ProLiant DL380', 'SN-HPE-5542', 'HPE', 'DL380 Gen10', 'Intel Xeon Platinum 8280', 256, '2024-06-20', 4800.00, 'In Use'),
('AST003', 'CAT002', NULL, 'TAG-003', 'Cisco Catalyst 9300', 'SN-CSC-1123', 'Cisco', 'C9300-48T', NULL, 16, '2023-11-10', 2200.00, 'In Use'),
('AST004', 'CAT003', NULL, 'TAG-004', 'APC Smart-UPS 3000VA', 'SN-APC-7789', 'APC', 'SMT3000I', NULL, 0, '2023-12-01', 1500.00, 'In Storage');

INSERT INTO Warranty (WarrantyID, AssetID, WarrantyType, WarrantyName, ContractNumber, StartDate, EndDate, AlertBeforeDays, Status) VALUES
('WAR001', 'AST001', 'Vendor', 'Dell ProSupport 3 Years', 'CTR-2024-001', '2024-05-15', '2027-05-15', 30, 'Active'),
('WAR002', 'AST002', 'Vendor', 'HPE Care Pack 3Y', 'CTR-2024-015', '2024-06-20', '2027-06-20', 30, 'Active'),
('WAR003', 'AST003', 'Extended', 'Cisco Smart Net 2Y', 'CTR-2023-089', '2023-11-10', '2025-11-10', 15, 'Expired'),
('WAR004', 'AST004', 'Vendor', 'APC Standard Warranty', 'CTR-2023-102', '2023-12-01', '2026-12-01', 30, 'Active');

INSERT INTO AssetStatusChange (ChangeID, AssetID, PreviousStatus, NewStatus, Reason, ChangedAt) VALUES
('ASC001', 'AST001', 'In Storage', 'In Use', 'Trien khai vao phong server A1', '2024-05-18 09:00:00'),
('ASC002', 'AST002', 'In Storage', 'In Use', 'Trien khai vao phong server A1', '2024-06-25 14:30:00'),
('ASC003', 'AST003', 'In Storage', 'In Use', 'Lap dat vao he thong mang core', '2023-11-12 08:15:00'),
('ASC004', 'AST004', 'In Use', 'In Storage', 'Thu hoi bao tri dinh ky', '2025-01-10 11:00:00');

INSERT INTO [User] (UserID, Username, PasswordHash, FullName, Email, Status, CreatedAt) VALUES
('USR001', 'giaan', 'hash_pwd_01', 'Trần Huỳnh Gia An', 'anthg0226@ut.edu.vn', 'Active', '2025-01-01 00:00:00'),
('USR002', 'kyanh', 'hash_pwd_02', 'Hoàng Kỳ Anh', 'anhhk791149@ut.edu.vn', 'Active', '2025-01-01 00:00:00'),
('USR003', 'giabao', 'hash_pwd_03', 'Lê Gia Bảo', 'baolg799255@ut.edu.vn', 'Active', '2025-01-01 00:00:00'),
('USR004', 'tuyetphuong', 'hash_pwd_04', 'Nguyễn Hoàng Tuyết Phương', phuongnht2533@ut.edu.vn', 'Active', '2025-01-01 00:00:00'),
('USR005', 'huyhieu', 'hash_pwd_05', 'Nguyễn Huy Hiệu', 'hieunh1857@ut.edu.vn', 'Active', '2025-01-01 00:00:00');

INSERT INTO [Role] (RoleID, RoleName, Description) VALUES
('ROL001', 'Administrator', 'Quan tri vien he thong toan quyen'),
('ROL002', 'Technician', 'Ky thuat vien van hanh va xu ly su co'),
('ROL003', 'Viewer', 'Nhan vien theo doi giam sat thong tin');

INSERT INTO UserRole (UserRoleID, UserID, RoleID) VALUES
('UR001', 'USR001', 'ROL001'), 
('UR002', 'USR002', 'ROL002'), 
('UR003', 'USR003', 'ROL002'), 
('UR004', 'USR004', 'ROL002'), 
('UR005', 'USR005', 'ROL002'); 

INSERT INTO Incident (IncidentID, CreatedID, Title, Description, Severity, Status, CreatedAt, ResolvedAt) VALUES
('INC001', 'USR001', 'CPU High Load on Web Server', 'Server SRV-WEB-01 dat nguong CPU 95%', 'High', 'Resolved', '2026-09-10 14:00:00', '2026-09-10 15:30:00'),
('INC002', 'USR004', 'Network Latency Spike', 'Phat hien do tre mang tang cao tai switch core', 'Medium', 'In Progress', '2026-09-12 08:00:00', NULL),
('INC003', 'USR002', 'RAM Overload on DB Server', 'Dung luong RAM su dung vuot 90%', 'Critical', 'Open', '2026-09-13 11:10:00', NULL),
('INC004', 'USR003', 'Lost Connection to App Server', 'Mat ket noi tam thoi voi container ung dung', 'Low', 'Resolved', '2026-09-08 22:00:00', '2026-09-08 22:45:00');

INSERT INTO Workload (WorkloadID, ServerID, WorkloadName, ContainerID, ServiceType, Status) VALUES
('WL001', 'SRV001', 'nginx-ingress', 101, 'Web Proxy', 'Running'),
('WL002', 'SRV002', 'postgresql-db', 102, 'Database', 'Running'),
('WL003', 'SRV003', 'api-backend-service', 103, 'Microservice', 'Stopped'),
('WL004', 'SRV004', 'redis-cache', 104, 'Cache', 'Running');

INSERT INTO TelemetryMetric (MetricID, ServerID, CPUUsage, RAMUsage, NetworkTraffic, ContainerStates) VALUES
('MET001', 'SRV001', 45.2, 68.5, 120.5, 'Healthy'),
('MET002', 'SRV002', 88.9, 91.2, 450.0, 'Warning'),
('MET003', 'SRV003', 12.0, 30.1, 15.2, 'Stopped'),
('MET004', 'SRV004', 22.4, 55.0, 85.3, 'Healthy');

INSERT INTO AlertThreshold (ThresholdID, MetricType, WarningValue, CriticalValue, IsActive) VALUES
('THR001', 'CPU', 80.0, 95.0, 1),
('THR002', 'RAM', 85.0, 92.0, 1),
('THR003', 'Network', 500.0, 800.0, 1);

INSERT INTO Alert (AlertID, ServerID, ThresholdID, AcknowledgedBy, Alerttype, Severity, State, Message, TriggeredAt, ResolvedAt) VALUES
('ALT001', 'SRV002', 'THR002', 'USR002', 'RAM High', 'Critical', 'Closed', 'RAM vuot nguong 92%', '2026-09-11 12:00:00', '2026-09-11 12:30:00'),
('ALT002', 'SRV001', 'THR001', 'USR001', 'CPU Spike', 'Warning', 'Active', 'CPU dat 85%', '2026-09-13 11:00:00', NULL),
('ALT003', 'SRV002', 'THR001', NULL, 'CPU Critical', 'Critical', 'Active', 'CPU dat 96%', '2026-09-13 11:05:00', NULL),
('ALT004', 'SRV004', 'THR003', 'USR003', 'Network Peak', 'Warning', 'Closed', 'Luu luong mang tang cao', '2026-09-09 15:00:00', '2026-09-09 16:00:00');

INSERT INTO MaintainTicket (TicketID, IncidentID, ServerID, AssignedTo, CreatedBy, Priority, Status, ScheduledAt, StartedAt, CompletedAt) VALUES
('TCK001', 'INC001', 'SRV001', 'USR002', 'USR001', 'High', 'Completed', '2026-09-10 14:30:00', '2026-09-10 14:45:00', '2026-09-10 15:30:00'),
('TCK002', 'INC002', 'SRV003', 'USR003', 'USR004', 'Medium', 'In Progress', '2026-09-12 09:00:00', '2026-09-12 09:15:00', NULL),
('TCK003', 'INC003', 'SRV002', 'USR002', 'USR001', 'Critical', 'Open', '2026-09-13 12:00:00', NULL, NULL),
('TCK004', NULL, 'SRV004', 'USR003', 'USR002', 'Low', 'Completed', '2026-09-05 08:00:00', '2026-09-05 08:30:00', '2026-09-05 09:30:00');

INSERT INTO MaintenanceLog (LogID, TicketID, TechnicianID, AssetID, ARSessionUsed, InvestigationNotes, RootCause, CorrectiveAction, LoggedAt) VALUES
('LOG001', 'TCK001', 'USR002', 'AST001', 'AR-SES-991', 'Kiem tra tien trinh gay qua tai CPU', 'Tien trinh tien ich chay lap lai vo han', 'Restart lai tien trinh va gioi han resource', '2026-09-10 15:35:00'),
('LOG002', 'TCK002', 'USR003', 'AST003', 'AR-SES-992', 'Do dac lai cap quang va port switch', 'Loi long cap ket noi quang', 'Buoc lai cap va kiem tra tin hieu SFP', '2026-09-12 10:00:00'),
('LOG003', 'TCK004', 'USR003', 'AST004', NULL, 'Bao duong dinh ky UPS', 'Bui bam tich tu lau ngay', 'Ve sinh thiet bi va kiem tra ac quy', '2026-09-05 09:40:00'),
('LOG004', 'TCK001', 'USR002', 'AST001', 'AR-SES-993', 'Kiem tra bo nho cache sau xu ly', 'Khong con hien tuong ro ri bo nho', 'Hoan tat theo doi', '2026-09-10 16:00:00');

INSERT INTO AuditLog (LogID, IncidentID, UserID, Action, EntityType, EntityID, Timestamp, IPAddress, Details) VALUES
('LOG_A1', 'INC001', 'USR001', 'UPDATE', 'Incident', 'INC001', '2026-09-10 15:30:00', '192.168.1.100', 'Cap nhat trang thai su co sang Resolved'),
('LOG_A2', 'INC002', 'USR004', 'INSERT', 'Incident', 'INC002', '2026-09-12 08:00:00', '192.168.1.105', 'Tao moi bao cao su co mang'),
('LOG_A3', NULL, 'USR001', 'LOGIN', 'User', 'USR001', '2026-09-13 08:00:00', '192.168.1.100', 'Quan tri vien dang nhap he thong'),
('LOG_A4', 'INC003', 'USR002', 'INSERT', 'Incident', 'INC003', '2026-09-13 11:10:00', '192.168.1.110', 'Phat sinh su co RAM server DB');
GO

-- TRUY VẤN KIỂM TRA
SELECT 
    [User].UserID, 
    [User].FullName, 
    [User].Username, 
    ISNULL([User].Email, 'N/A') AS Email, 
    [Role].RoleName, 
    [Role].Description AS RoleDescription
FROM [User]
JOIN UserRole ON [User].UserID = UserRole.UserID
JOIN [Role] ON UserRole.RoleID = [Role].RoleID;
