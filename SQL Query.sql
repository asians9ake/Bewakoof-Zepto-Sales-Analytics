-- =============================================================
-- Bewakoof × Zepto Sales Analytics Project
-- Database Name : bewakoof_zepto_sales
-- Platform      : SQL Server
-- Description   : End-to-end sales analysis to understand
--                 product demand, category performance,
--                 inventory risks, and revenue drivers
-- =============================================================

CREATE DATABASE bewakoof_zepto_sales;

USE bewakoof_zepto_sales;

-- -------------------------------------------------------------
-- Understanding table structure: zeptomomain
-- Purpose: Review column details for product master data
-- -------------------------------------------------------------
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'zeptomain'
ORDER BY ORDINAL_POSITION;

-- -------------------------------------------------------------
-- Understanding table structure: zeptomaysale
-- Purpose: Review column details for transactional sales data
-- -------------------------------------------------------------
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'zeptomaysale'
ORDER BY ORDINAL_POSITION;

-- -------------------------------------------------------------
-- Creating derived column for weekday analysis
-- Purpose: Extract day name from Date column to enable
--          day-wise sales trend analysis
-- -------------------------------------------------------------

--ALTER TABLE dbo.zeptomaysale
--ADD Day_Name AS DATENAME(WEEKDAY, [Date]);

-- -------------------------------------------------------------
-- Checking data availability by month
-- Purpose: Validate which months are present in the dataset
--          before proceeding with analysis
-- -------------------------------------------------------------
SELECT
    Month,
    COUNT(*) AS total_records
FROM dbo.zeptomaysale
GROUP BY Month
ORDER BY Month;

-- -------------------------------------------------------------
-- Overall sales summary for May
-- Purpose: Get a high-level view of total units sold
--          and revenue generated in May
-- -------------------------------------------------------------
SELECT
    SUM(Sales_Qty_Units) AS total_units_sold,
    SUM(Gross_Selling_Value) AS total_revenue
FROM dbo.zeptomaysale
WHERE Month = 'May';

SELECT * FROM zeptomaysale;

-- -------------------------------------------------------------
-- Top-performing products by quantity sold (May)
-- Purpose: Identify products with the highest customer demand
-- -------------------------------------------------------------
SELECT TOP 10
    PID,
    MIN(SKU_Name) AS sample_product_name,
    SUM(Sales_Qty_Units) AS total_quantity_sold
FROM dbo.zeptomaysale
WHERE Month = 'May'
GROUP BY PID
ORDER BY total_quantity_sold DESC;

-- -------------------------------------------------------------
-- Lowest-performing products by quantity sold (May)
-- Purpose: Identify slow-moving or low-demand products
-- -------------------------------------------------------------
SELECT TOP 20
    PID,
    MIN(SKU_Name) AS sample_product_name,
    SUM(Sales_Qty_Units) AS total_quantity_sold
FROM dbo.zeptomaysale
WHERE Month = 'May'
GROUP BY PID
ORDER BY total_quantity_sold ASC;

-- -------------------------------------------------------------
-- Category-level sales performance (May)
-- Purpose: Understand category contribution to overall
--          sales volume and revenue
-- -------------------------------------------------------------
SELECT
    m.Categories,
    SUM(s.Sales_Qty_Units) AS total_quantity_sold,
    SUM(s.Gross_Selling_Value) AS total_revenue
FROM dbo.zeptomaysale s
JOIN dbo.zeptomain m
    ON s.SKU_Number = m.ZEPTO_SKU_IDs
WHERE s.Month = 'May'
GROUP BY m.Categories
ORDER BY total_revenue DESC;

-- -------------------------------------------------------------
-- Product performance by Category, Tier, and Fit (May)
-- Purpose: Identify strong-performing product segments
-- -------------------------------------------------------------
SELECT TOP 10
    s.PID,
    m.Categories,
    m.Tier,
    m.Fit,
    SUM(s.Sales_Qty_Units) AS total_quantity_sold
FROM dbo.zeptomaysale s
JOIN dbo.zeptomain m
    ON s.SKU_Number = m.ZEPTO_SKU_IDs
WHERE s.Month = 'May'
GROUP BY s.PID, m.Categories, m.Tier, m.Fit
ORDER BY total_quantity_sold DESC;

-- -------------------------------------------------------------
-- Day-wise sales performance
-- Purpose: Identify which day of the week generates
--          maximum sales and revenue
-- -------------------------------------------------------------
SELECT
    Day_Name,
    SUM(Sales_Qty_Units) AS total_units_sold,
    SUM(Gross_Selling_Value) AS total_revenue
FROM dbo.zeptomaysale
GROUP BY Day_Name
ORDER BY total_revenue DESC;

