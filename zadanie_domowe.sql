-- Tworzy tabelę pracownik(imie, nazwisko, wyplata, data urodzenia, stanowisko). W tabeli mogą być dodatkowe kolumny, które uznasz za niezbędne.
CREATE SCHEMA `zadanie_domowe`;
USE `zadanie_domowe`;

-- Wstawia do tabeli co najmniej 6 pracowników
CREATE TABLE `pracownicy` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(30) NOT NULL,
  `last_name` VARCHAR(30) NOT NULL,
  `salary` DECIMAL(10,2) NOT NULL,
  `birth_day` DATE NOT NULL,
  `department` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC) VISIBLE);
  
-- Pobiera wszystkich pracowników i wyświetla ich w kolejności alfabetycznej po nazwisku
INSERT INTO `zadanie_domowe`.`pracownicy` (`first_name`, `last_name`, `salary`, `birth_day`, `department`) VALUES ('Krzychu', 'Przystarz', '4999.99', '1993-05-13', 'Junior Java Developer');
INSERT INTO `zadanie_domowe`.`pracownicy` (`first_name`, `last_name`, `salary`, `birth_day`, `department`) VALUES ('Maciej', 'Przystarz', '5499', '1993-05-14', 'Junior Java Developer');
INSERT INTO `zadanie_domowe`.`pracownicy` (`first_name`, `last_name`, `salary`, `birth_day`, `department`) VALUES ('Marcin', 'Kunert', '11999', '1994-01.01', 'Senior Java Developer');
INSERT INTO `zadanie_domowe`.`pracownicy` (`first_name`, `last_name`, `salary`, `birth_day`, `department`) VALUES ('Nati', 'Koltko', '9999', '1998-12-13', 'Scrum Master');
INSERT INTO `zadanie_domowe`.`pracownicy` (`first_name`, `last_name`, `salary`, `birth_day`, `department`) VALUES ('Sławek', 'Ludwiczak', '13999', '1994-02-02', 'Senior Java Developer');

-- Pobiera pracowników na wybranym stanowisku
SELECT * FROM pracownicy ORDER BY last_name;

-- Pobiera pracowników, którzy mają co najmniej 30 lat
SELECT * FROM pracownicy WHERE birth_day <= DATE_SUB(CURDATE(), INTERVAL 30 YEAR);

-- Zwiększa wypłatę pracowników na wybranym stanowisku o 10%
SET SQL_SAFE_UPDATES = 0;
UPDATE pracownicy SET salary = salary * 1.1 WHERE department = 'Scrum Master';

-- Pobiera najmłodszego z pracowników (uwzględnij przypadek, że może być kilku urodzonych tego samego dnia)
SELECT * FROM pracownicy WHERE birth_day = (SELECT max(birth_day) FROM pracownicy);

-- Usuwa tabelę pracownik
DROP TABLE pracownicy;

-- Tworzy tabelę stanowisko (nazwa stanowiska, opis, wypłata na danym stanowisku)
CREATE TABLE `stanowiska` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`department_name` VARCHAR(30) NOT NULL,
`description` VARCHAR(200) NOT NULL,
`salary` DECIMAL(10,2) NOT NULL);
  
-- Tworzy tabelę adres (ulica+numer domu/mieszkania, kod pocztowy, miejscowość)
CREATE TABLE `adresy` ( 
`id` INT PRIMARY KEY AUTO_INCREMENT,
`street_and_number` VARCHAR(50) NOT NULL,
`zip_code` CHAR(10) NOT NULL,
`city` VARCHAR(40) NOT NULL);

-- Tworzy tabelę pracownik (imię, nazwisko) + relacje do tabeli stanowisko i adres
CREATE TABLE `pracownicy2` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(30) NOT NULL,
`last_name` VARCHAR(30) NOT NULL,
`dep_id` INT NOT NULL,
`address_id` INT NOT NULL,
FOREIGN KEY (dep_id) REFERENCES stanowiska (id),
FOREIGN KEY (address_id) REFERENCES adresy (id));

-- Dodaje dane testowe (w taki sposób, aby powstały pomiędzy nimi sensowne powiązania)
INSERT INTO `stanowiska` (id, department_name, description, salary)
VALUES (1, 'Manager', 'Osoba zajmująca się prowadzeniem zespołu', 7999.99),
       (2, 'Tester', 'Kontrola stworzonych programów', 5999.99),
       (3, 'Programista', 'Tworzenie aplikacji', 8999.99);
       
INSERT INTO `zadanie_domowe`.`stanowiska` (id, department_name, description, salary) VALUES (4, 'Doświadczony Programista', 'Tworzenie aplikacji', 10000.00);

-- Dodawanie danych do tabeli adres
INSERT INTO `adresy` (id, street_and_number, city, zip_code)
VALUES (1, 'ul. Kwiatowa 1', 'Warszawa', '01-234'),
       (2, 'ul. Słoneczna 2', 'Kraków', '12-345'),
       (3, 'ul. Zielona 3', 'Gdańsk', '23-456');
       
INSERT INTO `zadanie_domowe`.`adresy` (`id`, `street_and_number`, `zip_code`, `city`) VALUES ('4', 'ul. Dworcowa 60', '55-120', 'Oborniki Śląskie');

-- Dodawanie danych do tabeli pracownicy
INSERT INTO `pracownicy2` (id, first_name, last_name, dep_id, address_id)
VALUES (1, 'Jan', 'Kowalski', 1, 1),
       (2, 'Anna', 'Nowak', 2, 2),
       (3, 'Piotr', 'Wiśniewski', 3, 3),
       (4, 'Krzysiek', 'Przystarz', 4, 4);

-- Pobiera pełne informacje o pracowniku (imię, nazwisko, adres, stanowisko)
SELECT first_name, last_name, a.street_and_number, a.city, s.department_name 
FROM pracownicy2 p
JOIN adresy a ON a.id = p.id
JOIN stanowiska s ON s.id = p.id
WHERE p.id = '1';

-- Oblicza sumę wypłat dla wszystkich pracowników w firmie

SELECT SUM(s.salary) AS Suma_wypłat
FROM stanowiska s
JOIN pracownicy2 p ON p.id = s.id;

-- Pobiera pracowników mieszkających w lokalizacji z kodem pocztowym 90210 (albo innym, który będzie miał sens dla Twoich danych testowych)
SELECT p.first_name, p.last_name, s.department_name, s.description, s.salary, a.street_and_number, a.zip_code, a.city
FROM stanowiska s
JOIN pracownicy2 p ON s.id = p.id
JOIN adresy a ON p.id = a.id
WHERE a.zip_code = '01-234';