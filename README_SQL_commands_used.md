# 💡 SQL Commands Used — Explanation and Purpose

This section explains **all SQL keywords, clauses, and functions** used in the `ga_bibliotek` project —  
what each means, why it is used, and how it affects the database structure or data.

---

## 🧱 1) Database and Table Structure (DDL — Data Definition Language)

### `DROP DATABASE IF EXISTS ga_bibliotek;`
- Removes the existing database if it already exists.  
- Prevents errors when re-running the script.  
- Used to reset the workspace before creating a fresh database.

---

### `CREATE DATABASE ga_bibliotek CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`
- Creates a new database called **`ga_bibliotek`**.  
- `CHARACTER SET utf8mb4` → allows all Unicode characters, including Norwegian letters (æ, ø, å).  
- `COLLATE utf8mb4_unicode_ci` → defines how text is sorted and compared (Unicode and case-insensitive).

---

### `USE ga_bibliotek;`
- Activates the selected database.  
- All following commands are executed inside this database.

---

### `CREATE TABLE ... ( ... )`
- Creates a new table with specified columns, data types, and constraints.  
- Example: `CREATE TABLE bok (...)` creates the table that stores book information.

---

### `ENGINE = InnoDB`
- Sets the table storage engine to **InnoDB**, which supports:  
  - **Foreign keys** (relationships)  
  - **Transactions** (safe multi-step updates)  
  - **Row-level locking** for better integrity

---

### `DEFAULT CHARSET = utf8mb4` and `COLLATE = utf8mb4_unicode_ci`
- Ensure consistent text encoding for each table.  
- Prevents text corruption and sorting issues for multilingual content.

---

### `PRIMARY KEY`
- Marks one or more columns as unique identifiers for each record.  
- Prevents duplicate rows.  
- Example: `PRIMARY KEY (ISBN)` means every book must have a unique ISBN number.

---

### `FOREIGN KEY (...) REFERENCES ... (...)`
- Links one table to another (a relationship).  
- Example: `FOREIGN KEY (ISBN) REFERENCES bok(ISBN)` ensures copies reference valid books.  
- Maintains **referential integrity** between parent and child tables.

---

### `ON UPDATE CASCADE`
- Automatically updates related records if a referenced key changes.  
- Keeps relationships synchronized across tables.

---

### `ON DELETE RESTRICT`
- Prevents deletion of parent records that are still referenced elsewhere.  
- Example: prevents deleting a book that still has copies in `eksemplar`.

---

### `CHECK ( ... )`
- Defines a logical condition that data must follow.  
- Example: `CHECK (AntallSider > 0)` ensures books can’t have negative or zero pages.

---

### `AUTO_INCREMENT`
- Automatically generates unique numbers for new rows.  
- Used for primary keys like `LNr` (borrower number) or `UtlånsNr` (loan number).

---

### `CHAR(n)`
- Fixed-length text column that always uses `n` characters.  
- Example: `CHAR(10)` for ISBNs (which are always 10 digits).

---

### `VARCHAR(n)`
- Variable-length text column (up to `n` characters).  
- Example: `VARCHAR(255)` for `Tittel` (book title).

---

### `SMALLINT`
- Integer type for small numeric values (e.g., publication year).  
- Often combined with `UNSIGNED` to allow only positive numbers.

---

### `INT`
- Standard integer data type.  
- Used for IDs, copy numbers, and counts.

---

### `TINYINT(1)`
- Very small integer used for logical (boolean) values.  
- Example: `Levert TINYINT(1)` → 0 = not returned, 1 = returned.

---

### `DATE`
- Stores calendar dates in the format `YYYY-MM-DD`.  
- Example: `Utlånsdato` stores the date a book was borrowed.

---

### `UNSIGNED`
- Prevents negative numbers from being stored.  
- Example: `UtgittÅr SMALLINT UNSIGNED` ensures no negative years.

---

### `NOT NULL`
- Ensures that a column must always have a value.  
- Used for required fields like titles, authors, or addresses.

---

### `UNIQUE`
- Ensures all values in a column are different.  
- Prevents duplication of unique identifiers like ISBNs or emails.

---

---

## ✏️ 2) Data Manipulation (DML — Data Manipulation Language)

### `INSERT INTO ... VALUES (...);`
- Adds a new record into a table.  
- Example: adds books, borrowers, or loans to their respective tables.

---

### `VALUES`
- Defines the actual data being inserted into the columns.

---