-- -------------------------------------------------------------
-- Day-wise and Category-wise performance
-- Purpose: Understand category behavior across different
--          days of the week for planning promotions
-- -------------------------------------------------------------
SELECT
    s.Day_Name,
    m.Categories,
    SUM(s.Sales_Qty_Units) AS total_units_sold,
    SUM(s.Gross_Selling_Value) AS total_revenue
FROM dbo.zeptomaysale s
JOIN dbo.zeptomain m
    ON s.SKU_Number = m.ZEPTO_SKU_IDs
GROUP BY
    s.Day_Name,
    m.Categories
ORDER BY
    s.Day_Name,
    total_revenue DESC;

-- -------------------------------------------------------------
-- Best-performing category for each day
-- Purpose: Identify the highest revenue-generating
--          category on each weekday
-- -------------------------------------------------------------
WITH day_category_sales AS (
    SELECT
        s.Day_Name,
        m.Categories,
        SUM(s.Gross_Selling_Value) AS total_revenue
    FROM dbo.zeptomaysale s
    JOIN dbo.zeptomain m
        ON s.SKU_Number = m.ZEPTO_SKU_IDs
    GROUP BY
        s.Day_Name,
        m.Categories
),
ranked_categories AS (
    SELECT
        Day_Name,
        Categories,
        total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY Day_Name
            ORDER BY total_revenue DESC
        ) AS rn
    FROM day_category_sales
)
SELECT
    Day_Name,
    Categories AS highest_selling_category,
    total_revenue
FROM ranked_categories
WHERE rn = 1
ORDER BY Day_Name;

-- -------------------------------------------------------------
-- City-wise sales analysis
-- Purpose: Identify top cities contributing to sales
--          and revenue for regional strategy
-- -------------------------------------------------------------
SELECT
    City,
    SUM(Sales_Qty_Units) AS total_units_sold,
    SUM(Gross_Selling_Value) AS total_revenue
FROM dbo.zeptomaysale
GROUP BY City
ORDER BY total_revenue DESC;

-- -------------------------------------------------------------
-- High-demand but low-stock SKUs (May)
-- Purpose: Identify SKUs with potential stock-out risk
-- -------------------------------------------------------------
SELECT
    s.SKU_Number,
    s.SKU_Name,
    SUM(s.Sales_Qty_Units) AS total_quantity_sold,
    MAX(m.SOH) AS current_stock
FROM dbo.zeptomaysale s
JOIN dbo.zeptomain m
    ON s.SKU_Number = m.ZEPTO_SKU_IDs
WHERE s.Month = 'May'
GROUP BY s.SKU_Number, s.SKU_Name
HAVING MAX(m.SOH) < 10
ORDER BY total_quantity_sold DESC;

-- -------------------------------------------------------------
-- Category-level inventory risk (May)
-- Purpose: Detect categories facing low stock pressure
-- -------------------------------------------------------------
SELECT
    m.Categories,
    SUM(s.Sales_Qty_Units) AS total_quantity_sold,
    AVG(m.SOH) AS avg_stock
FROM dbo.zeptomaysale s
JOIN dbo.zeptomain m
    ON s.SKU_Number = m.ZEPTO_SKU_IDs
WHERE s.Month = 'May'
GROUP BY m.Categories
HAVING AVG(m.SOH) < 10
ORDER BY total_quantity_sold DESC;

-- -------------------------------------------------------------
-- Sales dependency on low-stock SKUs by category
-- Purpose: Measure risk exposure due to low inventory
-- -------------------------------------------------------------
SELECT
    m.Categories,
    SUM(s.Sales_Qty_Units) AS total_quantity_sold,
    COUNT(DISTINCT s.SKU_Number) AS low_stock_sku_count
FROM dbo.zeptomaysale s
JOIN dbo.zeptomain m
    ON s.SKU_Number = m.ZEPTO_SKU_IDs
WHERE s.Month = 'May'
  AND m.SOH < 10
GROUP BY m.Categories
ORDER BY total_quantity_sold DESC;

-- -------------------------------------------------------------
-- Tier-wise sales and revenue performance (May)
-- Purpose: Understand pricing-tier contribution to sales
-- -------------------------------------------------------------
SELECT
    m.Tier,
    SUM(s.Sales_Qty_Units) AS total_quantity_sold,
    SUM(s.Gross_Selling_Value) AS total_revenue
FROM dbo.zeptomaysale s
JOIN dbo.zeptomain m
    ON s.SKU_Number = m.ZEPTO_SKU_IDs
WHERE s.Month = 'May'
GROUP BY m.Tier
ORDER BY total_revenue DESC;

