# Oppgave 3 – SQL-spørringer for ga_bibliotek
-- Task 3 – SQL queries for ga_bibliotek


USE `ga_bibliotek`;
-- Use the existing database we created in Oppgave 1.

## 1) Hent alle bøker publisert etter år 2000
--    (Get all books published after the year 2000)
-- -------------------------------------------------

SELECT *
-- Select all columns from the table (ISBN, title, author, …)
FROM `bok`
-- From the book table.
WHERE `UtgittÅr` > 2000
-- Only show books where the publication year is greater than 2000.
ORDER BY `UtgittÅr`, `Tittel`;
-- Sort first by year, then by title so the result looks tidy.



## 2) Hent forfatternavn og tittel på alle bøker,
--    sortert alfabetisk etter forfatter
--    (Get author and title of all books, sorted by author)
-- -------------------------------------------------

SELECT `Forfatter`, `Tittel`
-- We only need these two columns: author and title.
FROM `bok`
-- From the book table.
ORDER BY `Forfatter`, `Tittel`;
-- Sort by author name first, and if an author has many books, sort their books by title.



## 3) Hent alle bøker med mer enn 300 sider
--    (Get all books with more than 300 pages)
-- -------------------------------------------------

SELECT *
-- We want to see the whole book row.
FROM `bok`
-- From the book table.
WHERE `AntallSider` > 300
-- Filter to only books with more than 300 pages.
ORDER BY `AntallSider` DESC, `Tittel`;
-- Show the longest books first, and then sort by title for books with same page count.



## 4) Legg til en ny bok i tabellen 'bok'
--    (Insert a new book into the 'bok' table)
--    NOTE: we keep ON DUPLICATE KEY so the file can be run twice
--    NOTE 2: ISBN must be 10 chars because table has CHAR(10)
-- -------------------------------------------------

INSERT INTO `bok` (`ISBN`, `Tittel`, `Forfatter`, `Forlag`, `UtgittÅr`, `AntallSider`)
-- Insert into the book table, listing the columns in the right order.
VALUES ('8203361234', 'Naiv. Super', 'Loe, Erlend', 'Cappelen Damm', 1996, 208)
-- The actual values for the new book we want to add.
ON DUPLICATE KEY UPDATE
-- If a book with this ISBN already exists (same PK), update it instead.
  `Tittel`      = VALUES(`Tittel`),
  -- Update the title to the value we just tried to insert.
  `Forfatter`   = VALUES(`Forfatter`),
  -- Update the author.
  `Forlag`      = VALUES(`Forlag`),
  -- Update the publisher.
  `UtgittÅr`    = VALUES(`UtgittÅr`),
  -- Update the publication year.
  `AntallSider` = VALUES(`AntallSider`);
  -- Update the number of pages.



## 5) Legg til en ny låner i tabellen 'låner'
--    (Insert a new borrower into the 'låner' table)
--    We force LNr=3 so ON DUPLICATE KEY makes sense
-- -------------------------------------------------

INSERT INTO `låner` (`LNr`, `Fornavn`, `Etternavn`, `Adresse`)
-- Insert into the borrower table and explicitly give the columns.
VALUES (3, 'Nina', 'Nordmann', 'Storgata 1')
-- We try to create borrower no. 3 with name and address.
ON DUPLICATE KEY UPDATE
-- If LNr = 3 already exists, we update instead.
  `Fornavn`  = VALUES(`Fornavn`),
  -- Update first name.
  `Etternavn` = VALUES(`Etternavn`),
  -- Update last name.
  `Adresse`  = VALUES(`Adresse`);
  -- Update address.



## 6) Oppdater adresse for en spesifikk låner
--    (Update the address for a specific borrower)
-- -------------------------------------------------

UPDATE `låner`
-- We are changing data in the borrower table.
SET `Adresse` = 'Nyveien 42'
-- New address we want to set.
WHERE `LNr` = 3;
-- Only change the borrower whose ID is 3.



