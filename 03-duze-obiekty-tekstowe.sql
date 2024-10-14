-- zad 1
create table dokumenty
(
    id       number(12) primary key,
    dokument clob
);

-- zad 2
declare
    doc clob;
begin
    doc := empty_clob();
    for i in 1..10000
        loop
            doc := doc || 'Oto tekst. ';
        end loop;
    insert into dokumenty (id, dokument) values (1, doc);
    commit;
end;
/

-- zad 3
select *
from dokumenty;

select id, upper(dokument)
from dokumenty;

select id, length(dokument)
from dokumenty;

select id, dbms_lob.getlength(dokument)
from dokumenty;

select id, substr(dokument, 5, 1000)
from dokumenty;

select id, dbms_lob.substr(dokument, 1000, 5)
from dokumenty;

-- zad 4
insert into dokumenty (id, dokument)
values (2, empty_clob());

-- zad 5
insert into dokumenty (id, dokument)
values (3, null);
commit;

-- zad 6
select *
from dokumenty;

select id, upper(dokument)
from dokumenty;

select id, length(dokument)
from dokumenty;

select id, dbms_lob.getlength(dokument)
from dokumenty;

select id, substr(dokument, 5, 1000)
from dokumenty;

select id, dbms_lob.substr(dokument, 1000, 5)
from dokumenty;

-- zad 7
declare
    text_file bfile   := bfilename('TPD_DIR', 'dokument.txt');
    lobd      clob;
    doffset   integer := 1;
    soffset   integer := 1;
    langctx   integer := 0;
    warn      integer := null;
begin
    select dokument
    into lobd
    from dokumenty
    where id = 2
        for update;
    dbms_lob.fileopen(text_file, dbms_lob.file_readonly);
    dbms_lob.loadclobfromfile(lobd, text_file, dbms_lob.getlength(text_file),
                              doffset, soffset, 0, langctx, warn);
    dbms_lob.fileclose(text_file);
    commit;
    dbms_output.put_line('Status operacji: ' || warn);
end;
/

-- zad 8
update dokumenty
set dokument = to_clob(bfilename('TPD_DIR', 'dokument.txt'))
where id = 3;

-- zad 9
select *
from dokumenty;

-- zad 10
select id, dbms_lob.getlength(dokument)
from dokumenty;

-- zad 11
drop table dokumenty;

-- zad 12
create or replace procedure clob_censor(
    doc in out clob,
    to_replace in varchar2
) is
    position integer := 1;
    to_replace_len integer := length(to_replace);
    dots clob    := rpad('.', to_replace_len, '.');
begin
    loop
        position := instr(doc, to_replace, position);

        exit when position = 0;

        dbms_lob.write(doc, to_replace_len, position, dots);

        position := position + to_replace_len;
    end loop;
end;
/

-- zad 13
create table biographies
as select * from ztpd.biographies;

declare
    v_bio clob;
begin
    select bio
    into v_bio
    from biographies
    where id = 1
        for update;
    clob_censor(v_bio, 'Cimrman');
    update biographies
    set bio = v_bio
    where id = 1;
    commit;
end;
/

select *
from biographies;

-- zad 14
drop table biographies;
