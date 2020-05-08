DROP TABLE IF EXISTS user_;
CREATE TABLE IF NOT EXISTS user_ (
	ID int NOT NULL AUTO_INCREMENT,
    email varchar(255) UNIQUE,
    username varchar(255),
    fname varchar(255),
    lname varchar(255),
    PRIMARY KEY (ID),
    CHECK (email LIKE '%@%.%')
    );
 
DROP TABLE IF EXISTS psu_;
CREATE TABLE IF NOT EXISTS psu_ (
	model varchar(100) NOT NULL,
    brand varchar(100) NOT NULL,
    wattage int NOT NULL,
    efficiency varchar(100) NOT NULL,
    form_factor varchar(255),
    modularity varchar(255),
    price int,
    CONSTRAINT PK_psu_ PRIMARY KEY (model, brand, wattage, efficiency),
    CHECK (efficiency = '80+' OR efficiency = '80+ Bronze' OR efficiency = '80+ Silver' OR efficiency = '80+ Gold' OR efficiency = '80+ Platinum' OR efficiency = '80+ Titanium'),
    CHECK (modularity = 'No' OR modularity = 'Full' OR modularity = 'Semi'),
    CHECK (form_factor = 'ATX' OR form_factor = 'SFX')
	);
    
DROP TABLE IF EXISTS ram_;
CREATE TABLE IF NOT EXISTS ram_ (
	model varchar(100) NOT NULL,
    brand varchar(100) NOT NULL,
    capacity int NOT NULL,
    frequency int NOT NULL,
    type_ varchar(50) NOT NULL,
    timings varchar(255),
    sticks int,
    power_draw int,
    price int,
    CONSTRAINT PK_ram_ PRIMARY KEY (model, brand, frequency, capacity, type_),
    CHECK (timings LIKE '%-%-%-%'),
    CHECK (type_ LIKE 'DDR_ %-pin %DIMM')
	);

DROP TABLE IF EXISTS cpu_;
CREATE TABLE IF NOT EXISTS cpu_ (
	model varchar(100) NOT NULL,
    brand varchar(100) NOT NULL,
    socket_ varchar(255),
    frequency int,
    SMT varchar(255),
    cores int,
    threads int,
    max_memory int,
    power_draw int,
    price int,
    CONSTRAINT PK_cpu_ PRIMARY KEY (model, brand),
    CHECK (SMT = 'Yes' OR SMT = 'No')
	);

DROP TABLE IF EXISTS cooler_;
CREATE TABLE IF NOT EXISTS cooler_ (
	model varchar(100) NOT NULL,
    brand varchar(100) NOT NULL,
    type_ varchar(24),
    rad_size int,
    power_draw int,
    price int,
    CONSTRAINT PK_cooler_ PRIMARY KEY (model, brand),
    CHECK (type_ = 'Air' OR type_ = 'Water')
    );
    
DROP TABLE IF EXISTS case_;
CREATE TABLE IF NOT EXISTS case_ (
	model varchar(100) NOT NULL,
    brand varchar(100) NOT NULL,
    length int,
    width int,
    height int,
    form_factor varchar(255),
    gpu_clearance int,
    rad_clearance int,
    price int,
    CONSTRAINT PK_case_ PRIMARY KEY(model, brand),
    CHECK (form_factor = 'Full' OR form_factor = 'Mid' OR form_factor = 'Mini')
    );
    
DROP TABLE IF EXISTS gpu_;
CREATE TABLE IF NOT EXISTS gpu_ (
	model varchar(100) NOT NULL,
    brand varchar(100) NOT NULL,
    chip varchar(100) NOT NULL,
    frequency int,
    length_ int,
    vram int,
    power_draw int,
    price int,
    CONSTRAINT PK_gpu_ PRIMARY KEY (model, brand, chip)
    );

DROP TABLE IF EXISTS storage_;
CREATE TABLE IF NOT EXISTS storage_ (
	model varchar(100) NOT NULL,
    brand varchar(100) NOT NULL,
    type_ varchar(20),
    form_factor varchar(20),
    capacity int NOT NULL,
    interface varchar(255),
    power_draw int,
    price int,
    CONSTRAINT PK_storage_ PRIMARY KEY (model, brand, capacity),
    CHECK (type_ = 'SSD' OR type_ = 'Magnetic' OR type_ = 'Hybrid'),
    CHECK (form_factor = '3.5' OR form_factor = '2.5' OR form_factor = 'M.2' OR form_factor = 'PCI-E'),
    CHECK (interface = 'SATA' OR interface = 'M.2' OR interface = 'PCI-E')
	);
    
DROP TABLE IF EXISTS motherboard_;
CREATE TABLE IF NOT EXISTS motherboard_ (
	model varchar(100) NOT NULL,
    brand varchar(100) NOT NULL,
    socket_ varchar(255),
    multi_gpu int,
    chipset varchar(255),
    form_factor varchar(255),
    max_ram int,
    ram_slots int,
    ram_type varchar(50),
    power_draw int,
    price int,
    CONSTRAINT PK_motherboard_ PRIMARY KEY (model, brand),
    CHECK (form_factor = 'ATX' OR form_factor = 'Micro-ATX' OR form_factor = 'Mini-ITX' OR form_factor = 'EATX'),
    CHECK (ram_type LIKE 'DDR_ %-pin %DIMM')
	);

DROP TABLE IF EXISTS build_;
CREATE TABLE IF NOT EXISTS build_ (
	bname varchar(100) NOT NULL,
    ID int NOT NULL,
    motherboard_name varchar(100),
    motherboard_brand varchar(100),
    psu_name varchar(100),
    psu_brand varchar(100),
    psu_wattage int,
    psu_efficiency varchar(100),
    ram_name varchar(100),
    ram_brand varchar(100),
    ram_frequency int,
    ram_capacity int,
    ram_type varchar(50), 
    case_name varchar(100),
    case_brand varchar(100),
    cpu_name varchar(100),
    cpu_brand varchar(100),
    cooler_name varchar(100),
    cooler_brand varchar(100),
    CONSTRAINT PK_build_ PRIMARY KEY (bname, ID),
    FOREIGN KEY (ID) REFERENCES user_(ID)
		ON DELETE CASCADE,
	CONSTRAINT FK_build_1 FOREIGN KEY (motherboard_name, motherboard_brand) REFERENCES motherboard_(model, brand)
		ON DELETE SET NULL,
    CONSTRAINT FK_build_2 FOREIGN KEY (psu_name, psu_brand, psu_wattage, psu_efficiency) REFERENCES psu_(model, brand, wattage, efficiency)
		ON DELETE SET NULL,
    CONSTRAINT FK_build_3 FOREIGN KEY (ram_name, ram_brand, ram_frequency, ram_capacity, ram_type) REFERENCES ram_(model, brand, frequency, capacity, type_)
		ON DELETE SET NULL,
	CONSTRAINT FK_build_4 FOREIGN KEY (case_name, case_brand) REFERENCES case_(model, brand)
		ON DELETE SET NULL,
    CONSTRAINT FK_build_5 FOREIGN KEY (cpu_name, cpu_brand) REFERENCES cpu_(model, brand)
		ON DELETE SET NULL,
    CONSTRAINT FK_build_6 FOREIGN KEY (cooler_name, cooler_brand) REFERENCES cooler_(model, brand)
		ON DELETE SET NULL
	);

