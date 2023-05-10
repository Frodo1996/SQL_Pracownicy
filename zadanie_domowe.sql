-- Tworzy tabelę pracownik(imie, nazwisko, wyplata, data urodzenia, stanowisko). W tabeli mogą być dodatkowe kolumny, które uznasz za niezbędne.
CREATE SCHEMA `zadanie_domowe`;

-- Wstawia do tabeli co najmniej 6 pracowników
CREATE TABLE `tabela_pracownikow` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(30) NOT NULL,
  `last_name` VARCHAR(30) NOT NULL,
  `salary` DECIMAL(10,2) NOT NULL,
  `birth_day` DATE NOT NULL,
  `department` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC) VISIBLE);
  
-- Pobiera wszystkich pracowników i wyświetla ich w kolejności alfabetycznej po nazwisku
INSERT INTO `zadanie_domowe`.`tabela_pracownikow` (`first_name`, `last_name`, `salary`, `birth_day`, `department`) VALUES ('Krzychu', 'Przystarz', '4999.99', '1976-03-24', 'Junior Java Developer');
INSERT INTO `zadanie_domowe`.`tabela_pracownikow` (`first_name`, `last_name`, `salary`, `birth_day`, `department`) VALUES ('Maciej', 'Przystarz', '5499', '2000-06-20', 'Junior Java Developer');
INSERT INTO `zadanie_domowe`.`tabela_pracownikow` (`first_name`, `last_name`, `salary`, `birth_day`, `department`) VALUES ('Marcin', 'Kunert', '11999', '1994-01.01', 'Senior Java Developer');
INSERT INTO `zadanie_domowe`.`tabela_pracownikow` (`first_name`, `last_name`, `salary`, `birth_day`, `department`) VALUES ('Nati', 'Koltko', '9999', '1998-12-13', 'Scrum Master');
INSERT INTO `zadanie_domowe`.`tabela_pracownikow` (`first_name`, `last_name`, `salary`, `birth_day`, `department`) VALUES ('Sławek', 'Ludwiczak', '13999', '1994-02-02', 'Senior Java Developer');

-- Pobiera pracowników na wybranym stanowisku
SELECT * FROM tabela_pracownikow ORDER BY last_name;

-- Pobiera pracowników, którzy mają co najmniej 30 lat

SELECT * FROM tabela_pracownikow WHERE birth_day <= '1993-01-01';
-- Zwiększa wypłatę pracowników na wybranym stanowisku o 10%
SET SQL_SAFE_UPDATES = 0;
UPDATE tabela_pracownikow SET salary = salary * 1.1 WHERE department = 'Scrum Master';
-- Pobiera najmłodszego z pracowników (uwzględnij przypadek, że może być kilku urodzonych tego samego dnia)
SELECT * FROM tabela_pracownikow WHERE birth_day = (SELECT max(birth_day) FROM tabela_pracownikow);
-- Usuwa tabelę pracownik
DELETE FROM tabela_pracownikow;
-- Tworzy tabelę stanowisko (nazwa stanowiska, opis, wypłata na danym stanowisku)
CREATE TABLE `tabela_stanowiska` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`department_name` VARCHAR(30) NOT NULL,
`description` VARCHAR(200) NOT NULL,
`salary` DECIMAL(10,2) NOT NULL);
  
-- Tworzy tabelę adres (ulica+numer domu/mieszkania, kod pocztowy, miejscowość)
CREATE TABLE `tabela_adresow` ( 
`id` INT PRIMARY KEY AUTO_INCREMENT,
`street_and_number` VARCHAR(50) NOT NULL,
`zip_code` CHAR(10) NOT NULL,
`city` VARCHAR(40) NOT NULL);

-- Tworzy tabelę pracownik (imię, nazwisko) + relacje do tabeli stanowisko i adres
CREATE TABLE `tabela_pracownik` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(30) NOT NULL,
`last_name` VARCHAR(30) NOT NULL,
`dep_id` INT NOT NULL,
`address_id` INT NOT NULL,
FOREIGN KEY (dep_id) REFERENCES tabela_stanowiska (id),
FOREIGN KEY (address_id) REFERENCES tabela_adresow (id));

-- Dodaje dane testowe (w taki sposób, aby powstały pomiędzy nimi sensowne powiązania)
INSERT INTO `tabela_stanowiska` (id, department_name, description, salary)
VALUES (1, 'Manager', 'Osoba zajmująca się prowadzeniem zespołu', 7999.99),
       (2, 'Tester', 'Kontrola stworzonych programów', 5999.99),
       (3, 'Programista', 'Tworzenie aplikacji', 8999.99);

-- Dodawanie danych do tabeli adres
INSERT INTO `tabela_adresow` (id, street_and_number, city, zip_code)
VALUES (1, 'ul. Kwiatowa 1', 'Warszawa', '01-234'),
       (2, 'ul. Słoneczna 2', 'Kraków', '12-345'),
       (3, 'ul. Zielona 3', 'Gdańsk', '23-456');

-- Dodawanie danych do tabeli pracownicy
INSERT INTO `tabela_pracownik` (id, first_name, last_name, dep_id, address_id)
VALUES (1, 'Jan', 'Kowalski', 1, 1),
       (2, 'Anna', 'Nowak', 2, 2),
       (3, 'Piotr', 'Wiśniewski', 3, 3);

-- Pobiera pełne informacje o pracowniku (imię, nazwisko, adres, stanowisko)
SELECT first_name, last_name, street_and_number, tabela_adresow.city, department_name FROM tabela_pracownik, tabela_adresow, tabela_stanowiska
WHERE tabela_pracownik.id = '1' limit 1;

-- Oblicza sumę wypłat dla wszystkich pracowników w firmie
SELECT sum(salary) FROM tabela_stanowiska;

-- Pobiera pracowników mieszkających w lokalizacji z kodem pocztowym 90210 (albo innym, który będzie miał sens dla Twoich danych testowych)
SELECT count(*) FROM tabela_adresow WHERE tabela_adresow.zip_code = '01-234';