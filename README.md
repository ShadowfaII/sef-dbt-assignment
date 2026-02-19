# SEF dbt Analytics Assignment

This project transforms raw e-commerce data (Orders, Users, and Payments) into production-ready analytics marts. It utilizes **dbt (data build tool)** with a **DuckDB** adapter to demonstrate a modern, local-first data engineering workflow.

---

## 🚀 Setup and Execution

To replicate this environment and run the pipeline locally:

### **Prerequisites**
* Python 3.9 or higher
* A terminal (Zsh/Bash) on macOS/Linux/Windows
* Git installed


### **Step-by-Step Run**

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/ShadowfaII/sef-dbt-assignment.git
    cd sef-dbt-assignment
    ```

2.  **Setup virtual environment**
    ```bash
    python3 -m venv dbt-env # Creates a virtual environment 'dbt-env'
    source dbt-env/bin/activate # Activates the virtual environment 'dbt-env'
    ```

3.  **Install Dependencies**
    ```bash
    pip install dbt-duckdb 
    ```

4.  **Execute the Pipeline**
    ```bash
    dbt seed  # Loads raw CSV data into DuckDB
    dbt run   # Executes all staging and mart transformations
    dbt test  # Validates data integrity (Unique/Not Null)
    ```

5.  **View Results**
    ```bash
    dbt show --select fct_orders # Shows main orders table in terminal
    dbt show --select mart_user_stats # Shows stats by user 
    dbt show --select mart_city_revenue # Shows revenue by each city
    ```

6.  **Export Results as .csv**
    ```bash
    duckdb dev.duckdb -c "COPY (SELECT * FROM fct_orders) TO 'export/fct_orders.csv' (HEADER);"
    duckdb dev.duckdb -c "COPY (SELECT * FROM mart_user_stats) TO 'export/user_stats.csv' (HEADER);"
    duckdb dev.duckdb -c "COPY (SELECT * FROM mart_city_revenue) TO 'export/city_revenue_report.csv' (HEADER);"
    ```


## ** Transformations Applied & Why **

I followed a Medallion Architecture (Staging -> Marts) to ensure the code is modular and maintainable.

A. Staging Layer (stg_)
    Goal: Clean and cast raw data.
    Logic: Renamed columns for consistency and cast string dates into DATE formats. This ensures that downstream models don't have to worry about data types.

B. Core Logic (fct_orders)
    Goal: Create a "One Big Table" for orders.
    Logic: Joined orders, users, and payments on order_id and user_id. This centralizes all order details, including geography (city) and payment status, into a single source of truth.

C. Analytics Marts (mart_)
    Goal: Deliver business-ready reporting.
    Transformations: * City Revenue Mart: Used UNION ALL logic to create a formatted financial report.
        Bifurcation: I separated "Completed" vs. "Refunded" orders to show actual Revenue vs. Lost Revenue.
        Grand Totals: Added a calculated 5th row specifically for "GRAND TOTAL" and "LOST REVENUE" to make the export ready for stakeholders.


## **Key Assumptions**

* Revenue Source of Truth: I assumed the amount column in the orders table represents the transaction value. In a production environment, I would cross-verify this with the payments table.

* Status Filtering: I assumed that only orders with order_status = 'completed' should count toward active business revenue.

* Local Persistence: I utilized DuckDB (dev.duckdb) for local storage, assuming the user wants to run the project without needing a cloud warehouse like BigQuery or Snowflake.

* Data Integrity: I assumed order_id is the unique primary key for the entire pipeline, as validated by my dbt tests.


Author: Kartik Kamra

Tools: dbt-core, DuckDB, Python, SQL