DROP TABLE IF EXISTS gpu_list_;
CREATE TABLE IF NOT EXISTS gpu_list_ (
	build_name varchar(100) NOT NULL,
    user_ID int NOT NULL,
    gpu_name varchar(100) NOT NULL,
    gpu_brand varchar(100) NOT NULL,
    gpu_chip varchar(100) NOT NULL,
    gpu_quantity int NOT NULL DEFAULT 1,
    CONSTRAINT PK_gpu_list_ PRIMARY KEY (build_name, user_ID, gpu_name, gpu_brand, gpu_quantity),
    CONSTRAINT PK_gpu_list_1 FOREIGN KEY (build_name, user_ID) REFERENCES build_(bname, ID)
		ON DELETE CASCADE,
	CONSTRAINT FK_gpu_list_2 FOREIGN KEY (gpu_name, gpu_brand, gpu_chip) REFERENCES gpu_(model, brand, chip)
		ON DELETE CASCADE
	);

DROP TABLE IF EXISTS storage_list_;
CREATE TABLE IF NOT EXISTS storage_list_ (
	build_name varchar(100) NOT NULL,
    user_ID int NOT NULL,
    storage_name varchar(100) NOT NULL,
    storage_brand varchar(100) NOT NULL,
    storage_capacity int NOT NULL,
    storage_quantity int NOT NULL DEFAULT 1,
    CONSTRAINT PK_storage_list_ PRIMARY KEY (build_name, user_ID, storage_name, storage_brand, storage_capacity, storage_quantity),
    CONSTRAINT FK_storage_list_1 FOREIGN KEY (build_name, user_ID) REFERENCES build_(bname, ID)
		ON DELETE CASCADE,
	CONSTRAINT FK_storage_list_2 FOREIGN KEY (storage_name, storage_brand, storage_capacity) REFERENCES storage_(model, brand, capacity)
		ON DELETE CASCADE
    );
    
DROP TABLE IF EXISTS psu_connections_;
CREATE TABLE IF NOT EXISTS psu_connections_ (
	psu_name varchar(100) NOT NULL,
    psu_brand varchar(100) NOT NULL,
    psu_wattage int NOT NULL,
    psu_efficiency varchar(100) NOT NULL,
    connection_ varchar(100),
    CONSTRAINT PK_psu_connections_ PRIMARY KEY (psu_name, psu_brand, psu_wattage, psu_efficiency, connection_),
    CONSTRAINT FK_psu_connections_ FOREIGN KEY (psu_name, psu_brand, psu_wattage, psu_efficiency) REFERENCES psu_(model, brand, wattage, efficiency)
		ON DELETE CASCADE
	);

DROP TABLE IF EXISTS case_motherboard_support_;
CREATE TABLE IF NOT EXISTS case_motherboard_support_ (
	case_name varchar(100) NOT NULL,
    case_brand varchar(100) NOT NULL,
    motherboard_form_factor varchar(100) NOT NULL,
    CONSTRAINT PK_case_motherboard_support_ PRIMARY KEY (case_name, case_brand, motherboard_form_factor),
    CONSTRAINT FK_case_motherboard_support_1 FOREIGN KEY (case_name, case_brand) REFERENCES case_(model, brand)
		ON DELETE CASCADE,
	CHECK(motherboard_form_factor = 'ATX' OR motherboard_form_factor = 'EATX' OR motherboard_form_factor = 'Micro-ATX' OR motherboard_form_factor = 'Mini-ITX')
	);

DROP TABLE IF EXISTS motherboard_ram_speeds_;    
CREATE TABLE IF NOT EXISTS motherboard_ram_speeds_ (
	motherboard_name varchar(100) NOT NULL,
    motherboard_brand varchar(100) NOT NULL,
    speed int NOT NULL,
    CONSTRAINT PK_motherboard_ram_speeds_ PRIMARY KEY (motherboard_name, motherboard_brand, speed),
    CONSTRAINT FK_motherboard_ram_speeds_1 FOREIGN KEY (motherboard_name, motherboard_brand) REFERENCES motherboard_(model, brand)
		ON DELETE CASCADE
	);

DROP TABLE IF EXISTS motherboard_storage_types_;
CREATE TABLE IF NOT EXISTS motherboard_storage_types_ (
	motherboard_name varchar(100) NOT NULL,
    motherboard_brand varchar(100) NOT NULL,
    type_ varchar(255) NOT NULL,
    quantity int,
    CONSTRAINT PK_motherboard_storage_types_ PRIMARY KEY (motherboard_name, motherboard_brand, type_, quantity),
    CONSTRAINT FK_motherboard_storage_types_ FOREIGN KEY (motherboard_name, motherboard_brand) REFERENCES motherboard_(model, brand)
		ON DELETE CASCADE
	);
    
DROP TABLE IF EXISTS cooler_socket_support_;
CREATE TABLE IF NOT EXISTS cooler_socket_support_ (
    cooler_name varchar(100) NOT NULL,
    cooler_brand varchar(100) NOT NULL,
    socket_ varchar(100) NOT NULL,
    CONSTRAINT PK_cooler_socket_support_ PRIMARY KEY (cooler_name, cooler_brand, socket_),
    CONSTRAINT FK_motherboard_cooler_support_1 FOREIGN KEY (cooler_name, cooler_brand) REFERENCES cooler_(model, brand)
		ON DELETE CASCADE
	);

INSERT INTO user_(email, username, fname, lname) VALUE 
	('nichols@sonoma.edu', 'cnicholson', 'Cole', 'Nicholson-Rubidoux'),
    ('lindsey.parnell@ymail.com', 'lindsey.parnell', 'Lindsey', 'Parnell'),
    ('assassin1578@gmail.com','Bole.Bibbleson','Colin','Kyle'),
    ('felix.sjolund@felixmail.org', 'Mr. Brunkis', 'Felix', 'Sjolund'),
    ('apham@irvine.edu', 'Ethernut', 'Andrew', 'Pham'),
    ('dngo@hotmail.com', 'Pootan', 'Dan', 'Ngo'),
    ('jangarang@aol.com', 'Fr4tb0y99', 'Jang', 'Dokko'),
    ('thekevboe@gmail.com', 'thekevboe', 'Kevin', 'Patterson');
    
INSERT INTO cpu_(brand, model, socket_, frequency, SMT, cores, threads, max_memory, power_draw, price) VALUE
	('Intel', 'Xeon E5-2699', 'LGA2011-3', 7000, 'Yes', 18, 36, 1000000, 2000, 5000),
    ('AMD', 'Ryzen 9 3950X', 'AM4', 4200, 'Yes', 16, 32, 128, 150, 750),
    ('AMD', 'Athlon A6', 'AM4', 3500, 'No', 4, 4, 32, 50, 65),
    ('Intel', 'Core i7 9700k', 'LGA1151', 4500, 'Yes', 8, 16, 128, 105, 500),
    ('AMD', 'Epyc 7023', 'AM7023', 3200, 'Yes', 32, 64, 512, 500, 2000),
    ('AMD', 'Ryzen 5 1600', 'AM4', 3200, 'Yes', 6, 12, 128, 75, 120),
    ('Intel', 'Core i9 9900k', 'LGA1151', 3600,'Yes', 8, 16, 128, 150, 500),
    ('Intel', 'Core i5 9600', 'LGA1151', 3100, 'No', 6, 6, 128, 65, 330),
    ('Intel', 'Core i7 7700k', 'LGA1151', 3600, 'Yes', 4, 8, 64, 65, 320),
    ('AMD', 'Ryzen 7 2700X', 'AM4', 3500, 'Yes', 8, 16, 128, 90, 270),
    ('AMD', 'FX 6350', 'AM3+', 3500, 'No', 6, 6, 64, 65, 130),
    ('Intel', 'Core i7 4770k', 'LGA1150',3500, 'Yes', 4, 8, 64, 84, 350),
    ('AMD', 'Threadripper 3990X', 'sTRX4', 2900, 'Yes', 64, 128, 1024, 280, 3900),
    ('AMD', 'Threadripper 2990WX', 'sTR4', 3000, 'Yes', 32, 64, 512, 250, 2000);
    