## 7) Hent alle utlån med lånerens navn og boktittel
--    (Get all loans with the borrower's name and the book title)
--    IMPORTANT: utlån points to (ISBN, EksNr) → we must join via eksemplar
-- -------------------------------------------------

SELECT u.`UtlånsNr`,
-- Show the loan number.
       l.`Fornavn`,
-- Show the borrower’s first name.
       l.`Etternavn`,
-- Show the borrower’s last name.
       b.`Tittel`,
-- Show the title of the borrowed book.
       u.`Utlånsdato`,
-- Show the date the book was borrowed.
       u.`Levert`
-- Show whether the book is returned (1) or not (0).
FROM `utlån` AS u
-- Start from the loan table.
JOIN `låner` AS l
  ON u.`LNr` = l.`LNr`
  -- Connect loan to borrower using the foreign key LNr.
JOIN `eksemplar` AS e
  ON u.`ISBN` = e.`ISBN` AND u.`EksNr` = e.`EksNr`
  -- Connect loan to the exact copy that was borrowed.
JOIN `bok` AS b
  ON e.`ISBN` = b.`ISBN`
  -- From the copy we can find the actual book info.
ORDER BY u.`UtlånsNr`;
-- List the loans in the order they were made.



## 8) Hent alle bøker og antall eksemplarer for hver bok
--    (Get all books and the number of copies for each book)
-- -------------------------------------------------

SELECT b.`ISBN`,
-- Show the book’s ISBN.
       b.`Tittel`,
-- Show the book’s title.
       COUNT(e.`EksNr`) AS `antall_eksemplar`
-- Count how many copies (eksemplar) exist for this ISBN.
FROM `bok` AS b
-- Start with all books.
LEFT JOIN `eksemplar` AS e
  ON e.`ISBN` = b.`ISBN`
  -- Join copies if they exist; LEFT JOIN keeps books even without copies.
GROUP BY b.`ISBN`, b.`Tittel`
-- We need to group by book to count per book.
ORDER BY b.`Tittel`;
-- Sort books alphabetically.



## 9) Hent antall utlån per låner
--    (Get the number of loans per borrower)
-- -------------------------------------------------

SELECT l.`LNr`,
-- Show the borrower ID.
       l.`Fornavn`,
-- Show first name.
       l.`Etternavn`,
-- Show last name.
       COUNT(u.`UtlånsNr`) AS `antall_utlån`
-- Count how many loans this borrower has.
FROM `låner` AS l
-- Start from all borrowers.
LEFT JOIN `utlån` AS u
  ON u.`LNr` = l.`LNr`
  -- Join loans, if any, for each borrower.
GROUP BY l.`LNr`, l.`Fornavn`, l.`Etternavn`
-- Group per borrower to count their loans.
ORDER BY `antall_utlån` DESC, l.`Etternavn`, l.`Fornavn`;
-- Show the borrowers with most loans first, then sort by name.



## 10) Hent antall utlån per bok
--     (Get the number of loans per book)
-- -------------------------------------------------

SELECT b.`ISBN`,
-- Show the book’s ISBN.
       b.`Tittel`,
-- Show the book’s title.
       COUNT(u.`UtlånsNr`) AS `antall_utlån`
-- Count how many loans that book has.
FROM `bok` AS b
-- Start from all books.
LEFT JOIN `utlån` AS u
  ON u.`ISBN` = b.`ISBN`
  -- Join loans that reference this book’s ISBN.
GROUP BY b.`ISBN`, b.`Tittel`
-- Group per book to count per book.
ORDER BY `antall_utlån` DESC, b.`Tittel`;
-- Show most-loaned books first, then order by title.



## 11) Hent alle bøker som ikke har blitt lånt ut
--     (Get all books that have never been borrowed)
-- -------------------------------------------------

SELECT b.`ISBN`,
-- Show the book’s ISBN.
       b.`Tittel`
-- Show the book’s title.
FROM `bok` AS b
-- Start from all books.
LEFT JOIN `utlån` AS u
  ON u.`ISBN` = b.`ISBN`
  -- Try to match each book with a loan (if it exists).
WHERE u.`ISBN` IS NULL
-- Keep only books that did NOT get a matching loan.
ORDER BY b.`Tittel`;
-- Show them alphabetically.



## 12) Hent forfatter og antall utlånte bøker per forfatter
--     (Get each author and how many of their books were borrowed)
-- -------------------------------------------------

SELECT b.`Forfatter`,
-- Show the author’s name.
       COUNT(u.`UtlånsNr`) AS `antall_utlån`
-- Count all loan rows for books written by this author.
FROM `bok` AS b
-- Start from books (they hold the author).
LEFT JOIN `utlån` AS u
  ON u.`ISBN` = b.`ISBN`
  -- Join loans so we can count them per author.
GROUP BY b.`Forfatter`
-- Group per author to summarize.
ORDER BY `antall_utlån` DESC, b.`Forfatter`;
-- Show the authors with most borrowed books first.
