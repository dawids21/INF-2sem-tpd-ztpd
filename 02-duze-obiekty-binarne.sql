-- zad 1
create table movies_copy as
select *
from ztpd.movies;

-- zad 2
select *
from movies_copy;

-- zad 3
select *
from movies_copy
where cover is null;

-- zad 4
select id, title, dbms_lob.getlength(cover) as cover_size
from movies_copy
where cover is not null;

-- zad 5
select id, title, dbms_lob.getlength(cover) as cover_size
from movies_copy
where cover is null;

-- zad 6
select directory_name, directory_path
from all_directories;
-- /u01/app/oracle/oradata/DBLAB03/directories/tpd_dir

-- zad 7
update movies_copy
set cover     = empty_blob(),
    mime_type = 'image/jpeg'
where id = 66;

-- zad 8
select id, title, dbms_lob.getlength(cover)
from movies_copy
where id in (65, 66);

-- zad 9
declare
    lobd  blob;
    cover bfile := bfilename('TPD_DIR', 'escape.jpg');
begin
    select cover
    into lobd
    from movies_copy
    where id = 66
        for update;
    dbms_lob.fileopen(cover, dbms_lob.file_readonly);
    dbms_lob.loadfromfile(lobd, cover, dbms_lob.getlength(cover));
    dbms_lob.fileclose(cover);
    commit;
end;
/

-- zad 10
create table temp_covers
(
    movie_id number(12),
    image bfile,
    mime_type varchar2(50)
);

-- zad 11
insert into temp_covers
values (65, bfilename('TPD_DIR', 'eagles.jpg'), 'image/jpeg');

-- zad 12
select movie_id, dbms_lob.getlength(image)
from temp_covers;

-- zad 13
declare
    lobd  blob;
    image bfile;
    mime_type varchar2(50);
begin
    select image, mime_type
    into image, mime_type
    from temp_covers
    where movie_id = 65;
    dbms_lob.createtemporary(lobd, true);
    dbms_lob.fileopen(image, dbms_lob.file_readonly);
    dbms_lob.loadfromfile(lobd, image, dbms_lob.getlength(image));
    dbms_lob.fileclose(image);
    update movies_copy
    set cover = lobd
    where id = 65;
    dbms_lob.freetemporary(lobd);
    commit;
end;
/

-- zad 14
select id, dbms_lob.getlength(cover)
from movies_copy
where id in (65, 66);

-- zad 15
drop table temp_covers;
drop table movies_copy;