INSERT INTO gpu_(brand, model, chip, frequency, vram, length_, power_draw, price) VALUE
	('Sapphire', 'Nitro+', 'AMD Radeon 5700XT', 1840, 8, 306, 285, 450),
	('EVGA', 'FTW3 ULTRA GAMING', 'NVIDIA GeForce RTX 2080 Ti', 1755, 11, 302, 250, 1200),
	('Sapphire', 'Vapor-X', 'AMD Radeon 280X', 1200, 3, 350, 250, 300),
	('MSI', 'ARMOR', 'NVIDIA GeForce GTX 1080 Ti', 1700, 11, 300, 250, 800),
    ('EVGA', 'SC Gaming aCX 3.0', 'NVIDIA GeForce GTX 1070', 1594, 8, 267, 180, 500),
    ('NVIDIA', 'Titan X', 'NVIDIA GeForce GTX Titan X', 1000, 12, 267, 250, 3500),
    ('NVIDIA', 'Titan RTX', 'NVIDIA Titan RTX', 1350, 24, 267, 280, 2500),
    ('XFX', 'Radeon VII', 'AMD Radeon VII', 1400, 16, 280, 295, 600),
    ('Sapphire', 'Nitro+', 'AMD Radeon 580', 1411, 8, 260, 225, 220),
    ('Sapphire', 'Pulse', 'AMD Radeon 5700', 1540, 8, 254, 180, 380),
    ('MSI', 'Gaming 4G', 'NVIDIA GeForce GTX 970', 1076, 4, 269, 145, 350);
    
INSERT INTO ram_(brand, model, type_, capacity, sticks, frequency, timings, power_draw, price) VALUE
	('HyperX', 'Fury', 'DDR4 288-pin DIMM', 16, 4, 3000, '15-16-16-34', 30, 120),
    ('G.Skill', 'Trident Z', 'DDR4 288-pin DIMM', 32, 2, 3200, '14-14-14-34', 30, 250),
    ('Corsair', 'Vengeance', 'DDR4 288-pin DIMM', 16, 2, 5000, '18-26-26-46', 50, 1000),
    ('Corsair', 'Vengeance', 'DDR4 288-pin DIMM', 16, 2, 3200, '16-20-20-38', 30, 80),
    ('Crucial', 'Ballistix RGB', 'DDR4 288-pin DIMM', 64, 2, 3600, '16-18-18-36', 35, 390),
    ('Corsair', 'Dominator Platinum', 'DDR3 240-pin DIMM', 16, 4, 3100, '9-9-9-24', 35, 170);
    
INSERT INTO storage_(brand, model, type_, form_factor, capacity, interface, power_draw, price) VALUE
	('Samsung', '970 Evo', 'SSD', 'M.2', 1000, 'M.2', 10, 170),
    ('Seagate', 'Barracuda', 'Hybrid', '3.5', 2000, 'SATA', 5, 100),
    ('Seagate', 'Barracuda', 'Magnetic', '3.5', 4000, 'SATA', 5, 150),
    ('Western Digital', 'Caviar Blue', 'Magnetic', '3.5', 1000, 'SATA', 5, 45),
    ('Samsung', '860 Evo', 'SSD', '2.5', 500, 'SATA', 5, 80),
    ('Seagate', 'Barracuda Compute', 'Magnetic', '3.5', 2000, 'SATA', 5, 55),
    ('Seagate', 'IronWolf Pro', 'Magnetic', '3.5', 16000, 'SATA', 15, 480),
    ('Western Digital', 'Black', 'Magnetic', '3.5', 1000, 'SATA', 5, 73),
    ('Kingston', 'KC2000', 'SSD', 'M.2', 2000, 'M.2', 10, 450),
    ('Crucial', 'P1', 'SSD', 'M.2', 1000, 'M.2', 10, 100),
    ('Crucial', 'MX500', 'SSD', '2.5', 2000, 'SATA', 10, 230)
;

INSERT INTO psu_(brand, model, wattage, efficiency, form_factor, modularity, price) VALUE
	('Seasonic', 'PRIME', 1000, '80+ Platinum', 'ATX', 'Full', 180),
    ('Seasonic', 'PRIME', 700, '80+ Platinum', 'ATX', 'Full', 120),
    ('Silverstone', 'SX650-G', 650, '80+ Gold', 'SFX', 'Full', 120),
    ('EVGA', 'BR', 500, '80+ Bronze', 'ATX', 'No', 55),
    ('EVGA', 'BQ', 600, '80+ Bronze', 'ATX', 'Semi', 65),
    ('EVGA', 'GM', 550, '80+ Gold', 'SFX', 'Full', 90),
    ('Seasonic', 'FOCUS', 750, '80+ Gold', 'ATX', 'Full', 115),
    ('Seasonic', 'PRIME', 1000, '80+ Titanium', 'ATX', 'Full', 280),
    ('Corsair', 'RM', 750, '80+ Gold', 'ATX', 'Full', 120),
    ('Cooler Master', 'Silent Pro Hybrid', 1300, '80+ Gold', 'ATX', 'Full', 660),
    ('Cooler Master', 'MasterWatt', 650, '80+ Bronze', 'ATX', 'Semi', 85)
;

INSERT INTO psu_connections_(psu_brand, psu_name, psu_wattage, psu_efficiency, connection_) VALUE
	('Seasonic', 'PRIME', 1000, '80+ Platinum', '1 x EPS 8-pin'),
    ('Seasonic', 'PRIME', 1000, '80+ Platinum', '10 x PCIe 6+2-pin'),
    ('Seasonic', 'PRIME', 1000, '80+ Platinum', '10 x SATA'),
    ('Seasonic', 'PRIME', 1000, '80+ Platinum', '1 x 24-pin'),
    ('Silverstone', 'SX650-G', 650, '80+ Gold', '1 x EPS 8-pin'),
    ('Silverstone', 'SX650-G', 650, '80+ Gold', '4 x PCIe 6+2-pin'),
    ('Silverstone', 'SX650-G', 650, '80+ Gold', '6 x SATA'),
    ('Silverstone', 'SX650-G', 650, '80+ Gold', '1 x 24-pin'),
    ('Seasonic', 'PRIME', 700, '80+ Platinum', '1 x EPS 8-pin'),
    ('Seasonic', 'PRIME', 700, '80+ Platinum', '8 x PCIe 6+2-pin'),
    ('Seasonic', 'PRIME', 700, '80+ Platinum', '8 x SATA'),
    ('Seasonic', 'PRIME', 700, '80+ Platinum', '1 x 24-pin'),
    ('EVGA', 'BR', 500, '80+ Bronze', '1 x EPS 8-pin'),
    ('EVGA', 'BR', 500, '80+ Bronze', '2 x PCIe 6+2-pin'),
    ('EVGA', 'BR', 500, '80+ Bronze', '6 x SATA'),
    ('EVGA', 'BR', 500, '80+ Bronze', '1 x 24-pin'),
    ('EVGA', 'BQ', 600, '80+ Bronze', '1 x EPS 8-pin'),
    ('EVGA', 'BQ', 600, '80+ Bronze', '2 x PCIe 6+2-pin'),
    ('EVGA', 'BQ', 600, '80+ Bronze', '6 x SATA'),
    ('EVGA', 'BQ', 600, '80+ Bronze', '1 x 24-pin'),
    ('EVGA', 'GM', 550, '80+ Gold', '1 x EPS 8-pin'),
    ('EVGA', 'GM', 550, '80+ Gold', '4 x PCIe 6+2-pin'),
    ('EVGA', 'GM', 550, '80+ Gold', '4 x SATA'),
    ('EVGA', 'GM', 550, '80+ Gold', '1 x 24-pin'),
    ('Seasonic', 'FOCUS', 750, '80+ Gold', '2 x EPS 8-pin'),
    ('Seasonic', 'FOCUS', 750, '80+ Gold', '4 x PCIe 6+2-pin'),
    ('Seasonic', 'FOCUS', 750, '80+ Gold', '8 x SATA'),
    ('Seasonic', 'FOCUS', 750, '80+ Gold', '1 x 24-pin'),
    ('Seasonic', 'PRIME', 1000, '80+ Titanium', '2 x EPS 8-pin'),
    ('Seasonic', 'PRIME', 1000, '80+ Titanium', '8 x PCIe 6+2-pin'),
    ('Seasonic', 'PRIME', 1000, '80+ Titanium', '14 x SATA'),
    ('Seasonic', 'PRIME', 1000, '80+ Titanium', '1 x 24-pin'),
    ('Corsair', 'RM', 750, '80+ Gold', '2 x EPS 8-pin'),
    ('Corsair', 'RM', 750, '80+ Gold', '6 x PCIe 6+2-pin'),
    ('Corsair', 'RM', 750, '80+ Gold', '10 x SATA'),
    ('Corsair', 'RM', 750, '80+ Gold', '1 x 24-pin'),
    ('Cooler Master', 'Silent Pro Hybrid', 1300, '80+ Gold', '2 x EPS 8-pin'),
    ('Cooler Master', 'Silent Pro Hybrid', 1300, '80+ Gold', '8 x PCIe 6+2-pin'),
    ('Cooler Master', 'Silent Pro Hybrid', 1300, '80+ Gold', '12 x SATA'),
    ('Cooler Master', 'Silent Pro Hybrid', 1300, '80+ Gold', '1 x 24-pin'),
    ('Cooler Master', 'MasterWatt', 650, '80+ Bronze', '1 x EPS 8-pin'),
    ('Cooler Master', 'MasterWatt', 650, '80+ Bronze', '4 x PCIe 6+2-pin'),
    ('Cooler Master', 'MasterWatt', 650, '80+ Bronze', '9 x SATA'),
    ('Cooler Master', 'MasterWatt', 650, '80+ Bronze', '1 x 24-pin')
