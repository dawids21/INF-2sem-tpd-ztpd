-- cw 1
-- zad a
select lpad('-', 2 * (level - 1), '|-') || t.owner || '.' || t.type_name || ' (FINAL:' || t.final ||
       ', INSTANTIABLE:' || t.instantiable || ', ATTRIBUTES:' || t.attributes || ', METHODS:' || t.methods || ')'
from all_types t
start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name
       and prior t.owner = t.owner;

-- zad b
select distinct m.method_name
from all_type_methods m
where m.type_name like 'ST_POLYGON'
  and m.owner = 'MDSYS'
order by 1;

-- zad c
create table myst_major_cities
(
    fips_cntry varchar2(2),
    city_name  varchar2(40),
    stgeom     st_point
);

-- zad d
insert into myst_major_cities
select fips_cntry, city_name, st_point(geom) as stgeom
from ztpd.major_cities;

-- cw 2
-- zad a
select mcb.stgeom.st_srid() as srid
from myst_country_boundaries mcb
fetch first row only;
insert into myst_major_cities
values ('PL', 'Szczyrk', st_point(19.036107, 49.718655, 8307));

-- cw 3
-- zad a
create table myst_country_boundaries
(
    fips_cntry varchar2(2),
    cntry_name varchar2(40),
    stgeom     st_multipolygon
);

-- zad b
insert into myst_country_boundaries
select fips_cntry, cntry_name, st_multipolygon(geom) as stgeom
from ztpd.country_boundaries;

-- zad c
select mcb.stgeom.st_geometrytype() as typ_obiektu,
       count(*)                     as ile
from myst_country_boundaries mcb
group by mcb.stgeom.st_geometrytype();

-- zad d
select mcb.stgeom.st_issimple()
from myst_country_boundaries mcb;

-- cw 4
-- zad a
select mcb.cntry_name, count(*)
from myst_country_boundaries mcb,
     myst_major_cities mmc
where mcb.stgeom.st_contains(mmc.stgeom) = 1
group by mcb.cntry_name;

-- zad b
with czech_geom as (select cntry_name, stgeom
                    from myst_country_boundaries
                    where cntry_name = 'Czech Republic')
select mcb.cntry_name as a_name, cg.cntry_name as b_name
from myst_country_boundaries mcb,
     czech_geom cg
where cg.stgeom.st_touches(mcb.stgeom) = 1;

-- zad c
select distinct mcb.cntry_name, r.name
from myst_country_boundaries mcb,
     rivers r
where mcb.stgeom.st_crosses(st_linestring(r.geom)) = 1
  and mcb.cntry_name = 'Czech Republic';

-- zad d
with czech_geom as (select cntry_name, stgeom
                    from myst_country_boundaries
                    where cntry_name = 'Czech Republic'),
     slovakia_geom as (select cntry_name, stgeom
                       from myst_country_boundaries
                       where cntry_name = 'Slovakia')
select treat(cg.stgeom.st_union(sg.stgeom) as st_polygon).st_area()
from czech_geom cg,
     slovakia_geom sg;

-- zad e
with hungary_geom as (select stgeom
                      from myst_country_boundaries
                      where cntry_name = 'Hungary'),
     balaton_geom as (select geom
                      from water_bodies
                      where name = 'Balaton')
select hg.stgeom.st_difference(st_geometry(bg.geom))                   as obiekt,
       hg.stgeom.st_difference(st_geometry(bg.geom)).st_geometrytype() as wegry_bez
from hungary_geom hg,
     balaton_geom bg;

-- cw 5
-- zad a
select mcb.cntry_name, count(*)
from myst_country_boundaries mcb,
     myst_major_cities mmc
where sdo_within_distance(mmc.stgeom, mcb.stgeom, 'distance=100 unit=km') = 'TRUE'
  and mcb.cntry_name = 'Poland'
group by mcb.cntry_name;

explain plan for
select mcb.cntry_name, count(*)
from myst_country_boundaries mcb,
     myst_major_cities mmc
where sdo_within_distance(mmc.stgeom, mcb.stgeom, 'distance=100 unit=km') = 'TRUE'
  and mcb.cntry_name = 'Poland'
group by mcb.cntry_name;

select *
from table (dbms_xplan.display);

-- zad b
insert into user_sdo_geom_metadata
select 'MYST_COUNTRY_BOUNDARIES',
       'STGEOM',
       diminfo,
       srid
from all_sdo_geom_metadata
where table_name = 'COUNTRY_BOUNDARIES';

insert into user_sdo_geom_metadata
select 'MYST_MAJOR_CITIES',
       'STGEOM',
       diminfo,
       srid
from all_sdo_geom_metadata
where table_name = 'MAJOR_CITIES';

-- zad c
create index myst_country_boundaries_stgeom_idx
    on myst_country_boundaries (stgeom) indextype is mdsys.spatial_index_v2;
create index myst_major_cities_stgeom_idx
    on myst_major_cities (stgeom) indextype is mdsys.spatial_index_v2;

-- zad d
select mcb.cntry_name, count(*)
from myst_country_boundaries mcb,
     myst_major_cities mmc
where sdo_within_distance(mmc.stgeom, mcb.stgeom, 'distance=100 unit=km') = 'TRUE'
  and mcb.cntry_name = 'Poland'
group by mcb.cntry_name;

explain plan for
select mcb.cntry_name, count(*)
from myst_country_boundaries mcb,
     myst_major_cities mmc
where sdo_within_distance(mmc.stgeom, mcb.stgeom, 'distance=100 unit=km') = 'TRUE'
  and mcb.cntry_name = 'Poland'
group by mcb.cntry_name;

select *
from table (dbms_xplan.display);
