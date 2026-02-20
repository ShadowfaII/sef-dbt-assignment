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


## 🛠 Transformations Applied & Why

I followed a **Medallion Architecture** (Staging -> Marts) to ensure the code is modular, readable, and maintainable.

### **A. Staging Layer (`stg_`)**
* **Goal:** Clean and cast raw data.
* **Logic:** I renamed columns for consistency and cast string dates into `DATE` formats. This ensures that downstream models don't encounter data-type errors.

### **B. Core Logic (`fct_orders`)**
* **Goal:** Create a "One Big Table" (OBT) for orders.
* **Logic:** I joined `orders`, `users`, and `payments` on `order_id` and `user_id`. This centralizes all details—including city geography and payment status—into a single source of truth for all reporting.

### **C. Analytics Marts (`mart_`)**
* **Goal:** Deliver business-ready reporting.
* **The "City Revenue" Logic:** * Used `UNION ALL` to create a formatted financial report.
    * **Bifurcation:** I separated "Completed" vs. "Refunded" orders to show actual Revenue vs. Lost Revenue.
    * **Grand Totals:** I added a calculated row for **"GRAND TOTAL"** to provide an "executive-ready" summary directly in the data output.


## **Key Assumptions**

* Revenue Source of Truth: I assumed the amount column in the orders table represents the transaction value. In a production environment, I would cross-verify this with the payments table.

* Status Filtering: I assumed that only orders with order_status = 'completed' should count toward active business revenue.

* Local Persistence: I utilized DuckDB (dev.duckdb) for local storage, assuming the user wants to run the project without needing a cloud warehouse like BigQuery or Snowflake.

* Data Integrity: I assumed order_id is the unique primary key for the entire pipeline, as validated by my dbt tests.


## 🧩 Challenges & Learnings

* **Complex SQL Logic in dbt:** The biggest challenge was implementing the "Grand Total" and "Lost Revenue" rows within the `mart_city_revenue` model. Ensuring that the `UNION ALL` matched the data types and column order exactly required careful CTE management.

* **dbt Configuration:** Handling the `+` prefix deprecation in `dbt_project.yml` was a great learning point regarding versioning and keeping up with dbt best practices.

* **DuckDB Integration:** Learning how to interact with a local `dev.duckdb` via the CLI for manual exports was a new but highly efficient workflow.


## 📈 Future Improvements (Given More Time)

* **Robust Data Testing:** I would implement more advanced tests (like `dbt_expectations`) to validate that revenue never goes negative and that city names are formatted correctly.

* **CI/CD Pipeline:** I would set up a GitHub Action to automatically run `dbt test` every time code is pushed to ensure no breaking changes reach the repository.

* **Visualization:** I would connect this DuckDB instance to a BI tool like Evidence or Streamlit to create a live dashboard for the stakeholders.


## ⏱️ Approximate Time Spent
* **Total Time:** ~7–9 hours
* **Breakdown:** 
    * 2 hours: Environment setup and dbt initialization.
    * 4 hours: Developing staging and mart models.
    * 2 hours: Logic refinement for financial reporting and grand totals.
    * 1 hour: Documentation, testing, and GitHub finalization.


Author: Kartik Kamra

Tools: dbt-core, DuckDB, Python, SQL