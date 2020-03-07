--FUNCTIONS
--a) UczestnicyWycieczki (id_wycieczki)
CREATE OR REPLACE FUNCTION UCZESTNICY_WYCIECZKI(id INT)
    RETURN UCZESTNICY_WYCIECZKI_TABELA AS uczestnicy UCZESTNICY_WYCIECZKI_TABELA;
    istnieje INT;
    BEGIN
        SELECT COUNT(*) INTO istnieje
        FROM WYCIECZKI
        WHERE WYCIECZKI.ID_WYCIECZKI = id;

        IF istnieje = 0 THEN
            RAISE_APPLICATION_ERROR(-20000, 'Wycieczka o podanym ID nie istnieje');
        END IF;

        SELECT UCZESTNIK_WYCIECZKI(w.NAZWA, w.KRAJ, w.DATA, o.IMIE, o.NAZWISKO, r.STATUS)
            BULK COLLECT INTO uczestnicy
        FROM WYCIECZKI w
            JOIN REZERWACJE r
            ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
            JOIN OSOBY o
            ON r.ID_OSOBY = o.ID_OSOBY
        WHERE w.ID_WYCIECZKI = id AND r.STATUS <> 'A';

        RETURN uczestnicy;
    END;

SELECT * FROM UCZESTNICY_WYCIECZKI(1);

--b) RezerwacjeOsoby(id_osoby)
CREATE OR REPLACE FUNCTION REZERWACJE_OSOBY(id INT)
    RETURN UCZESTNICY_WYCIECZKI_TABELA AS rezerwacje UCZESTNICY_WYCIECZKI_TABELA;
    istnieje INT;
    BEGIN
        SELECT COUNT(*) INTO istnieje
        FROM OSOBY
        WHERE OSOBY.ID_OSOBY = id;

        IF istnieje = 0 THEN
            RAISE_APPLICATION_ERROR(-20000, 'Osoba o podanym ID nie istnieje');
        END IF;

        SELECT UCZESTNIK_WYCIECZKI(w.NAZWA, w.KRAJ, w.DATA, o.IMIE, o.NAZWISKO, r.STATUS)
            BULK COLLECT INTO rezerwacje
        FROM WYCIECZKI w
            JOIN REZERWACJE r
            ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
            JOIN OSOBY o
            ON r.ID_OSOBY = o.ID_OSOBY
        WHERE o.ID_OSOBY = id;
        RETURN REZERWACJE;
    END;

SELECT * FROM REZERWACJE_OSOBY(1);

--c) DostepneWycieczki(kraj, data_od, data_do)
CREATE OR REPLACE FUNCTION DOSTEPNE_WYCIECZKI(kraj WYCIECZKI.KRAJ%TYPE)
    RETURN WYCIECZKI_TABELA AS wycieczki WYCIECZKI_TABELA;
    BEGIN
        SELECT WYCIECZKA(w.NAZWA, w.KRAJ, w.DATA, w.OPIS, w.LICZBA_MIEJSC)
        BULK COLLECT INTO wycieczki
        FROM WYCIECZKI w
        WHERE DOSTEPNE_WYCIECZKI.kraj LIKE w.KRAJ AND w.DATA > CURRENT_DATE AND
              w.LICZBA_MIEJSC > (SELECT COUNT(*)
                                 FROM REZERWACJE r
                                 WHERE r.STATUS <> 'A' AND r.ID_WYCIECZKI = w.ID_WYCIECZKI);
        RETURN wycieczki;
    END;

SELECT * FROM DOSTEPNE_WYCIECZKI('Rosja');