;

INSERT INTO cooler_(brand, model, type_, rad_size, power_draw, price) VALUE
	('NZXT', 'Kraken X62', 'Water', 280, 20, 160),
    ('Corsair', 'H55', 'Water', 120, 20, 70),
    ('Noctua', 'NH-U9 TR4-SP3', 'Air', NULL, 10, 70),
    ('Noctua', 'NH-U14S TR4-SP3', 'Air', NULL, 10, 80),
    ('Cooler Master', 'MasterLiquid ML360 TR4 Edition', 'Water', 360, 20, 140),
    ('EVGA', 'CLC 280', 'Water', 280, 20, 120),
    ('be quiet!', 'Dark Rock Pro 4', 'Air', NULL, 10, 85),
    ('Cooler Master', 'HEDT Plus', 'Air', NULL, 20, 90)
;

INSERT INTO cooler_socket_support_ (cooler_brand, cooler_name, socket_) VALUE
	('NZXT', 'Kraken X62', 'AM4'),
    ('NZXT', 'Kraken X62', 'AM3'),
    ('NZXT', 'Kraken X62', 'AM3+'),
    ('NZXT', 'Kraken X62', 'LGA1151'),
    ('NZXT', 'Kraken X62', 'LGA1150'),
    ('Corsair', 'H55', 'AM4'),
    ('Corsair', 'H55', 'LGA1151'),
    ('Noctua', 'NH-U9 TR4-SP3', 'sTR4'),
    ('Noctua', 'NH-U9 TR4-SP3', 'sTRX4'),
    ('Noctua', 'NH-U14S TR4-SP3', 'sTR4'),
    ('Noctua', 'NH-U14S TR4-SP3', 'sTRX4'),
    ('Cooler Master', 'MasterLiquid ML360 TR4 Edition', 'sTR4'),
    ('Cooler Master', 'MasterLiquid ML360 TR4 Edition', 'sTRX4'),
    ('Cooler Master', 'MasterLiquid ML360 TR4 Edition', 'AM4'),
    ('EVGA', 'CLC 280', 'AM4'),
    ('EVGA', 'CLC 280', 'LGA1151'),
    ('EVGA', 'CLC 280', 'LGA1150'),
    ('be quiet!', 'Dark Rock Pro 4', 'AM4'),
    ('be quiet!', 'Dark Rock Pro 4', 'AM3'),
    ('be quiet!', 'Dark Rock Pro 4', 'AM3+'),
    ('be quiet!', 'Dark Rock Pro 4', 'LGA1151'),
    ('be quiet!', 'Dark Rock Pro 4', 'LGA1150'),
    ('Cooler Master', 'HEDT Plus', 'LGA2011-3')
;

INSERT INTO case_(brand, model, length, width, height, form_factor, gpu_clearance, rad_clearance, price) VALUE
	('Phanteks', 'Enthoo Luxe', 560, 235, 550, 'Full', 472, 280, 160),
    ('Phanteks', 'Evolv Shift', 274, 170, 470, 'Mini', 350, 120, 110),
    ('NZXT', 'H500', 428, 210, 460, 'Mid', 381, 240, 130),
    ('Cooler Master', 'H500', 450, 220, 445, 'Mid', 410, 360, 105),
    ('Lian Li', 'O11 Dynamic', 445, 272, 446, 'Full', 420, 360, 180),
    ('Lian Li', 'Lancool II', 478, 229, 494, 'Mid', 384, 360, 110),
    ('Fractal Design', 'Meshify C', 413, 217, 453, 'Mid', 315, 240, 90),
    ('Cooler Master', 'Elite 110', 281, 208, 261, 'Mini', 210, 120, 50)
;

INSERT INTO case_motherboard_support_(case_brand, case_name, motherboard_form_factor) VALUE
	('Phanteks', 'Enthoo Luxe', 'ATX'),
    ('Phanteks', 'Enthoo Luxe', 'Micro-ATX'),
    ('Phanteks', 'Enthoo Luxe', 'Mini-ITX'),
    ('Phanteks', 'Enthoo Luxe', 'EATX'),
    ('Phanteks', 'Evolv Shift', 'Mini-ITX'),
    ('NZXT', 'H500', 'ATX'),
    ('NZXT', 'H500', 'Micro-ATX'),
    ('NZXT', 'H500', 'Mini-ITX'),
    ('Cooler Master', 'H500', 'ATX'),
    ('Cooler Master', 'H500', 'Micro-ATX'),
    ('Cooler Master', 'H500', 'Mini-ITX'),
    ('Lian Li', 'O11 Dynamic', 'ATX'),
    ('Lian Li', 'O11 Dynamic', 'Micro-ATX'),
    ('Lian Li', 'O11 Dynamic', 'Mini-ITX'),
    ('Lian Li', 'O11 Dynamic', 'EATX'),
    ('Lian Li', 'Lancool II', 'ATX'),
    ('Lian Li', 'Lancool II', 'Micro-ATX'),
    ('Lian Li', 'Lancool II', 'Mini-ITX'),
    ('Fractal Design', 'Meshify C', 'ATX'),
    ('Fractal Design', 'Meshify C', 'Micro-ATX'),
    ('Fractal Design', 'Meshify C', 'Mini-ITX'),
    ('Cooler Master', 'Elite 110', 'Mini-ITX')
;

