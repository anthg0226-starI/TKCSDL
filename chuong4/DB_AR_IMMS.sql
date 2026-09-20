CREATE DATABASE DataCenterManagement_DB;
GO

USE DataCenterManagement_DB;
GO

DELETE FROM MaintenanceLog;
DELETE FROM MaintainTicket;
DELETE FROM Alert;
DELETE FROM TelemetryMetric;
DELETE FROM Workload;
DELETE FROM AssetStatusChange;
DELETE FROM Warranty;
DELETE FROM Asset;
DELETE FROM AuditLog;
DELETE FROM Server;
DELETE FROM Rack;
DELETE FROM Room;
DELETE FROM Site;
DELETE FROM AssetCategory;
DELETE FROM AlertThreshold;
DELETE FROM Incident;
GO

-- 1. Sites
INSERT INTO Site (SiteID, SiteName, Location, Description) VALUES
('S001', 'DC Ho Chi Minh Q1', '123 Nguyen Hue, Q1, TP.HCM', 'Trung tâm dữ liệu chính miền Nam'),
('S002', 'DC Ha Noi Cau Giay', '45 Duy Tan, Cau Giay, Ha Noi', 'Trung tâm dữ liệu chính miền Bắc'),
('S003', 'DC Da Nang Hai Chau', '78 Bach Dang, Hai Chau, Da Nang', 'Trung tâm dữ liệu khu vực miền Trung'),
('S004', 'DC Can Tho Ninh Kieu', '12 Hoa Bien, Ninh Kieu, Can Tho', 'Trung tâm dữ liệu miền Tây'),
('S005', 'DC Hai Phong Hong Bang', '99 Dien Bien Phu, Hai Phong', 'Trung tâm dữ liệu thành phố cảng'),
('S006', 'DC Binh Duong Di An', '15 DT743, Di An, Binh Duong', 'Trung tâm dữ liệu vệ tinh công nghiệp'),
('S007', 'DC Dong Nai Bien Hoa', '45 Nguyen Ai Quoc, Bien Hoa', 'Trung tâm dữ liệu công nghiệp Biên Hòa'),
('S008', 'DC Nha Trang Vinh Hai', '23 Pham Van Dong, Nha Trang', 'Trung tâm dữ liệu duyên hải miền Trung'),
('S009', 'DC Hue Phu Hoi', '10 Hung Vuong, TP. Hue', 'Trung tâm dữ liệu cố đô'),
('S010', 'DC Quang Ninh Ha Long', '56 Le Thanh Tong, Ha Long', 'Trung tâm dữ liệu vùng mỏ'),
('S011', 'DC Vung Tau Thang Tam', '89 Hoang Hoa Tham, Vũng Tàu', 'Trung tâm dữ liệu dầu khí'),
('S012', 'DC Buon Ma Thuot', '12 Le Duan, Buon Ma Thuot', 'Trung tâm dữ liệu Tây Nguyên'),
('S013', 'DC Quy Nhon Tran Hung Dao', '34 An Duong Vuong, Quy Nhon', 'Trung tâm dữ liệu Bình Định'),
('S014', 'DC Vinh Hung Hoa', '78 Le Nin, TP. Vinh, Nghe An', 'Trung tâm dữ liệu Bắc Trung Bộ'),
('S015', 'DC Bac Ninh Tu Son', '120 Tran Phu, Tu Son', 'Trung tâm dữ liệu công nghiệp phía Bắc');

-- 2. Rooms
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

-- 3. Racks
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

