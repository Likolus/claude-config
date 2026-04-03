---
name: deerflow:data-analysis
description: Analyze Excel/CSV files using SQL queries. Use when user uploads data files and wants statistics, summaries, pivot tables, filtering, aggregation, or structured data exploration. Supports multi-sheet Excel workbooks and exports to CSV/JSON/Markdown.
---

# Data Analysis Skill (from DeerFlow)

**Ported from DeerFlow to Claude Code**

This skill analyzes user-uploaded Excel/CSV files using DuckDB — an in-process analytical SQL engine. It supports schema inspection, SQL-based querying, statistical summaries, and result export.

## Core Capabilities

- Inspect Excel/CSV file structure (sheets, columns, types, row counts)
- Execute arbitrary SQL queries against uploaded data
- Generate statistical summaries (mean, median, stddev, percentiles, nulls)
- Support multi-sheet Excel workbooks (each sheet becomes a table)
- Export query results to CSV, JSON, or Markdown
- Handle large files efficiently with DuckDB's columnar engine

## Prerequisites

**Install DuckDB:**

```bash
pip install duckdb openpyxl pandas
```

## Workflow

### Step 1: Understand Requirements

When a user uploads data files and requests analysis, identify:

- **File location**: Path(s) to uploaded Excel/CSV files
- **Analysis goal**: What insights the user wants (summary, filtering, aggregation, comparison, etc.)
- **Output format**: How results should be presented (table, CSV export, JSON, etc.)

### Step 2: Create Analysis Script

Create a Python script that uses DuckDB to analyze the data:

```python
import duckdb
import sys
import json
from pathlib import Path

def inspect_file(file_path):
    """Inspect file structure and return schema info"""
    conn = duckdb.connect(':memory:')

    if file_path.endswith('.csv'):
        conn.execute(f"CREATE TABLE data AS SELECT * FROM read_csv_auto('{file_path}')")
        tables = [('data', file_path)]
    else:  # Excel
        # Load all sheets
        import pandas as pd
        excel_file = pd.ExcelFile(file_path)
        tables = []
        for sheet_name in excel_file.sheet_names:
            safe_name = sheet_name.replace(' ', '_')
            conn.execute(f"CREATE TABLE {safe_name} AS SELECT * FROM read_excel('{file_path}', sheet_name='{sheet_name}')")
            tables.append((safe_name, sheet_name))

    # Get schema for each table
    results = {}
    for table_name, original_name in tables:
        schema = conn.execute(f"DESCRIBE {table_name}").fetchall()
        sample = conn.execute(f"SELECT * FROM {table_name} LIMIT 5").fetchall()
        row_count = conn.execute(f"SELECT COUNT(*) FROM {table_name}").fetchone()[0]

        results[original_name] = {
            'table_name': table_name,
            'columns': schema,
            'row_count': row_count,
            'sample': sample
        }

    return results

def run_query(file_paths, sql_query):
    """Execute SQL query against file(s)"""
    conn = duckdb.connect(':memory:')

    # Load all files
    for file_path in file_paths:
        if file_path.endswith('.csv'):
            table_name = Path(file_path).stem
            conn.execute(f"CREATE TABLE {table_name} AS SELECT * FROM read_csv_auto('{file_path}')")
        else:  # Excel
            import pandas as pd
            excel_file = pd.ExcelFile(file_path)
            for sheet_name in excel_file.sheet_names:
                safe_name = sheet_name.replace(' ', '_')
                conn.execute(f"CREATE TABLE {safe_name} AS SELECT * FROM read_excel('{file_path}', sheet_name='{sheet_name}')")

    # Execute query
    result = conn.execute(sql_query).fetchall()
    columns = [desc[0] for desc in conn.description]

    return {'columns': columns, 'data': result}

def generate_summary(file_path, table_name):
    """Generate statistical summary for a table"""
    conn = duckdb.connect(':memory:')

    if file_path.endswith('.csv'):
        conn.execute(f"CREATE TABLE {table_name} AS SELECT * FROM read_csv_auto('{file_path}')")
    else:
        conn.execute(f"CREATE TABLE {table_name} AS SELECT * FROM read_excel('{file_path}', sheet_name='{table_name}')")

    # Get summary statistics
    summary = conn.execute(f"SUMMARIZE {table_name}").fetchall()
    return summary
```

### Step 3: Run Analysis

Execute the script with appropriate parameters:

```bash
# Inspect file structure
python analyze.py inspect data.xlsx

# Run SQL query
python analyze.py query data.xlsx "SELECT category, COUNT(*) as count FROM Sheet1 GROUP BY category"

# Generate summary statistics
python analyze.py summary data.xlsx Sheet1

# Export results
python analyze.py query data.xlsx "SELECT * FROM Sheet1 WHERE amount > 1000" --output results.csv
```

## Table Naming Rules