INSERT INTO motherboard_(brand, model, socket_, multi_gpu, chipset, form_factor, max_ram, ram_slots, power_draw, price, ram_type) VALUE
	('ASUS', 'MAXIMUS HERO VIII', 'LGA1151', 3, 'Z170', 'ATX', 64, 4, 60, 170, 'DDR4 288-pin DIMM'),
    ('Gigabyte', 'AORUS PRO WIFI', 'AM4', 1, 'B450', 'Mini-ITX', 32, 2, 50, 120, 'DDR4 288-pin DIMM'),
    ('ASUS', 'ROG STRIX Z390-E GAMING', 'LGA1151', 3, 'Z390', 'ATX', 128, 4, 70, 230, 'DDR4 288-pin DIMM'),
    ('ASRock', 'B365M Pro4', 'LGA1151', 2, 'B365', 'Micro-ATX', 64, 4, 50, 75, 'DDR4 288-pin DIMM'),
    ('ASUS', 'TUF SABERTOOTH 990FX R3.0','AM3+', 3, '990FX', 'ATX', 32, 4, 50, 60, 'DDR3 240-pin DIMM'),
    ('Gigabyte', 'GA-970 Gaming','AM3+', 3, '970', 'ATX', 64, 4, 55, 90, 'DDR3 240-pin DIMM'),
    ('MSI', 'TOMAHAWK','AM4', 3, 'B450', 'ATX', 64, 4, 50, 110, 'DDR4 288-pin DIMM'),
    ('MSI', 'GAMING PRO CARBON','AM4', 3, 'X570', 'ATX', 128, 4, 70, 240, 'DDR4 288-pin DIMM'),
    ('ASUS', 'Rampage V','LGA2011-3', 3, 'X99', 'EATX', 128, 8, 90, 350, 'DDR4 288-pin DIMM'),
    ('MSI', 'B85M-E45','LGA1150', 1, 'B85', 'Micro-ATX', 32, 4, 45, 80, 'DDR3 240-pin DIMM'),
    ('Gigabyte', 'GA-Z87X-UD3H','LGA1150', 2, 'Z87', 'ATX', 32, 4, 60, 90, 'DDR3 240-pin DIMM'),
    ('Gigabyte', 'AORUS Gaming 7','sTR4', 3, 'X399', 'ATX', 128, 8, 80, 250, 'DDR4 288-pin DIMM'),
    ('Gigabyte', 'AORUS XTREME XL','sTRX4', 3, 'TRX40','EATX', 256, 8, 90, 850, 'DDR4 288-pin DIMM'),
    ('ASRock', 'Creator','sTRX4', 3, 'TRX40', 'ATX', 256, 8, 85, 460, 'DDR4 288-pin DIMM'),
    ('Gigabyte', 'AORUS PRO WIFI Mini','LGA1151', 1, 'Z390','Mini-ITX', 64, 2, 50, 165, 'DDR4 288-pin DIMM')
;

INSERT INTO motherboard_storage_types_(motherboard_brand, motherboard_name, type_, quantity) VALUE
	('ASUS', 'MAXIMUS HERO VIII', 'SATA', 6),
    ('ASUS', 'MAXIMUS HERO VIII', 'M.2', 1),
    ('Gigabyte', 'AORUS PRO WIFI', 'SATA', 4),
    ('Gigabyte', 'AORUS PRO WIFI', 'M.2', 1),
    ('ASUS', 'ROG STRIX Z390-E GAMING', 'SATA', 6),
    ('ASUS', 'ROG STRIX Z390-E GAMING', 'M.2', 2),
    ('ASRock', 'B365M Pro4', 'SATA', 6),
    ('ASRock', 'B365M Pro4', 'M.2', 3),
    ('ASUS', 'TUF SABERTOOTH 990FX R3.0', 'SATA', 5),
    ('ASUS', 'TUF SABERTOOTH 990FX R3.0', 'M.2', 1),
    ('Gigabyte', 'GA-970 GAMING', 'SATA', 6),
    ('Gigabyte', 'GA-970 GAMING', 'M.2', 1),
    ('MSI', 'TOMAHAWK', 'SATA', 6),
    ('MSI', 'TOMAHAWK', 'M.2', 1),
    ('MSI', 'GAMING PRO CARBON', 'SATA', 6),
    ('MSI', 'GAMING PRO CARBON', 'M.2', 3),
    ('ASUS', 'Rampage V', 'SATA', 10),
    ('ASUS', 'Rampage V', 'U.2', 1),
    ('ASUS', 'Rampage V', 'M.2', 1),
    ('MSI', 'B85M-E45', 'SATA', 4),
    ('Gigabyte', 'GA-Z87X-UD3H', 'SATA', 8),
    ('Gigabyte', 'AORUS Gaming 7', 'SATA', 8),
    ('Gigabyte', 'AORUS Gaming 7', 'M.2', 3),
    ('Gigabyte', 'AORUS XTREME XL', 'SATA', 10),
    ('Gigabyte', 'AORUS XTREME XL', 'M.2', 4),
    ('ASRock', 'Creator', 'SATA', 8),
    ('ASRock', 'Creator', 'M.2', 3),
    ('Gigabyte', 'AORUS PRO WIFI Mini', 'SATA', 4),
    ('Gigabyte', 'AORUS PRO WIFI Mini', 'M.2', 2)
;

