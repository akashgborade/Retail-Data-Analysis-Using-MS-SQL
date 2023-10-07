USE [Cellphones_Information]
SELECT * FROM Customer
SELECT * FROM Transactions
SELECT * FROM prod_cat_info

--1
SELECT TOP 1 Store_type AS Channel, COUNT(transaction_id) AS Transactions
FROM Transactions
GROUP BY Store_type 
ORDER BY Transactions DESC;

--2
SELECT Gender, COUNT(customer_Id) AS [Costomer Count]
FROM Customer
WHERE Gender IS NOT NULL
GROUP BY Gender

--3
SELECT TOP 1 city_code, COUNT(Customer_Id) AS [Costomers Count] 
FROM Customer
GROUP BY city_code
ORDER BY [Costomers Count] DESC;

--4
SELECT prod_cat AS [Poduct Category], COUNT(prod_subcat) AS [Subcategory Count]
FROM prod_cat_info
WHERE prod_cat = 'Books'
GROUP BY prod_cat;

--5
SELECT prod_cat AS [PRODUCTS] , MAX(QTY) AS MAX_QUANTITY 
FROM Transactions AS T
JOIN prod_cat_info AS P
ON T.prod_cat_code = P.prod_cat_code
GROUP BY prod_cat

--6
SELECT  SUM(total_amt) AS [Total Revenue ]
FROM Transactions AS T
 JOIN prod_cat_info AS P
ON T.prod_subcat_code = p.prod_sub_cat_code
WHERE prod_cat IN ('Electrnics' , 'Books')

--7
SELECT cust_id, COUNT(DISTINCT CASE WHEN total_amt > 0 THEN transaction_id END) AS No_of_transactions
FROM Transactions
GROUP BY cust_id
HAVING COUNT(DISTINCT CASE WHEN total_amt > 0 THEN transaction_id END) > 10;

--8
SELECT SUM(total_amt) AS [combined revenue]
FROM Transactions AS T
JOIN prod_cat_info AS P
ON T.prod_subcat_code = P.prod_sub_cat_code
WHERE prod_cat IN ('Electronics' , 'Clothing') AND Store_type LIKE 'Flagship store'

--9
SELECT prod_subcat, SUM(total_amt) AS [Total Revenue] FROM Customer AS C
JOIN Transactions AS T
ON C.customer_Id = T.cust_id
JOIN prod_cat_info AS P
ON T.prod_subcat_code = P.prod_sub_cat_code
WHERE Gender LIKE 'M' AND prod_cat LIKE 'Electronics'
GROUP BY prod_subcat

--10
SELECT TOP 5
prod_subcat, SUM(total_amt) / (SELECT SUM(total_amt) FROM Transactions) * 100 AS Sales_Percentage,
(COUNT(CASE WHEN Qty > 0 THEN Qty ELSE NULL END)/SUM(Qty)) * 100 AS Return_Percentage
FROM Transactions AS T
 JOIN prod_cat_info AS P
ON T.prod_subcat_code = P.prod_sub_cat_code AND T.prod_cat_code = P.prod_cat_code
GROUP BY prod_subcat
ORDER BY SUM(total_amt) DESC;

--11

SELECT SUM(t.total_amt) as net_total_revenue
FROM (SELECT t.*,
      MAX(t.tran_date) OVER () as max_tran_date
      FROM Transactions t
     ) t JOIN
     Customer c
     ON t.cust_id = c.customer_Id
WHERE t.tran_date >= DATEADD(day, -30, t.max_tran_date) AND 
      t.tran_date >= DATEADD(YEAR, 25, c.DOB) AND
      t.tran_date < DATEADD(YEAR, 31, c.DOB)
--12
Select Top 1 prod_cat , sum(total_amt) as total_return_amount 
From transactions as t 
 join prod_cat_info as p 
on t.prod_subcat_code=p.prod_sub_cat_code and t.prod_cat_code = p.prod_cat_code
Where t.total_amt < 0 and 
t.tran_date >= dateadd(month, -3 , '28-02-2014')
Group by p.prod_cat
Order by p.prod_cat desc ;

--13
SELECT TOP 1
Store_type, sum(total_amt) AS Sales_amount, sum(QTY) AS QUANTITY
FROM Transactions
GROUP BY Store_type
ORDER BY Sales_amount DESC, QUANTITY  DESC


--14
SELECT prod_cat, AVG(T.total_amt) AS average, T.overall_average
FROM (SELECT T.*, AVG(T.total_amt) over() AS overall_average FROM Transactions AS T) t
JOIN prod_cat_info AS P
ON T.prod_cat_code = P.prod_cat_code
GROUP BY prod_cat, overall_average
HAVING AVG(T.total_amt) > overall_average;

--15
SELECT TOP 5 
prod_subcat, AVG(total_amt) AS AVERAGE, SUM(total_amt) AS Total_revenue, SUM(QTY) AS QUANTITY
FROM Transactions AS T
JOIN prod_cat_info AS P
ON T.prod_subcat_code = P.prod_sub_cat_code
GROUP BY prod_subcat
ORDER BY SUM(QTY) DESC;