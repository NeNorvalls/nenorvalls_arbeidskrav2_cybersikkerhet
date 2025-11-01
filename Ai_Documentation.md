# 🤖 AI Assistance Documentation  
**Course:** Cybersikkerhet – Databasesystemer  
**Assignment:** Arbeidskrav Tema 2  
**Date of AI Use:** October 15, 2025  
**Tool Used:** ChatGPT (GPT-5, OpenAI)

---

## 🧠 Purpose of AI Use
This document serves as proof of ethical AI use for **learning and guidance only**.  
ChatGPT was used to request structured **tips, checklists, and conceptual explanations**, not direct answers or SQL code.

---

## 📝 Prompt Submitted to ChatGPT

> Pls give me guides how to do this task : Don't give me any direct answer just tips or checklist or list of query command  and understand of each query  to use? don't even give me examples.:Cybersikkerhet Arbeidskrav Tema 2 Databasesystemer TID:   17/10/2025 – 07/11/2025 Hjelpemidler:  Alle Vedlegg:   Ingen Innlevering: Oppgave1: SQL script med definisjoner av database og inserts av data Oppgave2: Readme.md fil med forklaring av database design/struktur Oppgave3: SQL script med spørringer ...

---

## 💬 ChatGPT Answer (Guidance Only)

### **Task 1 – Database Creation & Data (DDL + DML)**

#### **Checklist: structure and setup**

**Order of operations:**
- Drop → Create database → Set charset/collation → Use database → Create tables (parent before child).

**Data types:**
- Text fields (title, author, publisher, address) → choose appropriate lengths.  
- Year/date fields → use proper date/time types.  
- Boolean `Levert` (returned) → restrict to two values only.  
- Auto-increment primary key in required tables.

**Keys:**
- Define primary keys correctly (simple or composite).  
- Define foreign keys with sensible `ON UPDATE` / `ON DELETE` rules (e.g., RESTRICT or CASCADE).

**Constraints:**
- `NOT NULL` for fields that must always have a value.  
- `UNIQUE` where duplicates must not occur.  
- `CHECK` to limit the `Levert` column to allowed values.

**Indexes:**
- Create indexes on foreign keys.  
- Optional: extra indexes for frequent lookups (e.g., author, title).

**Insert order:**
- Insert parent data first (`bok`, `låner`) → then `eksemplar` → then `utlån`.

**Data consistency:**
- Use consistent date format.  
- Ensure ISBN in child tables exists in parent (`bok`).  
- `EksNr` (copy number) must be unique per book.

#### **Common pitfalls**
- Forgetting `USE` to select the database before creating tables.  
- Creating child tables before parents (causes FK errors).  
- Missing `AUTO_INCREMENT` on primary key columns.  
- Inconsistent ISBN references between tables.  
- Null values where constraints forbid them.

---

### **Task 2 – README.md (Database design explanation)**

#### **Checklist: what to include**
- **Introduction:** purpose of the database and what the system represents.  
- **Table structure:**  
  - Column names, data types, whether nullable, default values.  
  - Identify each table’s primary key (simple or composite) and explain why.  
  - Identify foreign keys, their referenced table/column, and reference behavior.  
  - Describe other constraints (UNIQUE, CHECK, NOT NULL).  
  - Mention any indexes and why they exist.
- **Relationships:**  
  - Cardinality (1–M, M–1) between tables.  
  - How `eksemplar` connects physical copies to `bok`.  
  - How `utlån` connects `låner` ↔ `eksemplar`.  
- **Integrity:**  
  - How FK constraints maintain referential integrity.  
  - How CHECK/NOT NULL/UNIQUE enforce data integrity.  
- **Business rules assumptions:**  
  - A book can have many copies.  
  - A loan always refers to one specific copy.  
  - The `Levert` field indicates loan status.  
- **ER diagram:**  
  - Create using any tool (e.g., draw.io) showing tables, keys, and relationships.  
- **How to run scripts:**  
  - Execution order (DDL → DML → Queries).  
  - Mention expected database engine/version.  
- **Documentation polish:**  
  - Include author, date, and small changelog.  
  - Structure sections clearly with headers and bullet lists.

---

### **Task 3 – Queries (DQL + DML)**

Below is what kind of query each task needs and what to focus on, but not the actual commands.

#### **Books published after year 2000**
- Use SELECT with WHERE (comparison on year).  
- Ensure correct numeric/year data type and proper condition.

#### **Author and title sorted alphabetically by author**
- Use SELECT projection and ORDER BY.  
- Optional secondary sort by title.

#### **Books with more than 300 pages**
- Use SELECT + WHERE (numeric comparison on page count).

#### **Add a new book**
- Use INSERT INTO (must include all required fields).  
- Check for uniqueness, correct data types, no null violations.

#### **Add a new borrower**
- Use INSERT INTO (`låner`) with auto-increment key.  
- Check mandatory fields and trimming of text values.

#### **Update address for a specific borrower**
- Use UPDATE + SET + WHERE (target single borrower).  
- Ensure WHERE clause is precise to avoid mass updates.

#### **All loans with borrower’s name and book title**
- Use JOIN between `utlån`, `låner`, and `bok`.  
- Confirm join conditions and column naming clarity.

#### **All books and number of copies per book**
- Use JOIN (`bok` ↔ `eksemplar`) + GROUP BY + COUNT.  
- Use LEFT JOIN to include books with zero copies.

#### **Number of loans per borrower**
- Use JOIN + GROUP BY + COUNT.  
- Consider LEFT JOIN to include borrowers with no loans.

#### **Number of loans per book**
- Use JOIN (`bok` ↔ `utlån`) + GROUP BY + COUNT.  
- Consider books with zero loans (LEFT JOIN).

#### **Books that have never been loaned**
- Use LEFT JOIN with NULL filtering or NOT EXISTS.  
- Ensure ISBN references are correct.

#### **Author and number of borrowed books per author**
- Use JOIN (`bok` ↔ `utlån`) + GROUP BY author + COUNT.  
- Clarify what is being counted (loans, copies, or titles).

---

### **Code Quality & Submission**

#### **Testing & validation**
- Run DDL first; verify all tables are created without errors.  
- Check FK constraints work as intended.  
- Insert sample data; confirm referential integrity.  
- Execute each query and confirm correct logic.  
- Add brief comments in your SQL scripts for clarity.

#### **File structure**
- One SQL script for DDL (tables, constraints).  
- One for DML (inserts).  
- One for queries (12 total, grouped clearly).  
- One README.md (design explanation).  
- Zip all files together, cleanly named.

#### **Readability & style**
- Consistent naming conventions.  
- Proper indentation and line breaks.  
- One line per column definition in DDL.  
- Section comments for clarity.

#### **Before submission**
- [ ] All PK/FK/constraints defined and tested.  
- [ ] `Levert` restricted to valid values.  
- [ ] Auto-increment active where needed.  
- [ ] Seed data obeys FK relationships.  
- [ ] All 12 queries run and produce valid results.  
- [ ] README clearly documents structure, keys, constraints, and relationships.  
- [ ] .zip file includes all required scripts.

#### **Debugging checklist**
- FK insert errors → check order and matching keys.  
- Duplicate key → verify unique/PK values.  
- Invalid data type → check data formats.  
- Empty query results → verify JOIN logic and filters.

---

✅ **In summary:**  
Your workflow should be **Plan → Create → Populate → Test → Explain → Deliver.**  
Focus on **structure, integrity, and clarity** rather than just “making it work.”

---


