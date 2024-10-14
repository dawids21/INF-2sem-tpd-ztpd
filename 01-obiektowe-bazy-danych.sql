-- zad 1
create type samochod as object
(
    marka          varchar2(20),
    model          varchar2(20),
    kilometry      number,
    data_produkcji date,
    cena           number(10, 2)
);


desc samochod;

create table samochody of samochod;

insert into samochody
values (new samochod('Fiat', 'Brava', 60000, to_date('1999-11-30', 'yyyy-mm-dd'), 25000));
insert into samochody
values (new samochod('Ford', 'Mondeo', 80000, to_date('1997-05-10', 'yyyy-mm-dd'), 45000));
insert into samochody
values (new samochod('Mazda', '323', 12000, to_date('2000-09-22', 'yyyy-mm-dd'), 52000));

select *
from samochody;

-- zad 2
create table wlasciciele
(
    imie     varchar2(20),
    nazwisko varchar2(20),
    auto     samochod
);

insert into wlasciciele
values ('Jan', 'Kowalski', new samochod('Fiat', 'Seicento', 30000, to_date('0010-12-02', 'yyyy-mm-dd'), 19500));
insert into wlasciciele
values ('Adam', 'Nowak', new samochod('Opel', 'Astra', 34000, to_date('0009-06-01', 'yyyy-mm-dd'), 33700));

select *
from wlasciciele;

-- zad 3
alter type samochod replace as object (
    marka varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produkcji date,
    cena number(10, 2),
    member function wartosc return number
    );

create or replace type body samochod as
    member function wartosc return number is
        years         number;
        current_value number;
    begin
        years := extract(year from sysdate) - extract(year from self.data_produkcji);
        current_value := self.cena * power(0.9, years);
        return current_value;
    end;
end;

select s.marka, s.cena, s.wartosc()
from samochody s;

-- zad 4
alter type samochod add map member function odwzoruj
    return number cascade including table data;

create or replace type body samochod as
    member function wartosc return number is
        years         number;
        current_value number;
    begin
        years := extract(year from sysdate) - extract(year from self.data_produkcji);
        current_value := self.cena * power(0.9, years);
        return current_value;
    end;

    map member function odwzoruj return number is
    begin
        return extract(year from sysdate) - extract(year from self.data_produkcji) + self.kilometry / 10000;
    end;
end;

select *
from samochody s
order by value(s);

-- zad 5
create type wlasciciel as object
(
    imie     varchar2(20),
    nazwisko varchar2(20)
);

drop table wlasciciele;
create table wlasciciele of wlasciciel;

insert into wlasciciele
values (new wlasciciel('Jan', 'Kowalski'));
insert into wlasciciele
values (new wlasciciel('Adam', 'Nowak'));

select *
from wlasciciele;

alter type samochod add attribute wlasciciel_auta ref wlasciciel cascade;

update samochody
set wlasciciel_auta = (select ref(w) from wlasciciele w where w.imie = 'Jan' and w.nazwisko = 'Kowalski')
where marka = 'Fiat'
  and model = 'Brava';

select marka, model, deref(wlasciciel_auta)
from samochody;

-- zad 6
DECLARE
    TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
    moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
    moje_przedmioty(1) := 'MATEMATYKA';
    moje_przedmioty.EXTEND(9);
    FOR i IN 2..10
        LOOP
            moje_przedmioty(i) := 'PRZEDMIOT_' || i;
        END LOOP;
    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST()
        LOOP
            DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
        END LOOP;
    moje_przedmioty.TRIM(2);
    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST()
        LOOP
            DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
    moje_przedmioty.EXTEND();
    moje_przedmioty(9) := 9;
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
    moje_przedmioty.DELETE();
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

-- zad 7
declare
    type t_ksiazki is varray(10) of varchar2(20);
    moje_ksiazki t_ksiazki := t_ksiazki('');
begin
    moje_ksiazki.extend(9);
    for i in 1..10
        loop
            moje_ksiazki(i) := 'book ' || i;
        end loop;
    for i in moje_ksiazki.first()..moje_ksiazki.last()
        loop
            dbms_output.put_line(moje_ksiazki(i));
        end loop;
    moje_ksiazki.trim(3);
    for i in moje_ksiazki.first()..moje_ksiazki.last()
        loop
            dbms_output.put_line(moje_ksiazki(i));
        end loop;
    moje_ksiazki(4) := 'book 4 changed';
    for i in moje_ksiazki.first()..moje_ksiazki.last()
        loop
            dbms_output.put_line(moje_ksiazki(i));
        end loop;
