PROBLEM STATEMENT 1
CREATE TABLE IF NOT EXISTS Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Country VARCHAR(50)
);

INSERT INTO Customers (CustomerID, CustomerName, Country) VALUES
(1, 'John Doe', 'USA'),
(2, 'Jane Smith', 'Canada'),
(3, 'Emily Jones', 'UK'),
(4, 'Chris Brown', 'USA');

CREATE TABLE IF NOT EXISTS Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2),
    Category VARCHAR(50)
);

INSERT INTO Products (ProductID, ProductName, Price, Category) VALUES
(1, 'Laptop', 1200.00, 'Electronics'),
(2, 'Smartphone', 700.00, 'Electronics'),
(3, 'Book', 15.00, 'Books'),
(4, 'Table', 150.00, 'Furniture');

CREATE TABLE IF NOT EXISTS Transactions (
    TransactionID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    TransactionDate DATE
);

INSERT INTO Transactions (TransactionID, CustomerID, ProductID, Quantity, TransactionDate) VALUES
(1, 1, 1, 1, '2023-03-15'),
(2, 2, 2, 1, '2023-03-15'),
(3, 3, 3, 2, '2023-03-16'),
(4, 4, 4, 3, '2023-03-17'),
(5, 1, 3, 1, '2023-03-18');


















Questions to Answer

1)What is the total revenue generated FROM each product category? 
 Ans. Electronics  = 1900.00
         Furniture     =    450.00
Books           =       45.00
        

SELECT 
p.category,
    SUM(p.price * t.quantity) AS total_revenue
FROM 
    products p
JOIN 
    transactions t ON  p.productid = t.productid
GROUP BY
P.category 
ORDER BY
total_revenue desc

2)Which customer made the highest number of transactions?
ANS. John Doe

SELECT 
t.customerid,
c.customername,
COUNT(t.transactionid) AS transaction_count
FROM 
    transactions t
JOIN 
    customers c ON t.customerid = c.customerid
GROUP BY 
    t.customerid, c.customername
ORDER BY 
transaction_count DESC


	
3)List products that have never been sold.
Ans.The products that were never sold are 0

	SELECT 
    p.productid,
    p.productname  
FROM 
    products p
LEFT JOIN 
    transactions t
ON 
    p.productid = t.productid
WHERE 
t.quantity <1;








4)What is the average transaction value for each country?
Ans.UK         =  30
       USA       = 555
 Canada= 700

SELECT
    c.country,
    CAST(ROUND(AVG(t.quantity * p.price)) AS INT) AS avg_transaction_value
FROM
    customers c
JOIN
    transactions t ON c.customerid = t.customerid
JOIN
    products p ON t.productid = p.productid
GROUP BY
    c.country;


5)Which product category is most popular in terms of quantity sold?
Ans.Furniture

SELECT 
    p.category,
    SUM(t.quantity) AS total_quantity_sold
FROM 
    products p
JOIN 
    transactions t ON p.productid = t.productid
GROUP BY
    p.category
ORDER BY
    total_quantity_sold DESC



6)Identify customers who have spent more than $1000 in total.
Ans. John Doe

SELECT 
    c.customerid,
    c.customername,
    SUM(t.quantity * p.price) AS spent
FROM 
    customers c
JOIN 
    transactions t ON c.customerid = t.customerid
JOIN 
    products p ON t.productid = p.productid
GROUP BY
    c.customerid, c.customername
HAVING 
SUM(t.quantity * p.price) > '1000'

7)How many transactions involved purchasing more than one item?
Ans.Two transactions bearing transactionid 3,4 involved purchasing of more than one item 

SELECT
t.transactionid,
t.quantity 
FROM 
transactions t
WHERE
quantity >1




8)What is the difference in total sales between 'Electronics' and 'Furniture' categories?
Ans. Sales difference =1450.00


SELECT
SUM(CASE WHEN p.category = 'Electronics' THEN t.quantity * p.price ELSE 0 END) AS electronics_sales,
SUM(CASE WHEN p.category = 'Furniture' THEN t.quantity * p.price ELSE 0 END) AS furniture_sales,
SUM(CASE WHEN p.category = 'Electronics' THEN t.quantity * p.price ELSE 0 END) -
SUM(CASE WHEN p.category = 'Furniture' THEN t.quantity * p.price ELSE 0 END) AS sales_difference
FROM
    transactions t
JOIN
    products p ON t.productid = p.productid;



9)Which country has the highest average spending per transaction?
Ans. Canada