-- -------------------------------------------------------------
-- Tier-wise low stock risk analysis (May)
-- Purpose: Identify tiers vulnerable to stock shortages
-- -------------------------------------------------------------
SELECT
    m.Tier,
    SUM(s.Sales_Qty_Units) AS total_quantity_sold,
    COUNT(DISTINCT s.SKU_Number) AS low_stock_sku_count
FROM dbo.zeptomaysale s
JOIN dbo.zeptomain m
    ON s.SKU_Number = m.ZEPTO_SKU_IDs
WHERE s.Month = 'May'
  AND m.SOH < 10
GROUP BY m.Tier
ORDER BY total_quantity_sold DESC;

-- -------------------------------------------------------------
-- Revenue concentration from top SKUs (May)
-- Purpose: Measure dependency on top 10 revenue-generating SKUs
-- -------------------------------------------------------------
WITH sku_revenue AS (
    SELECT
        SKU_Number,
        SUM(Gross_Selling_Value) AS revenue
    FROM dbo.zeptomaysale
    WHERE Month = 'May'
    GROUP BY SKU_Number
),
ranked_sku AS (
    SELECT
        SKU_Number,
        revenue,
        ROW_NUMBER() OVER (ORDER BY revenue DESC) AS rn
    FROM sku_revenue
)
SELECT
    SUM(CASE WHEN rn <= 10 THEN revenue ELSE 0 END) AS top_10_revenue,
    SUM(revenue) AS total_revenue,
    (SUM(CASE WHEN rn <= 10 THEN revenue ELSE 0 END) * 100.0 / SUM(revenue)) AS top_10_revenue_pct
FROM ranked_sku;

-- -------------------------------------------------------------
-- Category-wise price spread analysis (May)
-- Purpose: Understand pricing range and positioning
-- -------------------------------------------------------------
SELECT
    m.Categories,
    MIN(s.ASP) AS min_asp,
    MAX(s.ASP) AS max_asp,
    AVG(s.ASP) AS avg_asp
FROM dbo.zeptomaysale s
JOIN dbo.zeptomain m
    ON s.SKU_Number = m.ZEPTO_SKU_IDs
WHERE s.Month = 'May'
GROUP BY m.Categories
ORDER BY (MAX(s.ASP) - MIN(s.ASP)) DESC;

-- -------------------------------------------------------------
-- Discount dependency analysis by category (May)
-- Purpose: Evaluate how much discounts drive sales
-- -------------------------------------------------------------
SELECT
    m.Categories,
    AVG(s.MRP - s.ASP) AS avg_discount,
    SUM(s.Sales_Qty_Units) AS total_units_sold
FROM dbo.zeptomaysale s
JOIN dbo.zeptomain m
    ON s.SKU_Number = m.ZEPTO_SKU_IDs
WHERE s.Month = 'May'
GROUP BY m.Categories
ORDER BY avg_discount DESC;

-- -------------------------------------------------------------
-- Manufacturer-wise revenue contribution (May)
-- Purpose: Identify supplier concentration risk
-- -------------------------------------------------------------
WITH manufacturer_revenue AS (
    SELECT
        Manufacturer_Name,
        SUM(Gross_Selling_Value) AS revenue
    FROM dbo.zeptomaysale
    WHERE Month = 'May'
    GROUP BY Manufacturer_Name
)
SELECT
    Manufacturer_Name,
    revenue,
    (revenue * 100.0 / SUM(revenue) OVER ()) AS revenue_pct
FROM manufacturer_revenue
ORDER BY revenue DESC;

-- -------------------------------------------------------------
-- Category-wise ASP and Gross Margin analysis (May)
-- Purpose: Replicate business-level pricing and margin view
-- -------------------------------------------------------------
WITH category_metrics AS (
    SELECT
        m.Categories,
        SUM(s.Gross_Selling_Value) AS total_revenue,
        SUM(s.Sales_Qty_Units) AS total_units,
        SUM(s.Sales_Qty_Units * m.COGS) AS total_cost
    FROM dbo.zeptomaysale s
    JOIN dbo.zeptomain m
        ON s.SKU_Number = m.ZEPTO_SKU_IDs
    WHERE s.Month = 'May'
    GROUP BY m.Categories
)

SELECT
    Categories AS row_labels,
    total_revenue AS sum_gross_selling_value,
    total_units AS sum_sales_qty_units,

    (total_revenue * 100.0 / SUM(total_revenue) OVER ()) AS revenue_pct,

    ((total_revenue - total_cost) * 100.0 / total_revenue) AS gm_pct,

    (total_revenue / NULLIF(total_units, 0)) AS asp
FROM category_metrics
ORDER BY total_revenue DESC;