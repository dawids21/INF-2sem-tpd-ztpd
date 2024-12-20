-- Operator CONTAINS - Podstawy
-- zad 1
create table cytaty as
select *
from ztpd.cytaty;

-- zad 2
select *
from cytaty
where lower(tekst) like '%optymista%'
  and lower(tekst) like '%pesymista%';

-- zad 3
create index cytaty_tekst_idx on cytaty (tekst)
    indextype is CTXSYS.CONTEXT;

-- zad 4
select *
from cytaty
where contains(tekst, 'optymista and pesymista') > 0;

-- zad 5
select *
from cytaty
where contains(tekst, 'pesymista not optymista') > 0;

-- zad 6
select *
from cytaty
where contains(tekst, 'near((pesymista, optymista), 3)') > 0;

-- zad 7
select *
from cytaty
where contains(tekst, 'near((pesymista, optymista), 10)') > 0;

-- zad 8
select *
from cytaty
where contains(tekst, 'życi%') > 0;

-- zad 9
select id, autor, tekst, score(1) as score
from cytaty
where contains(tekst, 'życi%', 1) > 0;

-- zad 10
select id, autor, tekst, score(1) as score
from cytaty
where contains(tekst, 'życi%', 1) > 0
order by score desc
    fetch first row only;

-- zad 11
select *
from cytaty
where contains(tekst, 'fuzzy(probelm)') > 0;

-- zad 12
insert into cytaty
values (100, 'Bertrand Russell',
        'To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwości.');
commit;

-- zad 13
select *
from cytaty
where contains(tekst, 'głupcy') > 0;
-- brak wyniku, ponieważ słowo "głupcy" nie jest w indeksie

-- zad 14
select token_text
from DR$CYTATY_TEKST_IDX$I;
select token_text
from DR$CYTATY_TEKST_IDX$I
where lower(token_text) = 'głupcy';

-- zad 15
drop index cytaty_tekst_idx;
create index cytaty_tekst_idx on cytaty (tekst)
    indextype is CTXSYS.CONTEXT;

-- zad 16
select token_text
from DR$CYTATY_TEKST_IDX$I
where lower(token_text) = 'głupcy';
select *
from cytaty
where contains(tekst, 'głupcy') > 0;

-- zad 17
drop index cytaty_tekst_idx;
drop table cytaty;

-- Zaawansowane indeksowanie i wyszukiwanie
-- zad 1
create table quotes as
select *
from ztpd.quotes;

-- zad 2
create index quotes_text_idx on quotes (text)
    indextype is CTXSYS.CONTEXT;

-- zad 3
select *
from quotes
where contains(text, 'work') > 0;
select *
from quotes
where contains(text, '$work') > 0;
select *
from quotes
where contains(text, 'working') > 0;
select *
from quotes
where contains(text, '$working') > 0;

-- zad 4
select *
from quotes
where contains(text, 'it') > 0;
-- brak wyniku, ponieważ słowo "it" jest stopwordem

-- zad 5
select *
from ctx_stoplists;
-- system wykorzystuje DEFAULT_STOPLIST

-- zad 6
select *
from ctx_stopwords
where spw_stoplist = 'DEFAULT_STOPLIST';

-- zad 7
drop index quotes_text_idx;
create index quotes_text_idx on quotes (text)
    indextype is CTXSYS.CONTEXT
    parameters ('stoplist CTXSYS.EMPTY_STOPLIST');

-- zad 8
select *
from quotes
where contains(text, 'it') > 0;
-- zwraca wyniki

-- zad 9
select *
from quotes
where contains(text, 'fool and humans') > 0;

--zad 10
select *
from quotes
where contains(text, 'fool and computer') > 0;

-- zad 11
select *
from quotes
where contains(text, '(fool and humans) within sentence') > 0;
-- error, ponieważ nie są utworzone sekcje sentence

-- zad 12
drop index quotes_text_idx;

-- zad 13
begin
    ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
    ctx_ddl.add_special_section('nullgroup', 'SENTENCE');
    ctx_ddl.add_special_section('nullgroup', 'PARAGRAPH');
end;
/

-- zad 14
create index quotes_text_idx on quotes (text)
    indextype is CTXSYS.CONTEXT
    parameters ('section group nullgroup');

-- zad 15
select *
from quotes
where contains(text, '(fool and humans) within sentence') > 0;
select *
from quotes
where contains(text, '(fool and computer) within sentence') > 0;
-- działają poprawnie

-- zad 16
select *
from quotes
where contains(text, 'humans') > 0;
-- tak, ponieważ myślnik jest traktowany jako przerwa

-- zad 17
drop index quotes_text_idx;
begin
    ctx_ddl.create_preference('lex_z_m','BASIC_LEXER');
    ctx_ddl.set_attribute('lex_z_m',
                          'printjoins', '_-');
    ctx_ddl.set_attribute ('lex_z_m',
                           'index_text', 'YES');
end;
/
create index quotes_text_idx on quotes (text)
    indextype is CTXSYS.CONTEXT
    parameters ('lexer lex_z_m');

-- zad 18
select *
from quotes
where contains(text, 'humans') > 0;
-- nie

-- zad 19
select *
from quotes
where contains(text, 'non\-humans') > 0;

-- zad 20
drop index quotes_text_idx;
drop table quotes;
begin
    ctx_ddl.drop_preference('lex_z_m');
    ctx_ddl.drop_section_group('nullgroup');
end;
