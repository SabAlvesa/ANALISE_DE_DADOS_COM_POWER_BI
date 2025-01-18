create database Ecommerce2;
drop database Ecommerce2;

show databases;
USE Ecommerce2;

CREATE TABLE Clients(
    id_Client INT PRIMARY KEY AUTO_INCREMENT,
    Fname VARCHAR(10),
    Minit CHAR(3),
    Lastname VARCHAR(20),
    CPF CHAR(11) NOT NULL,
    Adress VARCHAR(40),
	client_type ENUM('PF', 'PJ') NOT NULL,
    constraint unique_CPF_Client unique (CPF)
);

INSERT INTO Clients (Fname, Minit, Lastname, CPF, Adress)
VALUES
('João', 'A', 'Silva', '12345678901', 'Rua A, 123'),
('Maria', 'B', 'Santos', '98765432109', 'Avenida B, 456'),
('Carlos', 'C', 'Oliveira', '11122334455', 'Praça C, 789');



Create table Product(
	id_Product int primary key auto_increment,
	Pname varchar(10),
    Classification_kids bool default false,
    Category enum ('Eletrônico', 'Vestimentas', 'Brinquedos', 'Alimentos', 'Móveis') not null,
    Avaliacao float default 0,
    size varchar(10)
    );

INSERT INTO Product (Pname, Classification_kids, Category, Avaliacao, size)
VALUES
('TV', false, 'Eletrônico', 4.5, '42"'),
('Camiseta', true, 'Vestimentas', 3.8, 'M'),
('Boneca', true, 'Brinquedos', 5.0, 'P'),
('Arroz', false, 'Alimentos', 4.2, '1kg'),
('Sofá', false, 'Móveis', 4.7, '2m');


Create table payment(
    id_Payment int primary key auto_increment not null,
    id_Client int,
    typePayment enum ('Dinheiro', 'Boleto', 'Cartão', 'Pix', 'Dois cartões' ) not null,
    limiteAvaliable float,
	CardNumber bigint not null,
    NameCard varchar (20) not null,
    CardCvv char (3) not null,
    ExprireDate char(5) not null,
    Amount Decimal(10,2) not null,

    constraint fk_payment_client foreign key (id_Client) references Clients (id_Client)
);

INSERT INTO payment (id_Client, typePayment, limiteAvaliable, CardNumber, NameCard, CardCvv, ExprireDate, Amount)
VALUES
(1, 'Cartão', 5000.00, 1234567890123456, 'João Silva', '123', '12/24', 150.75),
(2, 'Boleto', 0.00,12347890123456, 'Fernando', '678', '09/10', 200.00),
(3, 'Pix', 0.00, 134567890123456, 'Fernando', '900', '06/04', 85.50),
(1, 'Dois cartões', 3000.00, 9876543210987654, 'Maria Santos', '456', '08/25', 120.00),
(2, 'Dinheiro', 0.00, 1234597890123456, 'Joaquim', '939', '04/03', 50.00);


CREATE TABLE Orders (
    id_Orders INT PRIMARY KEY AUTO_INCREMENT,                                      
    id_Orders_Clients INT NOT NULL,                                                 
    orders_Status ENUM('Cancelado', 'Confirmado', 'Em processamento') DEFAULT 'Em processamento',  
    orders_Description VARCHAR(225),                                              
    sendValue FLOAT DEFAULT 0,                                                      
    paymentCash TINYINT DEFAULT 0,                                               
    id_Payment INT,                                                                 
    CONSTRAINT fk_orders_Clients FOREIGN KEY (id_Orders_Clients) REFERENCES Clients(id_Client)

);

INSERT INTO Orders (id_Orders_Clients, orders_Status, orders_Description, sendValue, paymentCash, id_Payment)
VALUES
(1, 'Confirmado', 'Pedido de eletrônicos para João Silva', 300.00, 0, 1),
(2, 'Em processamento', 'Pedido de vestimentas para Maria Santos', 150.00, 0, 2),
(3, 'Cancelado', 'Pedido de brinquedos para Carlos Oliveira', 200.00, 1, 3),
(1, 'Confirmado', 'Pedido de móveis para João Silva', 500.00, 0, 4),
(2, 'Em processamento', 'Pedido de alimentos para Maria Santos', 100.00, 1, 5);