INSERT INTO motherboard_ram_speeds_(motherboard_brand, motherboard_name, speed) VALUE
	('ASUS', 'MAXIMUS HERO VIII', 2133),
    ('ASUS', 'MAXIMUS HERO VIII', 2400),
    ('ASUS', 'MAXIMUS HERO VIII', 2666),
    ('ASUS', 'MAXIMUS HERO VIII', 2800),
    ('ASUS', 'MAXIMUS HERO VIII', 3000),
    ('ASUS', 'MAXIMUS HERO VIII', 3200),
    ('ASUS', 'MAXIMUS HERO VIII', 3300),
    ('ASUS', 'MAXIMUS HERO VIII', 3400),
    ('Gigabyte', 'AORUS PRO WIFI', 2133),
    ('Gigabyte', 'AORUS PRO WIFI', 2400),
    ('Gigabyte', 'AORUS PRO WIFI', 2666),
    ('Gigabyte', 'AORUS PRO WIFI', 2933),
    ('Gigabyte', 'AORUS PRO WIFI', 3200),
    ('ASUS', 'ROG STRIX Z390-E GAMING', 2133),
    ('ASUS', 'ROG STRIX Z390-E GAMING', 2400),
    ('ASUS', 'ROG STRIX Z390-E GAMING', 2666),
    ('ASUS', 'ROG STRIX Z390-E GAMING', 2800),
    ('ASUS', 'ROG STRIX Z390-E GAMING', 3000),
    ('ASUS', 'ROG STRIX Z390-E GAMING', 3200),
    ('ASUS', 'ROG STRIX Z390-E GAMING', 3300),
    ('ASUS', 'ROG STRIX Z390-E GAMING', 3333),
    ('ASUS', 'ROG STRIX Z390-E GAMING', 3400),
    ('ASUS', 'ROG STRIX Z390-E GAMING', 3466),
    ('ASUS', 'ROG STRIX Z390-E GAMING', 3600),
    ('ASUS', 'ROG STRIX Z390-E GAMING', 3733),
    ('ASUS', 'ROG STRIX Z390-E GAMING', 3866),
    ('ASUS', 'ROG STRIX Z390-E GAMING', 4000),
    ('ASUS', 'ROG STRIX Z390-E GAMING', 4133),
    ('ASUS', 'ROG STRIX Z390-E GAMING', 4266),
    ('ASRock', 'B365M Pro4', 2133),
    ('ASRock', 'B365M Pro4', 2400),
    ('ASRock', 'B365M Pro4', 2666),
    ('ASUS', 'TUF SABERTOOTH 990FX R3.0', 1066),
    ('ASUS', 'TUF SABERTOOTH 990FX R3.0', 1333),
    ('ASUS', 'TUF SABERTOOTH 990FX R3.0', 1600),
    ('ASUS', 'TUF SABERTOOTH 990FX R3.0', 1866),
    ('ASUS', 'TUF SABERTOOTH 990FX R3.0', 3100),
    ('Gigabyte', 'GA-970 Gaming', 1066),
    ('Gigabyte', 'GA-970 Gaming', 1333),
    ('Gigabyte', 'GA-970 Gaming', 1600),
    ('Gigabyte', 'GA-970 Gaming', 1866),
    ('Gigabyte', 'GA-970 Gaming', 2000),
    ('MSI', 'TOMAHAWK', 1866),
    ('MSI', 'TOMAHAWK', 2133),
    ('MSI', 'TOMAHAWK', 2400),
    ('MSI', 'TOMAHAWK', 2666),
    ('MSI', 'TOMAHAWK', 2800),
    ('MSI', 'TOMAHAWK', 2933),
    ('MSI', 'TOMAHAWK', 3000),
    ('MSI', 'TOMAHAWK', 3200),
    ('MSI', 'TOMAHAWK', 3466),
    ('MSI', 'GAMING PRO CARBON', 1866),
    ('MSI', 'GAMING PRO CARBON', 2133),
    ('MSI', 'GAMING PRO CARBON', 2400),
    ('MSI', 'GAMING PRO CARBON', 2666),
    ('MSI', 'GAMING PRO CARBON', 2800),
    ('MSI', 'GAMING PRO CARBON', 2933),
    ('MSI', 'GAMING PRO CARBON', 3000),
    ('MSI', 'GAMING PRO CARBON', 3200),
    ('MSI', 'GAMING PRO CARBON', 3466),
    ('MSI', 'GAMING PRO CARBON', 3600),
    ('MSI', 'GAMING PRO CARBON', 3733),
    ('MSI', 'GAMING PRO CARBON', 3866),
    ('MSI', 'GAMING PRO CARBON', 4000),
    ('MSI', 'GAMING PRO CARBON', 4133),
    ('MSI', 'GAMING PRO CARBON', 4266),
    ('MSI', 'GAMING PRO CARBON', 4400),
    ('ASUS', 'Rampage V', 2133),
    ('ASUS', 'Rampage V', 2400),
    ('ASUS', 'Rampage V', 2666),
    ('ASUS', 'Rampage V', 2800),
    ('ASUS', 'Rampage V', 3000),
    ('ASUS', 'Rampage V', 3200),
    ('ASUS', 'Rampage V', 3300),
    ('ASUS', 'Rampage V', 3333),
    ('MSI', 'B85M-E45', 1066),
    ('MSI', 'B85M-E45', 1333),
    ('MSI', 'B85M-E45', 1600),
    ('Gigabyte', 'GA-Z87X-UD3H', 1333),
    ('Gigabyte', 'GA-Z87X-UD3H', 1600),
    ('Gigabyte', 'GA-Z87X-UD3H', 1800),
    ('Gigabyte', 'GA-Z87X-UD3H', 1866),
    ('Gigabyte', 'GA-Z87X-UD3H', 2000),
    ('Gigabyte', 'GA-Z87X-UD3H', 2133),
    ('Gigabyte', 'GA-Z87X-UD3H', 2200),
    ('Gigabyte', 'GA-Z87X-UD3H', 2400),
    ('Gigabyte', 'GA-Z87X-UD3H', 2500),
    ('Gigabyte', 'GA-Z87X-UD3H', 2600),
    ('Gigabyte', 'GA-Z87X-UD3H', 2666),
    ('Gigabyte', 'GA-Z87X-UD3H', 2800),
    ('Gigabyte', 'GA-Z87X-UD3H', 2933),
    ('Gigabyte', 'GA-Z87X-UD3H', 3000),
    ('Gigabyte', 'AORUS Gaming 7', 2133),
    ('Gigabyte', 'AORUS Gaming 7', 2400),
    ('Gigabyte', 'AORUS Gaming 7', 2666),
    ('Gigabyte', 'AORUS XTREME XL', 2133),
    ('Gigabyte', 'AORUS XTREME XL', 2400),
    ('Gigabyte', 'AORUS XTREME XL', 2666),
    ('Gigabyte', 'AORUS XTREME XL', 2933),
    ('Gigabyte', 'AORUS XTREME XL', 3200),
    ('Gigabyte', 'AORUS XTREME XL', 3300),
    ('Gigabyte', 'AORUS XTREME XL', 3333),
    ('Gigabyte', 'AORUS XTREME XL', 3400),
    ('Gigabyte', 'AORUS XTREME XL', 3466),
    ('Gigabyte', 'AORUS XTREME XL', 3600),
    ('Gigabyte', 'AORUS XTREME XL', 3733),
    ('Gigabyte', 'AORUS XTREME XL', 3866),
    ('Gigabyte', 'AORUS XTREME XL', 4000),
    ('Gigabyte', 'AORUS XTREME XL', 4133),
    ('Gigabyte', 'AORUS XTREME XL', 4266),
    ('Gigabyte', 'AORUS XTREME XL', 4400),
    ('ASRock', 'Creator', 2133),
    ('ASRock', 'Creator', 2400),
    ('ASRock', 'Creator', 2666),
    ('ASRock', 'Creator', 2933),
    ('ASRock', 'Creator', 3200),
    ('ASRock', 'Creator', 3466),
    ('ASRock', 'Creator', 3600),
    ('ASRock', 'Creator', 3733),
    ('ASRock', 'Creator', 3800),
    ('ASRock', 'Creator', 3866),
    ('ASRock', 'Creator', 4000),
    ('ASRock', 'Creator', 4133),
    ('ASRock', 'Creator', 4200),
    ('ASRock', 'Creator', 4266),
    ('ASRock', 'Creator', 4333),
    ('ASRock', 'Creator', 4400),
    ('ASRock', 'Creator', 4533),
    ('ASRock', 'Creator', 4600),
    ('ASRock', 'Creator', 4666),
    ('Gigabyte', 'AORUS PRO WIFI Mini', 2133),
    ('Gigabyte', 'AORUS PRO WIFI Mini', 2400),
    ('Gigabyte', 'AORUS PRO WIFI Mini', 2666)
;


