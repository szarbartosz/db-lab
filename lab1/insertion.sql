--Inserting into tables
INSERT INTO OSOBY(IMIE, NAZWISKO, PESEL, KONTAKT)
VALUES('imie', 'nazwisko', '99112211777', '123456789');
SELECT * FROM OSOBY;

INSERT INTO WYCIECZKI(NAZWA, KRAJ, DATA, OPIS, LICZBA_MIEJSC)
VALUES('nazwa', 'kraj', 'yyyy-mm-dd', 20);
SELECT * FROM WYCIECZKI;

INSERT INTO REZERWACJE (ID_WYCIECZKI, ID_OSOBY, STATUS)
VALUES(1,1,'A');
SELECT * FROM REZERWACJE;