CREATE TABLE Delivery(
    id_Delivery INT PRIMARY KEY AUTO_INCREMENT,
    id_Order INT,
    status ENUM('Em andamento', 'Entregue', 'Pendente') DEFAULT 'Em andamento', 
    trackingCode VARCHAR(50) NOT NULL, 
    CONSTRAINT fk_delivery_order FOREIGN KEY (id_Order) REFERENCES Orders(id_Orders)
);

INSERT INTO Delivery (id_Order, status, trackingCode)
VALUES
(1, 'Em andamento', 'TRK123456'),
(2, 'Em andamento', 'TRK789012'),
(3, 'Entregue', 'TRK345678'),
(4, 'Pendente', 'TRK901234'),
(5, 'Em andamento', 'TRK567890');


drop table productStorage;
Create table productStorage(
    id_productStorage int primary key auto_increment,
    Storagelocation varchar (225),
    quantity int default 0
    
);
INSERT INTO productStorage ( Storagelocation, quantity)
VALUES
('Armazém A1', 100),
( 'Armazém B2', 200),
( 'Armazém C3', 150),
( 'Armazém D4', 50),
( 'Armazém E5', 300);


Create table Supplier(
    id_Supplier int primary key auto_increment,
    SocialName varchar (223) not null,
    CNPJ char(15) not null,
    Contact varchar (11) not null,
    
    constraint unique_Supplier unique (CNPJ)
);

INSERT INTO Supplier (SocialName, CNPJ, Contact)
VALUES
('Fornecedor ABC Ltda.', '12345678000199', '11987654321'),
('Distribuidora XYZ S.A.', '98765432000111', '11912345678'),
('Comércio de Produtos PQR', '55555555000122', '11976543210'),
('Indústria LMN Ltda.', '11122333445566', '11876543210'),
('Armazém Comercial QRS', '22233445566778', '11765432109');



drop table Seller;

Create table Seller(
    id_Seller int primary key auto_increment,
    SocialName varchar (225) not null,
    AbstractName varchar(225),
    CNPJ char(15) not null,
    CPF char(9),
    Location varchar (40),
    Contact varchar (11) not null,
    
    constraint unique_cnpj_Sellier unique (CNPJ),
	constraint unique_cpf_Sellier unique (CPF)
);

INSERT INTO Seller (SocialName, AbstractName, CNPJ, CPF, Location, Contact)
VALUES
('Vendas e Comércio LTDA', 'Vendas de eletrônicos e acessórios', '12345678000199', '123456789', 'São Paulo, SP', '11987654321'),
('Roupas e Estilo S.A.', 'Moda e vestuário', '98765432000111', '987654321', 'Rio de Janeiro, RJ', '11912345678'),
('Brinquedos e Diversão Ltda.', 'Produtos para crianças', '55555555000122', '555555555', 'Belo Horizonte, MG', '11976543210'),
('Tecnologia Avançada S.A.', 'Equipamentos de alta tecnologia', '11122333445566', '111223344', 'Porto Alegre, RS', '11876543210'),
('Comércio Geral Ltda.', 'Produtos variados', '22233445566778', '222334455', 'Curitiba, PR', '11765432109');




Create table ProductSeller(
    id_ProductSeller int,
    id_Product int,
    PQuantity int default (1),
    
    primary key (id_ProductSeller, id_Product),
    
    constraint fk_product_sellier foreign key (id_ProductSeller) references seller (id_Seller),
    constraint fk_product_product foreign key (id_Product) references product (id_Product)
);

INSERT INTO ProductSeller (id_ProductSeller, id_Product, PQuantity)
VALUES
(1, 1, 10),
(2, 2, 5),
(3, 3, 15),
(4, 4, 8),
(5, 5, 20);




