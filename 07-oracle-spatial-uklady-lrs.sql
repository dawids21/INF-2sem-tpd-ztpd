-- cw 1
-- zad a
create table a6_lrs
(
    geom sdo_geometry
);

-- zad b
insert into a6_lrs
select geom
from streets_and_railroads sar
where sar.id = (with koszalin_geom as (select geom
                                       from major_cities
                                       where city_name = 'Koszalin')
                select sar1.id
                from streets_and_railroads sar1,
                     koszalin_geom kg
                where sdo_relate(sar1.geom,
                                 sdo_geom.sdo_buffer(kg.geom, 10, 1, 'unit=km'),
                                 'MASK=ANYINTERACT') = 'TRUE');

-- zad c
select sdo_geom.sdo_length(geom, 1, 'unit=km') as distance,
       st_linestring(geom).st_numpoints()         st_numpoints
from a6_lrs;

-- zad d
update a6_lrs
set geom = sdo_lrs.convert_to_lrs_geom(geom, 0, sdo_geom.sdo_length(geom, 1, 'unit=km'));

-- zad e
insert into user_sdo_geom_metadata
values ('A6_LRS', 'GEOM',
        mdsys.sdo_dim_array(
                mdsys.sdo_dim_element('X', 12.603676, 26.369824, 1),
                mdsys.sdo_dim_element('Y', 45.8464, 58.0213, 1),
                mdsys.sdo_dim_element('M', 0, 300, 1)),
        8307);

-- zad f
create index a6_lrs_geom_idx
    on a6_lrs (geom) indextype is mdsys.spatial_index_v2;

-- cw 2
-- zad a
select sdo_lrs.valid_measure(geom, 500) as valid_500
from a6_lrs;

-- zad b
select sdo_lrs.geom_segment_end_pt(geom) as end_pt
from a6_lrs;

-- zad c
select sdo_lrs.locate_pt(geom, 150) as km150
from a6_lrs;

-- zad d
select sdo_lrs.clip_geom_segment(geom, 120, 160) as cliped
from a6_lrs;

-- zad e
select sdo_lrs.get_next_shape_pt(
               a6.geom,
               sdo_lrs.project_pt(a6.geom, c.geom)) as wjazd_na_a6
from a6_lrs a6,
     major_cities c
where c.city_name = 'Slupsk';

-- zad f
select sdo_geom.sdo_length(
               sdo_lrs.offset_geom_segment(
                       a6.geom, m.diminfo, 50,
                       200, 50,'unit=m arc_tolerance=0,05'
               ), 1, 'unit=km'
       ) as koszt
from a6_lrs a6,
     user_sdo_geom_metadata m
where m.table_name = 'A6_LRS'
  and m.column_name = 'GEOM';