-- 4. Asset Categories
INSERT INTO AssetCategory (CategoryID, CategoryName, CategoryCode, Description) VALUES
('CAT001', 'Rack Server', 'SRV-RACK', 'May chu rack hieu nang cao'),
('CAT002', 'Network Switch', 'NET-SW', 'Thiet bi chuyen mach mang'),
('CAT003', 'UPS Power', 'PWR-UPS', 'Bo luu dien du phong'),
('CAT004', 'Firewall Appliance', 'SEC-FW', 'Thiet bi tuong lua bao mat'),
('CAT005', 'Storage SAN', 'STO-SAN', 'He thong luu tru mang SAN'),
('CAT006', 'Router Core', 'NET-RTR', 'Thiet bi dinh tuyen core'),
('CAT007', 'Patch Panel', 'NET-PP', 'Thang quan ly cap mang'),
('CAT008', 'PDU Power Strip', 'PWR-PDU', 'Thanh phan phoi nguon dien'),
('CAT009', 'Load Balancer', 'NET-LB', 'Thiet bi can bang tai'),
('CAT010', 'KVM Console', 'ACC-KVM', 'Thiet bi dieu khiển man hinh tap trung');

-- 5. Alert Thresholds
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

-- 6. Incidents
INSERT INTO Incident (IncidentID, CreatedID, Title, Description, Severity, Status, CreatedAt, ResolvedAt) VALUES
('INC001', 'USR001', 'CPU High Load on Web Server', 'Server dat nguong CPU cao', 'High', 'Resolved', '2026-09-10 14:00:00', '2026-09-10 15:30:00'),
('INC002', 'USR004', 'Network Latency Spike', 'Phat hien do tre mang tang cao', 'Medium', 'In Progress', '2026-09-12 08:00:00', NULL),
('INC003', 'USR002', 'RAM Overload on DB Server', 'Dung luong RAM vuot nguong', 'Critical', 'Open', '2026-09-13 11:10:00', NULL),
('INC004', 'USR003', 'Lost Connection to App Server', 'Mat ket noi tam thoi', 'Low', 'Resolved', '2026-09-08 22:00:00', '2026-09-08 22:45:00');
GO

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
    '192.168.' + CAST((n.RowNum % 254) + 1 AS VARCHAR(3)) + '.' + CAST((n.RowNum % 250) + 1 AS VARCHAR(3)),
    'QR-CODE-' + CAST(n.RowNum AS VARCHAR(10)),
    (n.RowNum % 42) + 1,
    CASE WHEN n.RowNum % 15 = 0 THEN 'Maintenance' ELSE 'Active' END,
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
    'Hardware Asset ' + CAST(n.RowNum AS VARCHAR(10)),
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
    'Thong so vuot nguong he thong lan thu ' + CAST(n.RowNum AS VARCHAR(10)),
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
    'Thuc hien thao tac he thong tu dong buoc ' + CAST(n.RowNum AS VARCHAR(10))
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
    'Cap nhat trang thai dinh ky lan ' + CAST(n.RowNum AS VARCHAR(10)),
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
    'Goi bao hanh VIP ' + CAST(n.RowNum AS VARCHAR(10)),
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
AssetList AS (
    SELECT ROW_NUMBER() OVER (ORDER BY AssetID) as aIndex, AssetID FROM Asset
)
INSERT INTO MaintenanceLog (LogID, TicketID, TechnicianID, AssetID, ARSessionUsed, InvestigationNotes, RootCause)
SELECT 
    'MLOG_' + CAST(n.RowNum AS VARCHAR(10)),
    'TCK_' + CAST((n.RowNum % 100) + 1 AS VARCHAR(10)),
    'TECH_' + CAST((n.RowNum % 10) + 1 AS VARCHAR(10)),
    a.AssetID,
    CASE WHEN n.RowNum % 2 = 0 THEN 1 ELSE 0 END,
    'Kiem tra chi tiet thiet bi va thay the linh kien dinh ky so ' + CAST(n.RowNum AS VARCHAR(10)),
    'Loi do qua nhiet va hao mon phan cung thong thuong'
FROM NumberCTE n
JOIN AssetList a ON (n.RowNum % (SELECT COUNT(*) FROM Asset)) + 1 = a.aIndex;
GO