### `ON DUPLICATE KEY UPDATE`
- Updates existing rows if the inserted data conflicts with an existing primary key.  
- Prevents duplicate records and allows safe re-running of scripts.

---

### `UPDATE ... SET ... WHERE ...;`
- Changes existing records that match a specific condition.  
- Example: `UPDATE låner SET Adresse = 'Nyveien 42' WHERE LNr = 3;` changes one borrower’s address.

---

### `SET`
- Defines which column(s) to update and their new values.

---

### `WHERE`
- Adds a condition to specify which rows to update, delete, or select.  
- Ensures that only the intended records are affected.

---

---

## 📊 3) Reading and Querying Data (SELECT — Data Query Language)

### `SELECT`
- Retrieves data from one or more tables.  
- Used for reports, summaries, and validation.

---

### `*` (Asterisk)
- Selects all columns from a table.  
- Example: `SELECT * FROM bok;` returns all data about books.

---

### `FROM`
- Specifies the table(s) to select data from.

---

### `JOIN`
- Combines data from two or more related tables based on matching columns.  
- Example: `JOIN låner ON utlån.LNr = låner.LNr`.

---

### `LEFT JOIN`
- Returns all rows from the left table, even if no matching row exists in the right table.  
- Example: shows all books, even those never borrowed.

---

### `ON`
- Defines the relationship used in a `JOIN`.  
- Example: `ON u.LNr = l.LNr` links loans to borrowers.

---

### `AS`
- Creates a temporary alias for a table or column.  
- Example: `bok AS b` → allows writing `b.Tittel` instead of `bok.Tittel`.

---

### `GROUP BY`
- Groups rows that share the same value(s).  
- Commonly used with aggregate functions like `COUNT()` or `SUM()`.

---

### `COUNT()`
- Counts how many rows match a condition.  
- Example: counts total loans per borrower or total copies per book.

---

### `ORDER BY`
- Sorts query results by one or more columns.  
- Can use `ASC` (ascending) or `DESC` (descending).  
- Example: `ORDER BY AntallSider DESC` shows the thickest books first.

---

### `ASC`
- Sorts in ascending (A–Z, 0–9) order.  
- Default behavior if no direction is specified.

---

### `DESC`
- Sorts in descending (Z–A, highest to lowest) order.  
- Used when showing most recent or largest values first.

---

### `IS NULL`
- Checks for empty (null) values.  
- Example: used to find books with no related loan records.

---

---

## 🔐 4) Logical & Integrity Constraints

### `REFERENCES`
- Used in a `FOREIGN KEY` definition to specify which column it links to in another table.

---

### `CASCADE`
- Keyword defining automatic propagation of changes.  
- `ON UPDATE CASCADE` → updates linked data when the parent key changes.

---

### `RESTRICT`
- Prevents deleting or updating a record if it’s still being referenced elsewhere.  
- Example: you can’t delete a borrower who still has active loans.

---

### `CHECK`
- Validates data using logical conditions.  
- Example: `CHECK (Levert IN (0,1))` restricts the return status to valid values only.

---

---

## 💬 5) SQL Command Categories — Summary

| Category | Full Name | Purpose | Examples |
|-----------|------------|----------|-----------|
| **DDL** | Data Definition Language | Defines database structure | `CREATE TABLE`, `PRIMARY KEY`, `FOREIGN KEY` |
| **DML** | Data Manipulation Language | Adds or updates data | `INSERT`, `UPDATE`, `ON DUPLICATE KEY UPDATE` |
| **DQL** | Data Query Language | Retrieves and displays data | `SELECT`, `JOIN`, `GROUP BY`, `COUNT()` |
| **DCL** | Data Control Language | Manages access permissions (not used here) | `GRANT`, `REVOKE` |
| **TCL** | Transaction Control Language | Manages multi-step transactions (not used here) | `COMMIT`, `ROLLBACK` |

---

## ✅ In Summary

All SQL commands in `ga_bibliotek` work together to make the system:

- **Structured** → defined with `CREATE`, `PRIMARY KEY`, and `FOREIGN KEY`.  
- **Accurate** → enforced with `CHECK`, `NOT NULL`, `CASCADE`, and `RESTRICT`.  
- **Efficient** → managed with `INSERT`, `UPDATE`, and `ON DUPLICATE KEY`.  
- **Readable** → retrieved with `SELECT`, `JOIN`, and `ORDER BY`.  
- **Consistent** → encoded with `utf8mb4` and `COLLATE utf8mb4_unicode_ci` for multilingual support.

---