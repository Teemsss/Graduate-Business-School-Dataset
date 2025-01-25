-- Data Retrieval and Filtering:
-- Write a query to retrieve all orders shipped to the state of "California" that used "Second Class" shipping mode. Include `Order ID`, `Customer Name`, `Sales`, and `Profit`
SELECT Order_ID, Customer_Name, Sales, Profit
FROM superstore_project_3
WHERE State = 'California' AND Ship_Mode = 'Second Class';

-- Find all orders placed between "2013-01-01" and "2013-12-31" where the `Category` is "Furniture" and the `Profit` is greater than 100. Display the `Order ID`, `Order Date`, `Product Name`, and `Profit`
SELECT Order_ID, Order_Date, Product_Name, Profit
FROM superstore_project_3
WHERE Category = 'Furniture' AND Profit > 100 AND Order_Date BETWEEN '2013-01-01' AND '2013-12-31';

-- Write a query to list all unique `Ship Modes` and the number of orders shipped through each mode, sorted in descending order of order count
SELECT Ship_Mode, COUNT(Order_ID) AS Order_Count
FROM superstore_project_3
GROUP BY Ship_Mode
ORDER BY Order_Count DESC;

-- Aggregations and Grouping:
-- Calculate the total `Sales` and `Profit` for each `Category` and `Sub-Category`. Display the results in descending order of total `Sales`
SELECT Category, Sub_Category, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM superstore_project_3
GROUP BY Category, Sub_Category
ORDER BY Total_Sales DESC;

-- Find the top 3 customers in terms of total `Sales` in each `Region`. Display `Customer Name`, `Region`, and `Total Sales`
SELECT Customer_Name, Region, Total_Sales 
FROM (SELECT Customer_Name, Region, SUM(Sales) AS Total_Sales, ROW_NUMBER()OVER(PARTITION BY Region ORDER BY SUM(Sales) DESC) AS Sales_Rank
FROM superstore_project_3
GROUP BY Customer_Name, Region) Ranked_Sales
WHERE Sales_Rank <= 3;

-- Write a query to determine which `City` has the highest average `Profit` per order, and display the top 5 cities with the highest average
SELECT City, AVG(Profit) AS Avg_Profit_Per_Order
FROM superstore_project_3
GROUP BY City
ORDER BY Avg_Profit_Per_Order DESC
LIMIT 5;

-- Joins and Subqueries:
-- Write a query to find the `Product Name` and `Category` of the most frequently ordered product (the one with the highest total `Quantity`)
SELECT Product_Name, Category
FROM superstore_project_3
GROUP BY Product_Name, Category
ORDER BY SUM(Quantity) DESC
LIMIT 1;

-- Use a subquery to find all orders where the `Sales` amount is greater than the average `Sales` for that specific `Category`
SELECT *
FROM superstore_project_3
WHERE Sales > (SELECT AVG(sales)
FROM superstore_project_3 
WHERE Category = Category
);

-- Write a query to find customers who have placed orders in both the "Corporate" and "Consumer" segments. Display their `Customer ID` and `Customer Name`
SELECT Customer_ID, Customer_Name 
FROM superstore_project_3 
WHERE Segment = "Corporate" AND Customer_ID IN (SELECT Customer_ID FROM superstore_project_3 WHERE Segment = "Consumer")
GROUP BY Customer_ID, Customer_Name;

-- Data Updates:
-- Update the `Ship Mode` of all orders shipped in "Kentucky" with a `Discount` of 0 to "Standard Class"
UPDATE superstore_project_3 
SET Ship_Mode = "Standard Class"
WHERE State = "Kentucky" AND `Discount` = 0;

-- Write a query to adjust the `Discount` to 0.3 for all products in the "Office Supplies" category that have a `Profit` less than zero
UPDATE superstore_project_3 
SET Discount = 0.3
WHERE Category = 'Office Supplies';

-- Write a query to increase the `Quantity` by 1 for all orders that have `Sales` greater than 500 but have a `Quantity` of 2 or less
UPDATE superstore_project_3 
SET Quantity = Quantity + 1
WHERE Sales > 500 AND Quantity <= 2;
SELECT ROW_COUNT();


-- Complex Conditions:
-- Find orders where the `Profit` is negative, but the `Sales` amount is above the average `Sales` of all orders. Display `Order ID`, `Customer Name`, `Sales`, and `Profit`
SELECT Order_ID, Customer_Name, Sales, Profit
FROM superstore_project_3 
WHERE Profit < 0 AND Sales > (SELECT AVG(Sales) FROM superstore_project_3 );

-- Write a query to calculate the `Profit` margin (as `Profit/Sales`) for each `Product ID` and find the top 5 products with the highest profit margin
SELECT Product_ID, (Profit/Sales) AS Profit_Margin
FROM superstore_project_3 
ORDER BY Profit_Margin DESC
LIMIT 5;

-- Write a query to find all `Order IDs` where the `Ship Date` is more than 5 days after the `Order Date`. Display `Order ID`, `Order Date`, `Ship Date`, and the `days difference`
SELECT Order_ID, Order_Date, Ship_Date, DATEDIFF(Ship_Date, Order_Date) AS Days_Difference
FROM superstore_project_3 
WHERE DATEDIFF(Ship_Date, Order_Date) > 5;

-- Bonus Challenge:
-- Write a query to find the total `Sales` and `Profit` contribution for each `Segment` by year. Display the results with `Year`, `Segment`, `Total Sales`, and `Total Profit`
SELECT YEAR(Order_Date) AS Year, Segment, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit
FROM superstore_project_3
GROUP BY YEAR(Order_Date), Segment;

-- Identify the `Sub-Category` with the most orders where `Discount` was applied. Display the `Sub_Category`, the total number of such orders, and the average `Discount` given in those case
SELECT Sub_Category, COUNT(Order_ID) AS Total_Orders, AVG(Discount) AS Average_Discount
FROM superstore_project_3
WHERE Discount > 0
GROUP BY Sub_Category
ORDER BY Total_Orders DESC
LIMIT 1;