end;

-- zad 8
DECLARE
    TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
    moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
    moi_wykladowcy.EXTEND(2);
    moi_wykladowcy(1) := 'MORZY';
    moi_wykladowcy(2) := 'WOJCIECHOWSKI';
    moi_wykladowcy.EXTEND(8);
    FOR i IN 3..10
        LOOP
            moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
        END LOOP;
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST()
        LOOP
            DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
        END LOOP;
    moi_wykladowcy.TRIM(2);
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST()
        LOOP
            DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
        END LOOP;
    moi_wykladowcy.DELETE(5, 7);
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST()
        LOOP
            IF moi_wykladowcy.EXISTS(i) THEN
                DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
            END IF;
        END LOOP;
    moi_wykladowcy(5) := 'ZAKRZEWICZ';
    moi_wykladowcy(6) := 'KROLIKOWSKI';
    moi_wykladowcy(7) := 'KOSZLAJDA';
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST()
        LOOP
            IF moi_wykladowcy.EXISTS(i) THEN
                DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
            END IF;
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

-- zad 9
declare
    type t_miesiace is table of varchar2(20);
    moje_miesiace t_miesiace := t_miesiace();
begin
    moje_miesiace.extend(12);
    moje_miesiace(1) := 'STYCZEN';
    moje_miesiace(2) := 'LUTY';
    moje_miesiace(3) := 'MARZEC';
    moje_miesiace(4) := 'KWIECIEN';
    moje_miesiace(5) := 'MAJ';
    moje_miesiace(6) := 'CZERWIEC';
    moje_miesiace(7) := 'LIPIEC';
    moje_miesiace(8) := 'SIERPIEN';
    moje_miesiace(9) := 'WRZESIEN';
    moje_miesiace(10) := 'PAZDZIERNIK';
    moje_miesiace(11) := 'LISTOPAD';
    moje_miesiace(12) := 'GRUDZIEN';
    for i in moje_miesiace.first()..moje_miesiace.last()
        loop
            if moje_miesiace.exists(i) then
                dbms_output.put_line(moje_miesiace(i));
            end if;
        end loop;
    moje_miesiace.delete(2, 4);
    for i in moje_miesiace.first()..moje_miesiace.last()
        loop
            if moje_miesiace.exists(i) then
                dbms_output.put_line(moje_miesiace(i));
            end if;
        end loop;
end;

-- zad 10
CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/

CREATE TYPE stypendium AS OBJECT
(
    nazwa  VARCHAR2(50),
    kraj   VARCHAR2(30),
    jezyki jezyki_obce
);
/

CREATE TABLE stypendia OF stypendium;

INSERT INTO stypendia
VALUES ('SOKRATES', 'FRANCJA', jezyki_obce('ANGIELSKI', 'FRANCUSKI', 'NIEMIECKI'));
INSERT INTO stypendia
VALUES ('ERASMUS', 'NIEMCY', jezyki_obce('ANGIELSKI', 'NIEMIECKI', 'HISZPANSKI'));

SELECT *
FROM stypendia;

SELECT s.jezyki
FROM stypendia s;

UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI', 'NIEMIECKI', 'HISZPANSKI', 'FRANCUSKI')
WHERE nazwa = 'ERASMUS';

CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/

CREATE TYPE semestr AS OBJECT
(
    numer    NUMBER,
    egzaminy lista_egzaminow
);
/

CREATE TABLE semestry OF semestr
    NESTED TABLE egzaminy STORE AS tab_egzaminy;

INSERT INTO semestry
VALUES (semestr(1, lista_egzaminow('MATEMATYKA', 'LOGIKA', 'ALGEBRA')));
INSERT INTO semestry
VALUES (semestr(2, lista_egzaminow('BAZY DANYCH', 'SYSTEMY OPERACYJNE')));

SELECT s.numer, e.*
FROM semestry s,
     TABLE (s.egzaminy) e;