- **Excel files**: Each sheet becomes a table named after the sheet (e.g., `Sheet1`, `Sales`, `Revenue`)
- **CSV files**: Table name is the filename without extension (e.g., `data.csv` → `data`)
- **Multiple files**: All tables from all files are available in the same query context, enabling cross-file joins
- **Special characters**: Sheet/file names with spaces are auto-sanitized (spaces → underscores)

## Analysis Patterns

### Basic Exploration

```sql
-- Row count
SELECT COUNT(*) FROM Sheet1

-- Distinct values in a column
SELECT DISTINCT category FROM Sheet1

-- Value distribution
SELECT category, COUNT(*) as cnt FROM Sheet1 GROUP BY category ORDER BY cnt DESC

-- Date range
SELECT MIN(date_col), MAX(date_col) FROM Sheet1
```

### Aggregation & Grouping

```sql
-- Revenue by category and month
SELECT category, DATE_TRUNC('month', order_date) as month,
       SUM(revenue) as total_revenue
FROM Sales
GROUP BY category, month
ORDER BY month, total_revenue DESC

-- Top 10 customers by spend
SELECT customer_name, SUM(amount) as total_spend
FROM Orders GROUP BY customer_name
ORDER BY total_spend DESC LIMIT 10
```

### Cross-file Joins

```sql
-- Join sales with customer info from different files
SELECT s.order_id, s.amount, c.customer_name, c.region
FROM sales s
JOIN customers c ON s.customer_id = c.id
WHERE s.amount > 500
```

### Window Functions

```sql
-- Running total and rank
SELECT order_date, amount,
       SUM(amount) OVER (ORDER BY order_date) as running_total,
       RANK() OVER (ORDER BY amount DESC) as amount_rank
FROM Sales
```

### Pivot-style Analysis

```sql
-- Pivot: monthly revenue by category
SELECT category,
       SUM(CASE WHEN MONTH(date) = 1 THEN revenue END) as Jan,
       SUM(CASE WHEN MONTH(date) = 2 THEN revenue END) as Feb,
       SUM(CASE WHEN MONTH(date) = 3 THEN revenue END) as Mar
FROM Sales
GROUP BY category
```

## Complete Example

User uploads `sales_2024.xlsx` (with sheets: `Orders`, `Products`, `Customers`) and asks: "Analyze my sales data — show top products by revenue and monthly trends."

### Step 1: Inspect the file

```python
# Create and run inspection script
results = inspect_file('sales_2024.xlsx')
# Show user the structure: sheets, columns, sample data
```

### Step 2: Top products by revenue

```python
query = """
SELECT p.product_name,
       SUM(o.quantity * o.unit_price) as total_revenue,
       SUM(o.quantity) as total_units
FROM Orders o
JOIN Products p ON o.product_id = p.id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10
"""
results = run_query(['sales_2024.xlsx'], query)
# Present results as formatted table
```

### Step 3: Monthly revenue trends

```python
query = """
SELECT DATE_TRUNC('month', order_date) as month,
       SUM(quantity * unit_price) as revenue
FROM Orders
GROUP BY month
ORDER BY month
"""
results = run_query(['sales_2024.xlsx'], query)
# Export to CSV if needed
```

### Step 4: Statistical summary

```python
summary = generate_summary('sales_2024.xlsx', 'Orders')
# Show statistical summary for all numeric columns
```

Present results to the user with clear explanations of findings, trends, and actionable insights.

## Claude Code Adaptation Notes

**Key Differences from DeerFlow:**

- DeerFlow uses pre-built script at `/mnt/skills/public/data-analysis/scripts/analyze.py`
- Claude Code version: create analysis script on-the-fly or use inline Python
- DeerFlow uses virtual paths (`/mnt/user-data/uploads/`)
- Claude Code: use actual file paths from user's system

**Recommended Approach:**

1. Create a reusable `analyze.py` script in the project directory
2. Or use inline Python with DuckDB for quick analyses
3. Use `Write` tool to save results to files
4. Use `Read` tool to load and present results

**Tool Mapping:**

- DeerFlow `bash` → Claude Code `Bash`
- DeerFlow `write_file` → Claude Code `Write`
- DeerFlow `read_file` → Claude Code `Read`

## Output Handling

After analysis:

- Present query results directly in conversation as formatted tables
- For large results, export to file and share path with user
- Always explain findings in plain language with key takeaways
- Suggest follow-up analyses when patterns are interesting
- Offer to export results if the user wants to keep them

## Notes

- DuckDB supports full SQL including window functions, CTEs, subqueries, and advanced aggregations
- Excel date columns are automatically parsed; use DuckDB date functions (`DATE_TRUNC`, `EXTRACT`, etc.)
- For very large files (100MB+), DuckDB handles them efficiently without loading everything into memory
- Column names with spaces are accessible using double quotes: `"Column Name"`

---

**Source:** DeerFlow public skills (MIT License)
**Ported by:** Claude Code skill conversion
**Date:** 2026-04-03