INSERT INTO build_(bname, ID, motherboard_brand, motherboard_name, psu_brand, psu_name, psu_wattage, psu_efficiency, ram_brand, ram_name, ram_frequency, ram_capacity, ram_type, case_brand, case_name, cpu_brand, cpu_name, cooler_brand, cooler_name) VALUE
	('Cole\'s Build', 1, 'ASUS', 'MAXIMUS HERO VIII', 'Seasonic', 'PRIME', 1000, '80+ Platinum', 'HyperX', 'Fury', 3000, 16, 'DDR4 288-pin DIMM', 'Phanteks', 'Enthoo Luxe', 'Intel', 'Core i7 7700k', 'NZXT', 'Kraken X62'),
    ('Cole\'s Super Rig', 1, 'MSI', 'GAMING PRO CARBON', 'Seasonic', 'PRIME', 1000, '80+ Titanium', 'G.Skill', 'Trident Z', 3200, 32, 'DDR4 288-pin DIMM', 'Lian Li', 'O11 Dynamic', 'AMD', 'Ryzen 9 3950X', 'Cooler Master', 'MasterLiquid ML360 TR4 Edition'),
    ('Small Form Factor Build', 6, 'Gigabyte', 'AORUS PRO WIFI', 'Silverstone', 'SX650-G', 650, '80+ Gold', 'Corsair', 'Vengeance', 3200, 16, 'DDR4 288-pin DIMM', 'Phanteks', 'Evolv Shift', 'AMD', 'Ryzen 7 2700X', 'Corsair', 'H55'),
    ('The Bibblerson', 3, 'ASUS', 'ROG STRIX Z390-E GAMING', 'EVGA', 'BQ', 600, '80+ Bronze', 'Corsair', 'Vengeance', 3200, 16, 'DDR4 288-pin DIMM', 'Lian Li', 'O11 Dynamic', 'Intel', 'Core i7 7700k', 'NZXT', 'Kraken X62'),
    ('Super Swede', 4, 'MSI', 'GAMING PRO CARBON', 'Corsair', 'RM', 750, '80+ Gold', 'G.Skill', 'Trident Z', 3200, 32, 'DDR4 288-pin DIMM', 'Cooler Master', 'H500', 'AMD', 'Ryzen 7 2700X', 'EVGA', 'CLC 280'),
    ('Father Fastfingers', 5, 'Gigabyte', 'AORUS Gaming 7', 'Seasonic', 'PRIME', 1000, '80+ Titanium', 'G.Skill', 'Trident Z', 3200, 32, 'DDR4 288-pin DIMM', 'Lian Li', 'Lancool II', 'AMD', 'Threadripper 2990WX', 'Noctua', 'NH-U9 TR4-SP3'),
    ('Basement Dweller', 2, 'ASUS', 'TUF SABERTOOTH 990FX R3.0', 'EVGA', 'BR', 500, '80+ Bronze', 'Corsair', 'Dominator Platinum', 3100, 16,'DDR3 240-pin DIMM', 'NZXT', 'H500', 'AMD', 'FX 6350', 'be quiet!', 'Dark Rock Pro 4'),
	('Basement Dweller MK.2', 2, 'MSI', 'GAMING PRO CARBON', 'Corsair', 'RM', 750, '80+ Gold', 'HyperX', 'Fury', 3000, 16, 'DDR4 288-pin DIMM', 'NZXT', 'H500', 'AMD', 'Ryzen 5 1600', 'Corsair', 'H55'),
    ('Ayyy Lmao', 7, 'MSI', 'B85M-E45', 'EVGA', 'BQ', 600, '80+ Bronze', 'Corsair', 'Dominator Platinum', 3100, 16, 'DDR3 240-pin DIMM', 'Fractal Design', 'Meshify C', 'Intel', 'Core i7 4770k', 'be quiet!', 'Dark Rock Pro 4'),
    ('First Build', 8, 'Gigabyte', 'GA-Z87X-UD3H', 'Cooler Master', 'MasterWatt', 650, '80+ Bronze', 'Corsair', 'Dominator Platinum', 3100, 16, 'DDR3 240-pin DIMM', 'Fractal Design', 'Meshify C', 'Intel', 'Core i7 4770k', 'be quiet!', 'Dark Rock Pro 4'),
    ('Rich Boy', 8, 'ASUS', 'ROG STRIX Z390-E GAMING', 'Cooler Master', 'Silent Pro Hybrid', 1300, '80+ Gold', 'Crucial', 'Ballistix RGB', 3600, 64, 'DDR4 288-pin DIMM', 'Lian Li', 'O11 Dynamic', 'Intel', 'Core i9 9900k', 'Cooler Master', 'MasterLiquid ML360 TR4 Edition'),
    ('Server Build', 8, 'ASUS', 'Rampage V', 'Seasonic', 'PRIME', 1000, '80+ Titanium', 'G.Skill', 'Trident Z', 3200, 32, 'DDR4 288-pin DIMM', 'Lian Li', 'O11 Dynamic', 'Intel', 'Xeon E5-2699', 'Cooler Master', 'HEDT Plus'),
    ('Server Build', 1, 'Gigabyte', 'AORUS XTREME XL', 'Cooler Master', 'Silent Pro Hybrid', 1300, '80+ Gold', 'Crucial', 'Ballistix RGB', 3600, 64, 'DDR4 288-pin DIMM', 'Phanteks', 'Enthoo Luxe', 'AMD', 'Threadripper 3990X', 'Cooler Master', 'MasterLiquid ML360 TR4 Edition')
;


INSERT INTO storage_list_(build_name, user_ID, storage_brand, storage_name, storage_capacity, storage_quantity) VALUE
	('Cole\'s Build', 1, 'Seagate', 'Barracuda', 2000, 1),
    ('Cole\'s Build', 1, 'Samsung', '970 Evo', 1000, 1),
    ('Cole\'s Build', 1, 'Samsung', '860 Evo', 500, 1),
    ('Cole\'s Super Rig', 1, 'Samsung', '970 Evo', 1000, 2),
    ('Cole\'s Super Rig', 1, 'Seagate', 'IronWolf Pro', 16000, 1),
    ('Small Form Factor Build', 6, 'Samsung', '970 Evo', 1000, 1),
    ('Small Form Factor Build', 6, 'Seagate', 'Barracuda', 2000, 1),
    ('The Bibblerson', 3, 'Kingston', 'KC2000', 2000, 1),
    ('Super Swede', 4, 'Samsung', '970 Evo', 1000, 1),
    ('Super Swede', 4, 'Western Digital', 'Caviar Blue', 1000, 1),
    ('Father Fastfingers', 5, 'Crucial', 'MX500', 2000, 1),
    ('Basement Dweller', 2, 'Western Digital', 'Black', 1000, 1),
    ('Basement Dweller MK.2', 2, 'Crucial', 'P1', 1000, 1),
    ('Basement Dweller MK.2', 2, 'Seagate', 'Barracuda Compute', 2000, 1),
    ('Ayyy Lmao', 7, 'Samsung', '860 Evo', 500, 2),
    ('First Build', 8, 'Western Digital', 'Caviar Blue', 1000, 1),
    ('First Build', 8, 'Samsung', '860 Evo', 500, 1),
    ('Rich Boy', 8, 'Samsung', '970 Evo', 1000, 3),
    ('Server Build', 8, 'Seagate', 'Barracuda', 4000, 4),
    ('Server Build', 1, 'Seagate', 'IronWolf Pro', 16000, 4),
    ('Server Build', 1, 'Samsung', '970 Evo', 1000, 1)
;

INSERT INTO gpu_list_(build_name, user_ID, gpu_brand, gpu_name, gpu_chip, gpu_quantity) VALUE
	('Cole\'s Build', 1, 'MSI', 'ARMOR', 'NVIDIA GeForce GTX 1080 Ti', 1),
    ('Cole\'s Super Rig', 1, 'NVIDIA', 'Titan RTX', 'NVIDIA Titan RTX', 2),
    ('Cole\'s Super Rig', 1, 'Sapphire', 'Nitro+', 'AMD Radeon 5700XT', 2),
    ('Small Form Factor Build', 6, 'Sapphire', 'Pulse', 'AMD Radeon 5700', 1),
    ('The Bibblerson', 3, 'EVGA', 'FTW3 ULTRA GAMING', 'NVIDIA GeForce RTX 2080 Ti', 1),
    ('Super Swede', 4, 'Sapphire', 'Nitro+', 'AMD Radeon 5700XT', 1),
    ('Father Fastfingers', 5, 'MSI', 'Gaming 4G', 'NVIDIA GeForce GTX 970', 1),
    ('Basement Dweller', 2, 'Sapphire', 'Vapor-X', 'AMD Radeon 280X', 1),
    ('Basement Dweller MK.2', 2, 'EVGA', 'SC Gaming aCX 3.0', 'NVIDIA GeForce GTX 1070', 1),
    ('Ayyy Lmao', 7, 'Sapphire', 'Nitro+', 'AMD Radeon 580', 1),
	('First Build', 8, 'MSI', 'Gaming 4G', 'NVIDIA GeForce GTX 970', 1),
    ('Rich Boy', 8, 'EVGA', 'FTW3 ULTRA GAMING', 'NVIDIA GeForce RTX 2080 Ti', 2),
    ('Server Build', 8, 'NVIDIA', 'Titan X', 'NVIDIA GeForce GTX Titan X', 2),
    ('Server Build', 1, 'XFX', 'Radeon VII', 'AMD Radeon VII', 4)