SELECT
    c.country,
    CAST(ROUND(AVG(t.quantity * p.price)) as int) AS avg_spending_per_transaction
FROM
    customers c
JOIN
    transactions t ON c.customerid = t.customerid
JOIN
    products p ON t.productid = p.productid
GROUP BY
    c.country
ORDER BY
    avg_spending_per_transaction DESC
limit 1;









10)For each product, calculate the total revenue and categorize its sales volume as 'High' (more than $500), 'Medium' ($100-$500), or 'Low' (less than $100)
Ans )Laptop and Smartphone have high sales volume followed by Table with a medium volume and book with low

SELECT
    p.productname,
    SUM(t.quantity * p.price) AS total_revenue,
    CASE
        WHEN SUM(t.quantity * p.price) > 500 THEN 'High'
        WHEN SUM(t.quantity * p.price) between 100 and 500 THEN 'Medium'
        WHEN SUM(t.quantity * p.price) <100 THEN 'Low'
    END AS sales_volume
FROM
    products p
JOIN
    transactions t ON p.productid = t.productid
GROUP BY
    p.productname
ORDER BY
    total_revenue DESC;




































Problem Statement 2


--These are the sample dataset FROM sale / non sale period analysis
CREATE TABLE IF NOT EXISTS Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    OriginalPrice DECIMAL(10, 2),
    DiscountRate DECIMAL(5, 2)  -- Discount rate as a percentage, e.g., 10% discount is represented as 10.
);

INSERT INTO Products (ProductID, ProductName, OriginalPrice, DiscountRate) VALUES
(1, 'Laptop', 1200.00, 15),
(2, 'Smartphone', 700.00, 10),
(3, 'Headphones', 150.00, 5),
(4, 'E-Reader', 200.00, 20);

CREATE TABLE IF NOT EXISTS Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    QuantitySold INT,
    SaleDate DATE
);

-- Sample sales during the 10-day sale period
INSERT INTO Sales (SaleID, ProductID, QuantitySold, SaleDate) VALUES
(1, 1, 2, '2023-03-11'),
(2, 2, 3, '2023-03-12'),
(3, 3, 5, '2023-03-13'),
(4, 1, 1, '2023-03-14'),
(5, 4, 4, '2023-03-15'),
(6, 2, 2, '2023-03-16'),
(7, 3, 3, '2023-03-17'),
(8, 4, 2, '2023-03-18');

-- Additional pre-sale transactions
INSERT INTO Sales (SaleID, ProductID, QuantitySold, SaleDate) VALUES
(9, 1, 1, '2023-03-01'),
(10, 2, 2, '2023-03-02'),
(11, 3, 1, '2023-03-03'),
(12, 4, 1, '2023-03-04'),
(13, 1, 2, '2023-03-05'),
(14, 2, 1, '2023-03-06'),
(15, 3, 3, '2023-03-07'),
(16, 4, 2, '2023-03-08'),
(17, 2, 1, '2023-03-09');










Questions to Answer:

1)How much revenue was generated each day of the sale?

SELECT
    s.saledate,
    CAST(ROUND(SUM(s.quantitysold* (p.originalprice-(p.originalprice*(p.discountrate/100)))))as int) AS revenue_generated
FROM
    sales s
JOIN
    products p ON s.productid = p.productid
WHERE saledate between '2023-03-11' and '2023-03-18'
GROUP BY
    s.saledate
ORDER BY
    s.saledate;



2)Which product had the highest sales volume during the sale?
Ans. Laptop
SELECT
    p.productname,
    CAST(ROUND(SUM(s.quantitysold * 9))as int) AS total_revenue
FROM
    sales s
JOIN
    products p ON p.productid = s.productid
GROUP BY
    p.productname
ORDER BY
    total_revenue DESC;



What was the total discount given during the sale period?
Ans.2160

SELECT
    CAST(ROUND(SUM(p.originalprice * (p.discountrate / 100) * s.quantitysold))as int) AS total_discount 
FROM
    sales s
JOIN
    products p ON s.productid = p.productid;












4)How does the sale performance compare in terms of units sold before and during the sale?
Ans. FROM the table obtained we can conclude a rise in the sale performance in terms of units sold before and during sale