SELECT e.*
FROM semestry s,
     TABLE ( s.egzaminy ) e;

SELECT *
FROM TABLE (SELECT s.egzaminy FROM semestry s WHERE numer = 1);

INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer = 2 )
VALUES ('METODY NUMERYCZNE');

UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer = 2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';

DELETE
FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer = 2 ) e
WHERE e.column_value = 'BAZY DANYCH';

-- zad 11
create type koszyk as table of varchar2(20);

create type zakup as object
(
    id               number,
    koszyk_produktow koszyk
);

create table zakupy of zakup
    nested table koszyk_produktow store as tab_koszyk;

insert into zakupy
values (1, koszyk('awokado', 'maslo', 'mleko', 'jogurt'));
insert into zakupy
values (2, koszyk('mleko', 'jogurt', 'ser', 'maslo'));
insert into zakupy
values (3, koszyk('awokado', 'mleko', 'jogurt', 'maslo'));

select *
from zakupy;

delete
from zakupy
where 'awokado' member of koszyk_produktow;

select *
from zakupy;

-- zad 12
CREATE TYPE instrument AS OBJECT
(
    nazwa  VARCHAR2(20),
    dzwiek VARCHAR2(20),
    MEMBER FUNCTION graj RETURN VARCHAR2
) NOT FINAL;

CREATE TYPE BODY instrument AS
    MEMBER FUNCTION graj RETURN VARCHAR2 IS
    BEGIN
        RETURN dzwiek;
    END;
END;
/

CREATE TYPE instrument_dety UNDER instrument
(
    material VARCHAR2(20),
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
    MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2
);

CREATE OR REPLACE TYPE BODY instrument_dety AS
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
    BEGIN
        RETURN 'dmucham: ' || dzwiek;
    END;
    MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN glosnosc || ':' || dzwiek;
    END;
END;
/
CREATE TYPE instrument_klawiszowy UNDER instrument
(
    producent VARCHAR2(20),
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2
);
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
    BEGIN
        RETURN 'stukam w klawisze: ' || dzwiek;
    END;
END;
/
DECLARE
    tamburyn  instrument            := instrument('tamburyn', 'brzdek-brzdek');
    trabka    instrument_dety       := instrument_dety('trabka', 'tra-ta-ta', 'metalowa');
    fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian', 'pingping', 'steinway');
BEGIN
    dbms_output.put_line(tamburyn.graj);
    dbms_output.put_line(trabka.graj);
    dbms_output.put_line(trabka.graj('glosno'));
    dbms_output.put_line(fortepian.graj);
END;

-- zad 13
CREATE TYPE istota AS OBJECT
(
    nazwa VARCHAR2(20),
    NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR
)
    NOT INSTANTIABLE NOT FINAL;

CREATE TYPE lew UNDER istota
(
    liczba_nog NUMBER,
    OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR
);

CREATE OR REPLACE TYPE BODY lew AS
    OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
    BEGIN
        RETURN 'upolowana ofiara: ' || ofiara;
    END;
END;

DECLARE
    KrolLew lew := lew('LEW', 4);
--     InnaIstota istota := istota('JAKIES ZWIERZE');
BEGIN
    DBMS_OUTPUT.PUT_LINE(KrolLew.poluj('antylopa'));
END;

-- zad 14
DECLARE
    tamburyn instrument;
    cymbalki instrument;
    trabka   instrument_dety;
    saksofon instrument_dety;
BEGIN
    tamburyn := instrument('tamburyn', 'brzdek-brzdek');
    cymbalki := instrument_dety('cymbalki', 'ding-ding', 'metalowe');
    trabka := instrument_dety('trabka', 'tra-ta-ta', 'metalowa');
    --     saksofon := instrument('saksofon','tra-taaaa');
--     saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;

-- zad 15
CREATE TABLE instrumenty OF instrument;

INSERT INTO instrumenty
VALUES (instrument('tamburyn', 'brzdek-brzdek'));

INSERT INTO instrumenty
VALUES (instrument_dety('trabka', 'tra-ta-ta', 'metalowa'));

INSERT INTO instrumenty
VALUES (instrument_klawiszowy('fortepian', 'pingping', 'steinway'));

SELECT i.nazwa, i.graj()
FROM instrumenty i;