;    
# Begin function declaration
SET GLOBAL log_bin_trust_function_creators = 1;

# This function will return the total price of the build passed to it
DROP FUNCTION IF EXISTS `build_price`;
DELIMITER $$
CREATE FUNCTION `build_price`
(
	ident INT,
	namae VARCHAR(100)
)
RETURNS INT
BEGIN
	DECLARE retVAL INT;
    SELECT (motherboard_.price + ram_.price + cpu_.price + cooler_.price + case_.price + psu_.price + s1.`STORAGE PRICE` + g1.`GPU PRICE`) AS `Build_Price` INTO retVAL
    FROM build_
    JOIN motherboard_ ON (build_.motherboard_name, build_.motherboard_brand) = (motherboard_.model, motherboard_.brand)
    JOIN ram_ ON (build_.ram_name, build_.ram_brand, build_.ram_frequency, build_.ram_capacity, build_.ram_type) = (ram_.model, ram_.brand, ram_.frequency, ram_.capacity, ram_.type_)
    JOIN psu_ ON (build_.psu_name, build_.psu_brand, build_.psu_wattage, build_.psu_efficiency) = (psu_.model, psu_.brand, psu_. wattage, psu_.efficiency)
    JOIN case_ ON (build_.case_name, build_.case_brand) = (case_.model, case_.brand)
    JOIN cpu_ ON (build_.cpu_name, build_.cpu_brand) = (cpu_.model, cpu_.brand)
    JOIN cooler_ ON (build_.cooler_name, build_.cooler_brand) = (cooler_.model, cooler_.brand)
    JOIN storage_list_ ON (build_.bname, build_.ID) = (storage_list_.build_name, storage_list_.user_ID)
    JOIN storage_ ON (storage_list_.storage_name, storage_list_.storage_brand, storage_list_.storage_capacity) = (storage_.model, storage_.brand, storage_.capacity)
    JOIN (SELECT gpu_list_.build_name, gpu_list_.user_ID, SUM(gpu_.price * gpu_list_.gpu_quantity) AS `GPU PRICE`
			FROM gpu_ 
			JOIN gpu_list_ ON (gpu_.model, gpu_.brand, gpu_.chip) = (gpu_list_.gpu_name, gpu_list_.gpu_brand, gpu_list_.gpu_chip)
			GROUP BY gpu_list_.build_name, gpu_list_.user_ID) AS g1 ON (g1.build_name, g1.user_ID) = (build_.bname, build_.ID)
	JOIN (SELECT storage_list_.build_name, storage_list_.user_ID, SUM(storage_.price * storage_list_.storage_quantity) AS `STORAGE PRICE`
			FROM storage_ 
			JOIN storage_list_ ON (storage_.model, storage_.brand, storage_.capacity) = (storage_list_.storage_name, storage_list_.storage_brand, storage_list_.storage_capacity)
			GROUP BY storage_list_.build_name, storage_list_.user_ID) AS s1 ON (s1.build_name, s1.user_ID) = (build_.bname, build_.ID)
    WHERE build_.bname = namae AND build_.ID = ident
    GROUP BY build_.ID, build_.bname;
    RETURN retVAL;
END $$
DELIMITER ;

# Begin procedure declaration
# Allows the user to add a new gpu to their current build, or increase the amount of an already existing one
DROP PROCEDURE IF EXISTS add_gpu;
DELIMITER $$
CREATE PROCEDURE add_gpu
(
	userID INT,
	buildname VARCHAR(100),
    gpubrand VARCHAR(100),
    gpuname VARCHAR(100),
    gpuchip VARCHAR(100)
)
BEGIN
	IF (userID, buildname, gpubrand, gpuname, gpuchip) IN (SELECT user_ID, build_name, gpu_brand, gpu_name, gpu_chip FROM gpu_list_) THEN
		UPDATE gpu_list_ SET gpu_quantity = gpu_quantity + 1
		WHERE (userID, buildname, gpubrand, gpuname, gpuchip) = (gpu_list_.user_ID, gpu_list_.build_name, gpu_list_.gpu_brand, gpu_list_.gpu_name, gpu_list_.gpu_chip);
	ELSE
		INSERT INTO gpu_list_(user_ID, build_name, gpu_brand, gpu_name, gpu_chip, gpu_quantity) VALUE
        (userID, buildname, gpubrand, gpuname, gpuchip, 1);
    END IF;
END $$
DELIMITER ;

# Allows the user to remove an instance of a gpu from their build
DROP PROCEDURE IF EXISTS remove_gpu;
DELIMITER $$
CREATE PROCEDURE remove_gpu
(
	userID INT,
    buildname VARCHAR(100),
    gpubrand VARCHAR(100),
    gpuname VARCHAR(100),
    gpuchip VARCHAR(100)
)
BEGIN
	DECLARE gq INT;
    SET gq = (SELECT gpu_quantity - 1 FROM gpu_list_ WHERE (userID, buildname, gpubrand, gpuname, gpuchip) = (gpu_list_.user_ID, gpu_list_.build_name, gpu_list_.gpu_brand, gpu_list_.gpu_name, gpu_list_.gpu_chip));
	UPDATE gpu_list_ SET gpu_quantity = gpu_quantity - 1
    WHERE (userID, buildname, gpubrand, gpuname, gpuchip) = (gpu_list_.user_ID, gpu_list_.build_name, gpu_list_.gpu_brand, gpu_list_.gpu_name, gpu_list_.gpu_chip);
    IF gq <= 0 THEN
		DELETE FROM gpu_list_
		WHERE gpu_list_.gpu_quantity <= 0;
	END IF;
END $$
DELIMITER ;

# Begin view declaration
# The views here can be used to display the most purchased of one item, this can be 
# repeated for each item, but for the sake of brevity I am only including the statements
# for retrieving gpu info
DROP VIEW IF EXISTS most_bought_gpus;
CREATE VIEW most_bought_gpus AS 
	(SELECT gpu_brand AS Manufacturer, gpu_name AS Model, gpu_chip AS Chip, SUM(gpu_quantity) AS Quantity FROM gpu_list_ 
    GROUP BY gpu_brand, gpu_name, gpu_chip
    ORDER BY Quantity DESC);
    
DROP VIEW IF EXISTS most_bought_chip;
CREATE VIEW most_bought_chip AS 
	(SELECT gpu_chip AS Chip, SUM(gpu_quantity) AS Quantity FROM gpu_list_
    GROUP BY gpu_chip
    ORDER BY SUM(gpu_quantity) DESC
    LIMIT 1);
    
DROP VIEW IF EXISTS most_bought_model;
CREATE VIEW most_bought_model AS 
	(SELECT gpu_brand AS Brand, gpu_name AS Model, SUM(gpu_quantity) AS Quantity FROM gpu_list_
    GROUP BY gpu_brand, gpu_name
    ORDER BY SUM(gpu_quantity) DESC
    LIMIT 1);
    
DROP VIEW IF EXISTS most_bought_brand;
CREATE VIEW most_bought_brand AS 
	(SELECT gpu_brand AS Brand, SUM(gpu_quantity) AS Quantity FROM gpu_list_
    GROUP BY gpu_brand
    ORDER BY SUM(gpu_quantity) DESC
    LIMIT 1);
    
DROP VIEW IF EXISTS most_expensive_build;
CREATE VIEW most_expensive_build AS
	(SELECT bname AS `Build`, `build_price`(ID, bname) AS `Price`
    FROM build_
    ORDER BY `Price` DESC
    LIMIT 1);
    