SELECT
    SUM(CASE WHEN s.saledate between '2023-03-01' and '2023-03-09' THEN s.quantitysold ELSE 0 END) AS units_sold_before_sale,
    SUM(CASE WHEN s.saledate BETWEEN '2023-03-11' AND '2023-03-18' THEN s.quantitysold ELSE 0 END) AS units_sold_during_sale,
    SUM(CASE WHEN s.saledate BETWEEN '2023-03-11' AND '2023-03-18' THEN s.quantitysold ELSE 0 END)  -
	SUM(CASE WHEN s.saledate between '2023-03-01' and '2023-03-09' THEN s.quantitysold ELSE 0 END) as unit_difference
FROM
    sales s;


5)What was the average discount rate applied to products sold during the sale?
Ans. Average discount rates are as follows
                   E-reader   =20
	   Smartphone =10
	   Laptop     =15
	   Headphones =5

SELECT 
p.productname,
CAST(ROUND(avg(p.discountrate))as int) as avg_discount_rate
FROM
products p
GROUP BY
p.productname



6)Which day had the highest revenue, and what was the top-selling product on that day?
Ans.2023-03-11 had the highest revenue and top-selling product was Laptop

SELECT
    s.saledate,
    CAST(ROUND(SUM((p.originalprice-(p.originalprice*(p.discountrate/100))) * s.quantitysold))as int) AS revenue_generated
FROM
    sales s
JOIN
    products p ON s.productid = p.productid
GROUP BY
    s.saledate
HAVING
s.saledate between '2023-03-11' and '2023-03-18'
ORDER BY
    revenue_generated desc
	limit 1
	





--for top selling product on 2023-03-11
SELECT
p.productname,
s.saledate,
sum(s.quantitysold) as total_unit
FROM 
sales s
JOIN 
product p on s.productid = p.productid
WHERE
s.saledate ='2023-03-11'
GROUP BY
p.productname, s.saledate


7)How many units were sold per product category during the sale? (Assuming product categories can be derived FROM product names or an additional field)
Ans.Number of units sold are as follows
                  Headphones   = 8
	  E-reader          = 6
	  Smartphone   = 5
	  Laptop             =  3
	  
SELECT 
p.productname,
sum(s.quantitysold) as totalquantity
FROM
sales s
JOIN 
product p on p.productid = s.productid
WHERE
s.saledate between '2023-03-11' and '2023-03-18'
GROUP BY
p.productname
ORDER BY
totalquantity desc



--8)What was the total number of transactions each day?
--Ans. 1


SELECT 
s.saledate,
count(s.saleid)as total_no_of_transactions
FROM
sales s
GROUP BY 
s.saledate
ORDER BY
saledate;






9)Which product had the largest discount impact on revenue?
Ans.Laptop


SELECT
    p.productname,
    CAST(ROUND(SUM(s.quantitysold * (p.originalprice - (p.originalprice * (p.discountrate/100)))))as int) AS discount_impact
FROM
    sales s
JOIN
    product p ON s.productid = p.productid
GROUP BY
    p.productname
ORDER BY
    discount_impact desc;


10)Calculate the percentage increase in sales volume during the sale compared to a similar period before the sale.
Ans. Sales volume during sale   = 8310
         Sales volume before sale  =  6630
         Increase in percentage      = 22.34%


SELECT
    CAST(ROUND(SUM(CASE WHEN s.saledate BETWEEN '2023-03-11' AND '2023-03-18' THEN s.quantitysold * (p.originalprice - (p.originalprice * (p.discountrate / 100))) ELSE 0 END)) AS INT) AS volume_sale_period,
    CAST(ROUND(SUM(CASE WHEN s.saledate BETWEEN '2023-03-01' AND '2023-03-09' THEN s.quantitysold * (p.originalprice - (p.originalprice * (p.discountrate / 100))) ELSE 0 END)) AS INT) AS volume_non_sale_period,
    ROUND(((SUM(CASE WHEN s.saledate BETWEEN '2023-03-11' AND '2023-03-18' THEN s.quantitysold * (p.originalprice - (p.originalprice * (p.discountrate / 100))) ELSE 0 END) - 
    SUM(CASE WHEN s.saledate BETWEEN '2023-03-01' AND '2023-03-09' THEN s.quantitysold * (p.originalprice - (p.originalprice * (p.discountrate / 100))) ELSE 0 END)) / 
    SUM(CASE WHEN s.saledate BETWEEN '2023-03-01' AND '2023-03-09' THEN s.quantitysold * (p.originalprice - (p.originalprice * (p.discountrate / 100))) ELSE 0 END)) * 100,2) AS percentage_increase
FROM
    sales s 
JOIN
    products p ON p.productid = s.productid;
