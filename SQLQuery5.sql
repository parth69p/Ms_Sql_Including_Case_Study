create database inventorydb;
use inventorydb;
-- Categories Table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50)
);

-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID),
    Price DECIMAL(10,2),
    StockQuantity INT
);

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15)
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderDate DATE,
    TotalAmount DECIMAL(10,2)
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    UnitPrice DECIMAL(10,2)
);

select * from Categories;
Select * from Products;
select * from Customers;
select * from orders;
select * from OrderDetails;


-- inserting into catagories
INSERT INTO Categories (CategoryID, CategoryName) VALUES
(1, 'Laptops'),
(2, 'Smartphones'),
(3, 'Tablets'),
(4, 'Accessories');

--inserting into products
INSERT INTO Products (ProductID, ProductName, CategoryID, Price, StockQuantity) VALUES
(101, 'Dell XPS 13', 1, 999.99, 25),
(102, 'iPhone 14', 2, 1099.00, 15),
(103, 'Samsung Galaxy Tab S8', 3, 699.50, 8),
(104, 'Wireless Mouse', 4, 29.99, 50),
(105, 'USB-C Hub', 4, 45.00, 6);

-- inserting into customers
INSERT INTO Customers (CustomerID, CustomerName, Email, Phone) VALUES
(201, 'Aman Verma', 'aman@example.com', '9876543210'),
(202, 'Sneha Sharma', 'sneha@example.com', '9876501234'),
(203, 'Ravi Kapoor', 'ravi@example.com', '9988776655');


--insert into orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
(301, 201, '2025-07-01', 1129.99),
(302, 202, '2025-07-02', 1370.00),
(303, 203, '2025-07-03', 699.50);

-- insert into Order details

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice) VALUES
(401, 301, 101, 1, 999.99),
(402, 301, 104, 1, 29.99),
(403, 302, 102, 1, 1099.00),
(404, 302, 105, 2, 45.00),
(405, 303, 103, 1, 699.50);


SELECT * FROM OrderDetails

--As a Sales Manager, I want to view total sales per product category to analyze performance.
SELECT c.CategoryName,SUM(od.Quantity * od.UnitPrice) AS ToalSales
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
JOIN Categories c on p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY ToalSales DESC;--Using DESC to sort the results from highest to lowest.


-- As a Warehouse Supervisor, I need to check low-stock items to initiate restocking.

alter PROCEDURE GetLowStockItems
AS
BEGIN
    SELECT 
        ProductID, ProductName, StockQuantity
    FROM 
        Products
    WHERE 
        StockQuantity < 100;
END;

execute GetlowStockItems;

--As a Customer Support Agent, I need to fetch order details with customer information for issue resolution.
alter PROCEDURE GetOrderDetailsWithCustomer
    @OrderID INT
AS
BEGIN
Select o.orderid, o.orderdate, c.customerName, c.Email, od.Quantity, od.Unitprice from Orders o
join Customers c on c.CustomerId= o.customerId
join OrderDetails od on od.OrderId = o.OrderId
where o.orderid= @OrderID;
end;

execute GetorderDetailsWithCustomer 303;


-- As a Database Administrator, I need to ensure atomicity when updating stock levels during bulk orders.


-- Procedure to Handle Bulk Stock Update (Atomic)
CREATE PROCEDURE BulkUpdateStock
    @ProductID INT,
    @Quantity INT
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Products WHERE ProductID = @ProductID)
        BEGIN
            UPDATE Products
            SET StockQuantity = StockQuantity - @Quantity
            WHERE ProductID = @ProductID;

            COMMIT;
        END
        ELSE
        BEGIN
            RAISERROR('Product not found.', 16, 1);
            ROLLBACK;
        END
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
