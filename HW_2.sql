---- **** Ненормалізована таблиця **** ----

CREATE TABLE Orders_NotNF (
	OrderNumber		INT				AUTO_INCREMENT PRIMARY KEY
,	ProductName		VARCHAR(240)
,	Adress			VARCHAR(240)
,	OrderDate		datetime 		DEFAULT (CURRENT_DATE())
,	ClientName		VARCHAR(240)
)
;

---- **** Таблиця в 1НФ **** ----

-- Робимо поле ProductName атомарним (неподільним)
-- штучний ключ Id для унікальності записів
-- унікальність полів (OrderNumber, ProductName) щоб не було повторів в замовлені.
CREATE TABLE Orders_1NF (
	Id				INT				AUTO_INCREMENT PRIMARY KEY
,	OrderNumber		INT				
,	ProductName		VARCHAR(240)
,	Adress			VARCHAR(240)	NULL
,	OrderDate		DATETIME 		DEFAULT (CURRENT_DATE())
,	ClientName		VARCHAR(240)
,	UNIQUE (OrderNumber, ProductName)
)
;
-- !!! так як в таблиці Orders_1NF в нас немає складеного ключа  то таблиця автоматично може вважатися в 2 нормальній формі


---- **** ПРИВЕДЕННЯ ТАБЛИЦЬ ДО 3НФ **** ----

-- USE university;
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Manufacturers;
DROP TABLE IF EXISTS Addresses; 
DROP TABLE IF EXISTS Clients;


CREATE TABLE Clients (
    Id          INT             AUTO_INCREMENT PRIMARY KEY 
,   F_Name      VARCHAR(100)    NOT NULL 
,   L_Name      VARCHAR(100)    NOT NULL 
,   M_Name      VARCHAR(100)    NULL 
,   Gender      ENUM('M', 'F')  NULL 
,   IsActive    BOOLEAN         DEFAULT 1  					-- 1 activ\ 0 no activ
,   Created     DATE            DEFAULT (CURRENT_DATE())
);

CREATE TABLE Addresses (
    Id          INT             AUTO_INCREMENT PRIMARY KEY 
,   ClientId    INT             NOT NULL 
,   Name        VARCHAR(240)    NOT NULL 
,   IsActive    BOOLEAN         DEFAULT 1 					-- 1 activ\ 0 no activ
,   Created     DATE            DEFAULT (CURRENT_DATE()) 
   
,   FOREIGN KEY (ClientId) REFERENCES Clients(Id) ON DELETE CASCADE
);

CREATE TABLE Manufacturers (
    Id          INT             AUTO_INCREMENT PRIMARY KEY 
,   Name        VARCHAR(50)     NOT NULL 
,   IsActive    BOOLEAN         DEFAULT 1 					-- 1 activ\ 0 no activ
,   CreatedAt   DATETIME        DEFAULT CURRENT_TIMESTAMP()
);

CREATE TABLE Products (
    Id              INT             AUTO_INCREMENT PRIMARY KEY 
,   ProductName     VARCHAR(50)     NOT NULL 
,   ManufacturerId  INT             NOT NULL 
,   ProductCount    INT             DEFAULT 0 
,   Price           DECIMAL(10, 2)  NOT NULL CHECK (Price >= 0) 
,   IsActive        BOOLEAN         DEFAULT 1 
,   CreatedAt       DATETIME        DEFAULT CURRENT_TIMESTAMP() 
   
,   FOREIGN KEY (ManufacturerId) REFERENCES Manufacturers(Id) ON DELETE RESTRICT  --  NO ACTION
);

CREATE TABLE Orders (
    Id          INT     AUTO_INCREMENT PRIMARY KEY 
,   ClientId    INT     NOT NULL  
,   CreatedAt   DATE    NOT NULL DEFAULT (CURRENT_DATE()) 	-- Дата оформлення замовлення
   
,   FOREIGN KEY (ClientId) REFERENCES Clients(Id) ON DELETE CASCADE
);

CREATE TABLE OrderDetails (
    Id              INT             AUTO_INCREMENT PRIMARY KEY 
,   OrderId         INT             NOT NULL 
,   ProductId       INT             NOT NULL 
,   ProductCount    INT             DEFAULT 1 				-- Кількість товару у замовленні
,   Price           DECIMAL(10, 2)  NOT NULL 				-- Ціна на момент замовлення (фіксація)
   
,   UNIQUE (OrderId, ProductId) 							-- щоб небуло повторень товару в замовлені
   
,   FOREIGN KEY (OrderId) REFERENCES Orders(Id) ON DELETE CASCADE 
,   FOREIGN KEY (ProductId) REFERENCES Products(Id) ON DELETE RESTRICT
);