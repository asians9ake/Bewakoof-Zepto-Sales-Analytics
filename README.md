[bewakoof_zepto_sales_analytics_readme.md](https://github.com/user-attachments/files/25529911/bewakoof_zepto_sales_analytics_readme.md)
# Bewakoof × Zepto Sales Analytics Project

## 📌 Project Overview
This project focuses on analyzing **Bewakoof product sales on the Zepto platform** using **SQL Server**. The objective is to derive **business insights** related to sales performance, customer demand, inventory risk, pricing strategy, and revenue concentration.

The analysis is entirely SQL-driven and is designed to simulate **real-world retail and e-commerce analytics use cases** such as category performance tracking, stock-out risk identification, and city-wise demand analysis.

---

## 🎯 Business Objectives
- Understand **overall sales performance** for the month of May
- Identify **top and bottom performing products (PIDs & SKUs)**
- Analyze **category, tier, and fit-wise demand trends**
- Evaluate **day-wise and city-wise sales behavior**
- Detect **high-demand but low-stock inventory risks**
- Assess **pricing spread, discount dependency, and margins**
- Measure **revenue concentration across SKUs and manufacturers**

---

## 🗄️ Database Details
- **Database Name:** `bewakoof_zepto_sales`
- **Tool Used:** SQL Server
- **Schema:** dbo

---

## 📂 Tables Used

### 1️⃣ `zeptomain` (Product Master Table)
Contains static product and inventory-related information.

**Key Columns:**
- `ZEPTO_SKU_IDs` – SKU identifier
- `PID`, `PSID` – Product identifiers
- `Categories`, `Tier`, `Fit`
- `Designer_name`
- `SOH` – Stock on hand
- `COGS` – Cost of goods sold
- `ZEPTO_MRP`

---

### 2️⃣ `zeptomaysale` (Sales Transaction Table)
Contains daily sales transactions for May.

**Key Columns:**
- `Date`, `Day_Name`, `Month`
- `SKU_Number`, `SKU_Name`, `PID`
- `Categories`, `Tier`, `Fit`
- `City`
- `Sales_Qty_Units`
- `ASP`, `MRP`
- `Gross_Selling_Value`
- `COGS`, `COGS_Gross`

---

## 🔎 Key Analyses Performed

### 📊 Overall Sales Performance (May)
- Total units sold and total revenue
- Revenue contribution by category

### 🏆 Product Performance
- Top & bottom products by quantity sold
- Best-performing PIDs by Category, Tier, and Fit
- Revenue dependency on top 10 SKUs

### 📅 Time-Based Analysis
- Day-wise sales and revenue trends
- Highest-selling category for each day

### 🌆 Location-Based Analysis
- City-wise sales volume and revenue contribution

### 📦 Inventory Risk Analysis
- High-demand but low-stock SKUs
- Category-wise and tier-wise stock pressure
- Sales dependency on low-stock items

### 💰 Pricing & Margin Analysis
- Category-wise ASP (Average Selling Price)
- Pricing spread within categories
- Discount dependency by category
- Gross Margin (%) analysis using COGS

### 🏭 Supplier Analysis
- Manufacturer-wise revenue contribution
- Identification of supplier concentration risk

---

## 📈 Sample Insights Generated
- **Men’s T-shirt (Regular & Oversize)** categories contribute the highest share of revenue
- **Saturday and Friday** are the strongest sales days
- **Mumbai and Delhi** are the top revenue-generating cities
- **HERO tier products** dominate both quantity and revenue
- Certain high-demand categories show **low stock availability**, indicating stock-out risk
- A small set of SKUs contributes a significant percentage of total revenue

---

## 📸 Project Screenshots & Query Outputs

### 1️⃣ Category-wise Revenue, Units, GM% and ASP
*Shows revenue contribution, gross margin percentage, and pricing insights across categories.*

![Category Metrics](screenshots/category_metrics.png)

---

### 2️⃣ Table Structure – Product Master (`zeptomain`)
*Defines SKU-level attributes such as category, tier, fit, stock, and cost.*

![Zepto Main Table Structure](screenshots/zeptomain_structure.png)

---

### 3️⃣ Table Structure – Sales Transactions (`zeptomaysale`)
*Contains daily transactional sales data used for all analysis.*

![Zepto May Sale Structure](screenshots/zeptomaysale_structure.png)

---

### 4️⃣ Top Performing Products by Category, Tier & Fit
*Highlights best-selling PIDs based on quantity sold.*

![Top PIDs](screenshots/top_pid_performance.png)

---

### 5️⃣ Day-wise Sales Performance
*Identifies the most profitable days based on revenue and units sold.*

![Day Wise Sales](screenshots/day_wise_sales.png)

---

### 6️⃣ City-wise Revenue Contribution
*Shows regional demand concentration across major cities.*

![City Wise Sales](screenshots/city_wise_sales.png)

---

### 7️⃣ Low Stock Risk by Category
*Categories contributing significant sales despite low stock availability.*

![Low Stock Category Risk](screenshots/low_stock_category.png)

---

### 8️⃣ Tier-wise Sales & Revenue Distribution
*Demonstrates how different pricing tiers perform in terms of demand and revenue.*

![Tier Wise Performance](screenshots/tier_wise_sales.png)

---

## 🛠️ SQL Concepts Used
- Joins (INNER JOIN)
- Aggregations (`SUM`, `AVG`, `COUNT`, `MIN`, `MAX`)
- Window functions (`ROW_NUMBER`, `OVER`, `PARTITION BY`)
- CTEs (Common Table Expressions)
- Conditional aggregation
- Derived columns (`Day_Name`)

---

## 🚀 How to Use This Project
1. Create the database using the provided SQL script
2. Load `zeptomain` and `zeptomaysale` tables
3. Execute queries sequentially to explore insights
4. Use outputs for reporting, dashboards, or case studies

---

## 📄 Use Cases
- Portfolio project for **Data Analyst / Business Analyst roles**
- SQL case study for interviews
- Practice project for retail & e-commerce analytics

---

## ✍️ Author
**Ashutosh Singhania**  
Final Year Student | Aspiring Data Analyst  
Skills: SQL, Data Analysis, Business Insights

---

## 📌 Note
This project is built for **learning and demonstration purposes** using structured SQL analysis. The data represents a simulated business scenario inspired by real-world retail operations.

