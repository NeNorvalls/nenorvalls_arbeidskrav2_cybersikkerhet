# Oppgave1 Readme
```sql

## 1) Opprett databasen / Create the database
-- -------------------------------------------------
DROP DATABASE IF EXISTS `ga_bibliotek`;  
-- Deletes (drops) the database if it already exists to avoid duplication errors.

CREATE DATABASE `ga_bibliotek`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
-- Creates a new database named "ga_bibliotek" using UTF-8 encoding for full Unicode support.

USE `ga_bibliotek`;
-- Selects this database as the current working database for all following commands.


## 2) Opprett tabellene / Create the tables
-- -------------------------------------------------

-- 2.1) Tabell: bok / Table: book
CREATE TABLE `bok` (
  `ISBN`        CHAR(10)     PRIMARY KEY, 
  -- ISBN is the unique book identifier (10 characters). Primary key ensures uniqueness.
  
  `Tittel`      VARCHAR(255) NOT NULL,      
  -- Book title. Cannot be NULL (must always have a value).
  
  `Forfatter`   VARCHAR(100) NOT NULL,      
  -- Author name. Cannot be NULL.
  
  `Forlag`      VARCHAR(100) NOT NULL,      
  -- Publisher name. Cannot be NULL.
  
  `UtgittÅr`    SMALLINT UNSIGNED NOT NULL, 
  -- Year of publication. UNSIGNED = no negative numbers.
  
  `AntallSider` INT NOT NULL CHECK (`AntallSider` > 0)
  -- Number of pages. Must be greater than 0 (validated by CHECK constraint).
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
-- Creates the table using the InnoDB storage engine and sets Unicode encoding.


-- 2.2) Tabell: eksemplar / Table: copy
CREATE TABLE `eksemplar` (
  `ISBN`  CHAR(10) NOT NULL,
  -- ISBN connects each copy to a specific book.
  
  `EksNr` INT      NOT NULL,
  -- Copy number. For example, a library might have multiple copies of the same book.
  
  PRIMARY KEY (`ISBN`, `EksNr`),
  -- The combination of ISBN and copy number uniquely identifies a book copy.
  
  CONSTRAINT `fk_eksemplar_bok`
    FOREIGN KEY (`ISBN`) REFERENCES `bok`(`ISBN`)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
  -- Creates a foreign key link to the "bok" table.
  -- If ISBN changes in "bok", it's updated here automatically (CASCADE).
  -- Books cannot be deleted if copies exist (RESTRICT).
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
-- Creates the "eksemplar" table (book copies) with relationships to books.


-- 2.3) Tabell: låner / Table: borrower
CREATE TABLE `låner` (
  `LNr`       INT AUTO_INCREMENT PRIMARY KEY,
  -- Borrower number (unique ID). AUTO_INCREMENT makes it increase automatically.
  
  `Fornavn`   VARCHAR(50)  NOT NULL,
  -- First name of borrower.
  
  `Etternavn` VARCHAR(50)  NOT NULL,
  -- Last name of borrower.
  
  `Adresse`   VARCHAR(255) NOT NULL
  -- Borrower’s address.
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
-- Creates the "låner" table that stores library user information.


-- 2.4) Tabell: utlån / Table: loan
CREATE TABLE `utlån` (
  `UtlånsNr`   INT AUTO_INCREMENT PRIMARY KEY,
  -- Loan number. Unique ID for each borrowing transaction.
  
  `LNr`        INT      NOT NULL,
  -- References which borrower made the loan.
  
  `ISBN`       CHAR(10) NOT NULL,
  -- The ISBN of the borrowed book.
  
  `EksNr`      INT      NOT NULL,
  -- Which copy (EksNr) of the book was borrowed.
  
  `Utlånsdato` DATE     NOT NULL,
  -- The date the book was borrowed. Must follow YYYY-MM-DD format.
  
  `Levert`     TINYINT(1) NOT NULL CHECK (`Levert` IN (0,1)),
  -- Indicates whether the book was returned (1) or not (0).
  
  CONSTRAINT `fk_utlån_låner`
    FOREIGN KEY (`LNr`) REFERENCES `låner`(`LNr`)
      ON UPDATE CASCADE
      ON DELETE RESTRICT,
  -- Links each loan to a specific borrower.
  -- CASCADE updates borrower ID changes, RESTRICT prevents deletion if loans exist.
  
  CONSTRAINT `fk_utlån_eksemplar`
    FOREIGN KEY (`ISBN`, `EksNr`) REFERENCES `eksemplar`(`ISBN`, `EksNr`)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
  -- Links each loan to a specific book copy (ISBN + EksNr combination).
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
-- Creates the "utlån" (loan) table with relationships to borrowers and copies.


## 3) EKSEMPELDATA / SAMPLE DATA
-- -------------------------------------------------

-- 3.1) bok / book
INSERT INTO `bok` (ISBN, Tittel, Forfatter, Forlag, UtgittÅr, AntallSider) VALUES
('8203188443', 'Kristin Lavransdatter: kransen', 'Undset, Sigrid', 'Aschehoug', 1920, 323),
('8203209394', 'Fyret: en ny sak for Dalgliesh', 'James, P. D.', 'Aschehoug', 2005, 413),
('8205312443', 'Lasso rundt fru Luna', 'Mykle, Agnar', 'Gyldendal', 1954, 614),
('8205336148', 'Victoria', 'Hamsun, Knut', 'Gyldendal', 1898, 111),
('8253025033', 'Jonas', 'Bjørneboe, Jens', 'Pax', 1955, 302),
('8278442231', 'Den gamle mannen og havet', 'Hemingway, Ernest', 'Gyldendal', 1952, 99);
-- Inserts 6 example books with all details matching the given dataset.


-- 3.2) eksemplar / copy
INSERT INTO `eksemplar` (ISBN, EksNr) VALUES
('8203188443', 1),
('8203188443', 2),
('8203209394', 1),
('8203209394', 2),
('8203209394', 3),
('8205312443', 1),
('8205336148', 1),
('8205336148', 2),
('8253025033', 1),
('8253025033', 2),
('8278442231', 1);
-- Inserts 11 copies (examples) of books.
-- Each ISBN can have multiple copies, identified by a copy number (EksNr).


-- 3.3) låner / borrower
INSERT INTO `låner` (Fornavn, Etternavn, Adresse) VALUES
('Lise',   'Jensen',   'Erling Skjalgssons gate 56'),
('Joakim', 'Gjertsen', 'Grinda 2'),
('Katrine','Garvik',   'Ottar Birtings gate 9'),
('Emilie', 'Marcussen','Kyrre Grepps gate 19'),
('Valter', 'Eilertsen','Fyrstikkbakken 5D'),
('Tormod', 'Vaksdal',  'Lassons gate 32'),
('Asle',   'Eckhoff',  'Kirkeveien 5'),
('Birthe', 'Aass',     'Henrik Wergelands Allé 47');
-- Inserts 8 borrowers with first name, last name, and address.
-- LNr is automatically assigned (1 to 8) because of AUTO_INCREMENT.


-- 3.4) utlån / loan
INSERT INTO `utlån` (LNr, ISBN, EksNr, Utlånsdato, Levert) VALUES
(2, '8203209394', 1, '2022-08-25', 0),
(2, '8253025033', 2, '2022-08-26', 1),
(3, '8203188443', 1, '2022-09-02', 0),
(8, '8278442231', 1, '2022-09-02', 0),
(2, '8205336148', 2, '2022-09-03', 0),
(8, '8203209394', 2, '2022-09-06', 0),
(7, '8205312443', 1, '2022-09-11', 1);
-- Inserts 7 loan records. Each line shows:
-- Borrower (LNr), Book ISBN, Copy number, Date borrowed, and whether returned (Levert).


## 4) Testspørringer / Test queries
-- -------------------------------------------------

-- 4.1) Antall bøker / Count of books
SELECT COUNT(*) AS `antall_bøker`
FROM `bok`;
-- Counts the total number of books in the "bok" table.


-- 4.2) Antall eksemplar per bok / Number of copies per book
SELECT `ISBN`, COUNT(*) AS `antall_eksemplar`
FROM `eksemplar`
GROUP BY `ISBN`;
-- Groups by ISBN and counts how many copies exist for each book.


-- 4.3) Alle lånere sortert på LNr / All borrowers sorted by LNr
SELECT *
FROM `låner`
ORDER BY `LNr`;
-- Retrieves all borrowers and sorts them by their ID number.


-- 4.4) Alle utlån med navn på låner og boktittel
-- / All loans with borrower name and book title
SELECT u.`UtlånsNr`,
       l.`Fornavn`,
       l.`Etternavn`,
       b.`Tittel`,
       u.`Utlånsdato`,
       u.`Levert`
FROM `utlån` AS u
JOIN `låner` AS l
  ON u.`LNr` = l.`LNr`
JOIN `eksemplar` AS e
  ON u.`ISBN` = e.`ISBN` AND u.`EksNr` = e.`EksNr`
JOIN `bok` AS b
  ON e.`ISBN` = b.`ISBN`
ORDER BY u.`UtlånsNr`;
-- Joins the four tables together to show:
-- Loan number, borrower’s first and last name, book title, date, and whether it’s returned.
```
