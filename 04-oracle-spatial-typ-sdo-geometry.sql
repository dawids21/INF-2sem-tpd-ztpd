-- zad a
create table figury
(
    id      number(12) primary key,
    ksztalt mdsys.sdo_geometry
);

-- zad b
insert into figury
values (1,
        mdsys.sdo_geometry(
                2003,
                null,
                null,
                mdsys.sdo_elem_info_array(1, 1003, 4),
                mdsys.sdo_ordinate_array(7, 5, 5, 7, 3, 5)));
                
insert into figury
values (2,
        mdsys.sdo_geometry(
                2003,
                null,
                null,
                mdsys.sdo_elem_info_array(1, 1003, 3),
                mdsys.sdo_ordinate_array(1, 1, 5, 5)));
                
insert into figury
values (3,
        mdsys.sdo_geometry(
                2002,
                null,
                null,
                mdsys.sdo_elem_info_array(1, 4, 3, 1, 2, 1, 3, 2, 1, 5, 2, 2),
                mdsys.sdo_ordinate_array(3, 2, 6, 2, 7, 3, 8, 2, 7, 1)));
                
-- zad c
insert into figury
values (4,
        mdsys.sdo_geometry(
                2003,
                null,
                null,
                mdsys.sdo_elem_info_array(1, 1003, 4),
                mdsys.sdo_ordinate_array(3, 3, 2, 2, 1, 1)));

-- zad d
select id, sdo_geom.validate_geometry_with_context(ksztalt, 0.01)
from figury;

-- zad e
delete from figury
where sdo_geom.validate_geometry_with_context(ksztalt, 0.01) != 'TRUE';