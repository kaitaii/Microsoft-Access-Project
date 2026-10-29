# Library Database Analysis (MS Access SQL)

A complete Microsoft Access SQL data processing pipeline designed to evaluate library checkout logs, calculate borrowing durations, apply business logic for overdue fines, and conduct author and inventory analytics.

---

## 📌 Project Overview
This project processes transactions from a static library database with an evaluation cutoff date of **November 1, 2018** for unreturned items. Using ANSI-compliant Access SQL across an 11-step query sequence, the workflow cleans transaction logs, segments loan statuses, calculates dynamic fines, consolidates master records, and extracts key catalog insights.

---

## 📊 Database Architecture & Row Counts

| Output Table | Record Count | Description |
| :--- | :---: | :--- |
| `Checkout Log` | 4,983 | Raw transaction history |
| `1_days` | 4,983 | Preprocessed log with calculated borrowing duration |
| `1_ontime` | 4,942 | Loans returned within standard limit ($\le 28$ days) |
| `1_overdue` | 41 | Overdue checkouts ($> 28$ days) with initial fine rate applied |
| `2_fine` | 4,942 | On-time transactions merged with book metadata ($\$0.00$ fine) |
| `1_fine` | 4,983 | Master fine dataset combining overdue and on-time records |
| `authorowned` | 91 | Unique IDs of authors with checkout activity |
| `Author_not_owned` | 9 | Catalog authors with zero checkout history |
| `Popularity` | 91 | Author rankings ordered by total borrow volume |
| `Books_with_world` | 22 | Catalog titles matching the search keyword "world" |
| `ISBN_complete` | 500 | Books table with imputed missing ISBN values |

---

## ⚙️ Query Execution Pipeline

The 11 SQL queries run in a strict sequence to ensure data integrity and accurate downstream calculations:

### 1. Data Cleaning & Duration Calculation
* **`01_Days.sql` (`Days`):** Uses `Nz()` to handle missing return dates by assigning the `#11/1/2018#` cutoff date, then calculates total borrowing duration in days using `DateDiff("d", DateBorrowed, Returned)`. Writes to `1_days`.

### 2. Loan Segmentation & Fine Logic
* **`02_ontime.sql` (`ontime`):** Filters records where `Days_borrowed <= 28`, assigning an initial fine of `$0` into `1_ontime`.
* **`03_overdue.sql` (`overdue`):** Filters records where `Days_borrowed > 28` and calculates late penalties using `Days_borrowed * 0.05` into `1_overdue`.
* **`04_Fine.sql` (`Fine`):** Performs an `INNER JOIN` between `Books` and `1_overdue` on `ISBN` to append book titles, edition, author IDs, and fine amounts into `1_fine`.
* **`05_fine2.sql` (`fine2`):** Performs an `INNER JOIN` between `1_ontime` and `Books` on `ISBN` to append metadata with a fixed `$0` fine into `2_fine`.
* **`06_combine.sql` (`combine`):** Executes an `INSERT INTO` append query to combine all 4,942 records from `2_fine` into `1_fine`, creating the master dataset of 4,983 checkouts.

### 3. Author & Inventory Analytics
* **`07_author_owned.sql` (`author owned`):** Extracts distinct active `Author ID`s from `1_fine` into `authorowned`.
* **`08_authornotowned.sql` (`authornotowned`):** Identifies inactive authors by querying `Authors` where `Author ID` is `Not In (SELECT authorid FROM authorowned)`. Writes 9 unowned authors to `Author_not_owned`.
* **`09_popular.sql` (`popular`):** Groups `1_fine` records by `Author ID` and aggregates checkout volume using `Count(*)` ordered descending into `Popularity`.
* **`10_books_with_world.sql` (`books with world`):** Filters book titles using pattern matching (`Like '*world*'`) into `Books_with_world`.
* **`11_isbn.sql` (`isbn`):** Uses `Nz()` to replace null ISBN values with `'ISBN Missing'` across the catalog into `ISBN_complete`.

---

## 🛠️ Tools & Technologies
* **Database Engine:** Microsoft Access
* **Query Language:** Access SQL / ANSI SQL
* **Techniques Used:** Data Imputation (`Nz`), Date Arithmetic (`DateDiff`), Conditional Filtering, Multi-table Joins (`INNER JOIN`), Append Operations (`INSERT INTO`), Subqueries (`NOT IN`), Aggregations (`COUNT`, `GROUP BY`).

---

## 🚀 How to Review This Repository
* **View Code Online:** Open the [`queries/`](./queries/) folder to inspect individual SQL scripts directly in your browser.
* **Run in MS Access:** Download `Library_Database.accdb`, open it in Microsoft Access, and execute the saved queries to re-create the tables and review output relationships.
