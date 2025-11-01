-- ============================================
-- Oppgave 1 – ga_bibliotek (database + sample data)
-- Task 1 – ga_library (database + sample data)
-- ============================================

-- 1) Opprett databasen / Create the database
DROP DATABASE IF EXISTS `ga_bibliotek`;
CREATE DATABASE `ga_bibliotek`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE `ga_bibliotek`;

-- 2) Opprett tabellene / Create the tables
-- 2.1) Tabell: bok / Table: book
CREATE TABLE `bok` (
  `ISBN`        CHAR(10)     PRIMARY KEY,
  `Tittel`      VARCHAR(255) NOT NULL,
  `Forfatter`   VARCHAR(100) NOT NULL,
  `Forlag`      VARCHAR(100) NOT NULL,
  `UtgittÅr`    SMALLINT UNSIGNED NOT NULL,
  `AntallSider` INT NOT NULL CHECK (`AntallSider` > 0)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- 2.2) Tabell: eksemplar / Table: copy
CREATE TABLE `eksemplar` (
  `ISBN`  CHAR(10) NOT NULL,
  `EksNr` INT      NOT NULL,
  PRIMARY KEY (`ISBN`, `EksNr`),
  CONSTRAINT `fk_eksemplar_bok`
    FOREIGN KEY (`ISBN`) REFERENCES `bok`(`ISBN`)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- 2.3) Tabell: låner / Table: borrower
CREATE TABLE `låner` (
  `LNr`       INT AUTO_INCREMENT PRIMARY KEY,
  `Fornavn`   VARCHAR(50)  NOT NULL,
  `Etternavn` VARCHAR(50)  NOT NULL,
  `Adresse`   VARCHAR(255) NOT NULL
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

-- 2.4) Tabell: utlån / Table: loan
CREATE TABLE `utlån` (
  `UtlånsNr`   INT AUTO_INCREMENT PRIMARY KEY,
  `LNr`        INT      NOT NULL,
  `ISBN`       CHAR(10) NOT NULL,
  `EksNr`      INT      NOT NULL,
  `Utlånsdato` DATE     NOT NULL,
  `Levert`     TINYINT(1) NOT NULL CHECK (`Levert` IN (0,1)),
  CONSTRAINT `fk_utlån_låner`
    FOREIGN KEY (`LNr`) REFERENCES `låner`(`LNr`)
      ON UPDATE CASCADE
      ON DELETE RESTRICT,
  CONSTRAINT `fk_utlån_eksemplar`
    FOREIGN KEY (`ISBN`, `EksNr`) REFERENCES `eksemplar`(`ISBN`, `EksNr`)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;


-- ============================================
-- 3) EKSEMPELDATA / SAMPLE DATA
-- ============================================

-- 3.1) bok / book
INSERT INTO `bok` (ISBN, Tittel, Forfatter, Forlag, UtgittÅr, AntallSider) VALUES
('8203188443', 'Kristin Lavransdatter: kransen', 'Undset, Sigrid', 'Aschehoug', 1920, 323),
('8203209394', 'Fyret: en ny sak for Dalgliesh', 'James, P. D.', 'Aschehoug', 2005, 413),
('8205312443', 'Lasso rundt fru Luna', 'Mykle, Agnar', 'Gyldendal', 1954, 614),
('8205336148', 'Victoria', 'Hamsun, Knut', 'Gyldendal', 1898, 111),
('8253025033', 'Jonas', 'Bjørneboe, Jens', 'Pax', 1955, 302),
('8278442231', 'Den gamle mannen og havet', 'Hemingway, Ernest', 'Gyldendal', 1952, 99);

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

-- 3.4) utlån / loan
INSERT INTO `utlån` (LNr, ISBN, EksNr, Utlånsdato, Levert) VALUES
(2, '8203209394', 1, '2022-08-25', 0),
(2, '8253025033', 2, '2022-08-26', 1),
(3, '8203188443', 1, '2022-09-02', 0),
(8, '8278442231', 1, '2022-09-02', 0),
(2, '8205336148', 2, '2022-09-03', 0),
(8, '8203209394', 2, '2022-09-06', 0),
(7, '8205312443', 1, '2022-09-11', 1);


-- ============================================
-- 4) Testspørringer / Test queries
-- ============================================

-- 4.1) Antall bøker / Count of books
SELECT COUNT(*) AS `antall_bøker`
FROM `bok`;

-- 4.2) Antall eksemplar per bok / Number of copies per book
SELECT `ISBN`, COUNT(*) AS `antall_eksemplar`
FROM `eksemplar`
GROUP BY `ISBN`;

-- 4.3) Alle lånere sortert på LNr / All borrowers sorted by LNr
SELECT *
FROM `låner`
ORDER BY `LNr`;

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