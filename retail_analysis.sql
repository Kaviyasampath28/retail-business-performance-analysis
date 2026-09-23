-- Retail Business Performance & Profitability Analysis
-- SQL Analysis Queries
-- Dataset: Indian FMCG Retail Sales Customer Inventory (2024)

-- NOTE:
-- These queries use the cleaned table name RetailData.
-- Rename the table if your SQL environment uses a different table name.

-- 1. Overall Business Performance
SELECT
    SUM(Revenue) AS Total_Revenue,
    SUM(Cost) AS Total_Cost,
    SUM(Margin) AS Total_Profit,
    SUM(Units) AS Total_Units_Sold,
    ROUND(SUM(Margin) * 100.0 / NULLIF(SUM(Revenue), 0), 2) AS Profit_Margin_Percent
FROM RetailData;


-- 2. Revenue and Profit by Category
SELECT
    Category,
    SUM(Revenue) AS Total_Revenue,
    SUM(Cost) AS Total_Cost,
    SUM(Margin) AS Total_Profit,
    SUM(Units) AS Units_Sold,
    ROUND(SUM(Margin) * 100.0 / NULLIF(SUM(Revenue), 0), 2) AS Profit_Margin_Percent
FROM RetailData
GROUP BY Category
ORDER BY Total_Revenue DESC;


-- 3. Profitability by Category
SELECT
    Category,
    SUM(Revenue) AS Total_Revenue,
    SUM(Margin) AS Total_Profit,
    ROUND(SUM(Margin) * 100.0 / NULLIF(SUM(Revenue), 0), 2) AS Profit_Margin_Percent
FROM RetailData
GROUP BY Category
ORDER BY Total_Profit DESC;


-- 4. Top 5 Brands by Revenue
SELECT
    Brand,
    SUM(Revenue) AS Total_Revenue,
    SUM(Margin) AS Total_Profit,
    SUM(Units) AS Units_Sold
FROM RetailData
GROUP BY Brand
ORDER BY Total_Revenue DESC
LIMIT 5;


-- 5. Monthly Revenue and Profit Trend
SELECT
    EXTRACT(YEAR FROM Invoice_Date) AS Sales_Year,
    EXTRACT(MONTH FROM Invoice_Date) AS Sales_Month,
    SUM(Revenue) AS Total_Revenue,
    SUM(Margin) AS Total_Profit,
    SUM(Units) AS Units_Sold
FROM RetailData
GROUP BY
    EXTRACT(YEAR FROM Invoice_Date),
    EXTRACT(MONTH FROM Invoice_Date)
ORDER BY Sales_Year, Sales_Month;


-- 6. Revenue and Profit by City
SELECT
    City,
    SUM(Revenue) AS Total_Revenue,
    SUM(Margin) AS Total_Profit,
    SUM(Units) AS Units_Sold,
    ROUND(SUM(Margin) * 100.0 / NULLIF(SUM(Revenue), 0), 2) AS Profit_Margin_Percent
FROM RetailData
GROUP BY City
ORDER BY Total_Revenue DESC;


-- 7. Revenue and Profit by Sales Channel
SELECT
    Channel,
    SUM(Revenue) AS Total_Revenue,
    SUM(Margin) AS Total_Profit,
    SUM(Units) AS Units_Sold,
    ROUND(SUM(Margin) * 100.0 / NULLIF(SUM(Revenue), 0), 2) AS Profit_Margin_Percent
FROM RetailData
GROUP BY Channel
ORDER BY Total_Revenue DESC;


-- 8. Revenue and Profit by Store Format
SELECT
    Store_Format,
    SUM(Revenue) AS Total_Revenue,
    SUM(Margin) AS Total_Profit,
    SUM(Units) AS Units_Sold,
    ROUND(SUM(Margin) * 100.0 / NULLIF(SUM(Revenue), 0), 2) AS Profit_Margin_Percent
FROM RetailData
GROUP BY Store_Format
ORDER BY Total_Revenue DESC;


-- 9. Inventory Analysis by Category
SELECT
    Category,
    ROUND(AVG(Stock_On_Hand), 2) AS Average_Stock,
    ROUND(AVG(Reorder_Level), 2) AS Average_Reorder_Level,
    ROUND(AVG(Lead_Time_Days), 2) AS Average_Lead_Time_Days,
    SUM(Units) AS Units_Sold,
    SUM(Revenue) AS Total_Revenue,
    SUM(Margin) AS Total_Profit
FROM RetailData
GROUP BY Category
ORDER BY Average_Stock ASC;


-- 10. Low-Stock Records
SELECT
    Invoice_ID,
    Invoice_Date,
    City,
    Store_Format,
    Category,
    Brand,
    Stock_On_Hand,
    Reorder_Level,
    Lead_Time_Days
FROM RetailData
WHERE Stock_On_Hand <= Reorder_Level
ORDER BY Stock_On_Hand ASC;