Create table productOrder(
	id_productOrder int,
    id_POorder int,
    poQuantity int default (1),
    poStatus enum('Disponivel', 'Sem estoque') default 'Disponivel',
    primary key (id_productOrder, id_POorder),
    
    constraint fk_product_seller foreign key (id_productOrder) references product (Id_Product),
    constraint fk_product_producto foreign key (id_POorder) references orders (id_Orders)
);

INSERT INTO productOrder (id_productOrder, id_POorder, poQuantity, poStatus)
VALUES
(1, 1, 10, 'Disponivel'),
(2, 2, 5, 'Disponivel'),
(3, 3, 15, 'Disponivel'),
(4, 4, 8, 'Sem estoque'),
(5, 5, 20, 'Disponivel');


Create table storageLocation(
	id_Lproduct int,
    id_Lstorage int,
    location varchar(225) not null,
    primary key (id_Lproduct, id_Lstorage),
    
    constraint fk_slproduct_seller foreign key (id_Lproduct) references product(id_Product),
    constraint fk_slproduct_product foreign key (id_Lstorage) references productStorage (id_productStorage)
    
);

INSERT INTO storageLocation (id_Lproduct, id_Lstorage, location)
VALUES
(1, 1, 'Armazém A, Prateleira 1'),
(2, 2, 'Armazém B, Prateleira 2'),
(3, 3, 'Armazém C, Prateleira 3'),
(4, 4, 'Armazém A, Prateleira 4'),
(5, 5, 'Armazém B, Prateleira 5');



Create table productSupplier(
	id_Supplier int,
    id_Product int,
    quantity int not null,
    primary key(id_Supplier, id_Product),
    
    constraint fk_supplier_supplier foreign key (id_Supplier) references supplier (id_Supplier),
    constraint fk_product_supplier foreign key (id_Product) references product (id_Product)
    
	);
    
    INSERT INTO productSupplier (id_Supplier, id_Product, quantity)
VALUES
(1, 1, 100),
(2, 2, 200),
(3, 3, 150),
(1, 4, 80),
(2, 5, 250);


show tables;
use information_schema;

DESCRIBE information_schema.TABLE_CONSTRAINTS;


SELECT * FROM Clients;
SELECT * FROM Product;
SELECT * FROM Orders;

SELECT * FROM Clients WHERE ClientType = 'PF';
SELECT * FROM Orders WHERE orders_Status = 'Confirmado';
SELECT * FROM Product WHERE Category = 'Eletrônico';

SELECT id_Orders, (sendValue + paymentCash) AS totalOrderValue FROM Orders;
SELECT CONCAT(Fname, ' ', Lastname) AS fullName, ClientType FROM Clients;

SELECT * FROM Product ORDER BY Avaliacao DESC;
SELECT * FROM Orders ORDER BY sendValue DESC;

SELECT id_Supplier, SUM(quantity) AS totalQuantity
FROM productSupplier
GROUP BY id_Supplier
HAVING SUM(quantity) > 100;

SELECT id_Orders_Clients, COUNT(*) AS numberOfPayments
FROM Orders
GROUP BY id_Orders_Clients
HAVING COUNT(*) > 1;

SELECT c.Fname, c.Lastname, COUNT(o.id_Orders) AS numOrders
FROM Clients c
JOIN Orders o ON c.id_Client = o.id_Orders_Clients
GROUP BY c.id_Client;

SELECT s.SocialName AS SellerName, sp.SocialName AS SupplierName
FROM Seller s
JOIN Supplier sp ON s.CNPJ = sp.CNPJ;

SELECT p.Pname, s.SocialName AS SupplierName, ps.quantity AS StockQuantity
FROM Product p
JOIN productSupplier ps ON p.id_Product = ps.id_Product
JOIN Supplier s ON ps.id_Supplier = s.id_Supplier;

SELECT s.SocialName AS SupplierName, p.Pname AS ProductName
FROM Supplier s
JOIN productSupplier ps ON s.id_Supplier = ps.id_Supplier
JOIN Product p ON ps.id_Product = p.id_Product;