-- 11. Low-Stock Summary by Category
SELECT
    Category,
    COUNT(*) AS Low_Stock_Records,
    ROUND(AVG(Stock_On_Hand), 2) AS Average_Stock,
    ROUND(AVG(Reorder_Level), 2) AS Average_Reorder_Level
FROM RetailData
WHERE Stock_On_Hand <= Reorder_Level
GROUP BY Category
ORDER BY Low_Stock_Records DESC;


-- 12. Revenue by Payment Mode
SELECT
    Payment_Mode,
    SUM(Revenue) AS Total_Revenue,
    SUM(Margin) AS Total_Profit,
    SUM(Units) AS Units_Sold
FROM RetailData
GROUP BY Payment_Mode
ORDER BY Total_Revenue DESC;


-- 13. Customer Gender Analysis
SELECT
    Customer_Gender,
    COUNT(*) AS Transactions,
    SUM(Revenue) AS Total_Revenue,
    SUM(Margin) AS Total_Profit,
    SUM(Units) AS Units_Sold
FROM RetailData
GROUP BY Customer_Gender
ORDER BY Total_Revenue DESC;


-- 14. Loyalty Flag Analysis
SELECT
    Loyalty_Flag,
    COUNT(*) AS Transactions,
    SUM(Revenue) AS Total_Revenue,
    SUM(Margin) AS Total_Profit,
    SUM(Units) AS Units_Sold
FROM RetailData
GROUP BY Loyalty_Flag
ORDER BY Total_Revenue DESC;


-- 15. Category-Level Stock and Profit Relationship
SELECT
    Category,
    ROUND(AVG(Stock_On_Hand), 2) AS Average_Stock,
    ROUND(AVG(Reorder_Level), 2) AS Average_Reorder_Level,
    ROUND(AVG(Lead_Time_Days), 2) AS Average_Lead_Time_Days,
    SUM(Margin) AS Total_Profit,
    SUM(Units) AS Units_Sold
FROM RetailData
GROUP BY Category
ORDER BY Total_Profit DESC;


-- 16. Overall Inventory Risk Summary
SELECT
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN Stock_On_Hand <= Reorder_Level THEN 1 ELSE 0 END)
        AS Low_Stock_Records,
    ROUND(
        SUM(CASE WHEN Stock_On_Hand <= Reorder_Level THEN 1 ELSE 0 END)
        * 100.0 / NULLIF(COUNT(*), 0), 2
    ) AS Low_Stock_Percentage
FROM RetailData;


-- 17. Highest-Revenue Products (Brand + Category)
SELECT
    Category,
    Brand,
    SUM(Revenue) AS Total_Revenue,
    SUM(Margin) AS Total_Profit,
    SUM(Units) AS Units_Sold
FROM RetailData
GROUP BY Category, Brand
ORDER BY Total_Revenue DESC
LIMIT 10;


-- 18. Profit Contribution by Category
SELECT
    Category,
    SUM(Margin) AS Total_Profit,
    ROUND(
        SUM(Margin) * 100.0 /
        NULLIF((SELECT SUM(Margin) FROM RetailData), 0), 2
    ) AS Profit_Contribution_Percent
FROM RetailData
GROUP BY Category
ORDER BY Total_Profit DESC;


-- 19. Revenue by Customer Age Group
SELECT
    CASE
        WHEN Customer_Age < 25 THEN '18-24'
        WHEN Customer_Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Customer_Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Customer_Age BETWEEN 45 AND 54 THEN '45-54'
        WHEN Customer_Age >= 55 THEN '55+'
        ELSE 'Unknown'
    END AS Age_Group,
    SUM(Revenue) AS Total_Revenue,
    SUM(Margin) AS Total_Profit,
    SUM(Units) AS Units_Sold
FROM RetailData
GROUP BY
    CASE
        WHEN Customer_Age < 25 THEN '18-24'
        WHEN Customer_Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Customer_Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Customer_Age BETWEEN 45 AND 54 THEN '45-54'
        WHEN Customer_Age >= 55 THEN '55+'
        ELSE 'Unknown'
    END
ORDER BY Total_Revenue DESC;


-- 20. Final Category Performance Summary
SELECT
    Category,
    SUM(Revenue) AS Revenue,
    SUM(Cost) AS Cost,
    SUM(Margin) AS Profit,
    SUM(Units) AS Units_Sold,
    ROUND(SUM(Margin) * 100.0 / NULLIF(SUM(Revenue), 0), 2) AS Profit_Margin_Percent,
    ROUND(AVG(Stock_On_Hand), 2) AS Avg_Stock,
    ROUND(AVG(Reorder_Level), 2) AS Avg_Reorder_Level,
    ROUND(AVG(Lead_Time_Days), 2) AS Avg_Lead_Time_Days
FROM RetailData
GROUP BY Category
ORDER BY Profit DESC;
