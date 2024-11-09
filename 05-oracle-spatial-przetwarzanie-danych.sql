-- cw 1
-- zad a
insert into user_sdo_geom_metadata
values ('FIGURY',
        'KSZTALT',
        mdsys.sdo_dim_array(
                mdsys.sdo_dim_element('X', 0, 10, 0.01),
                mdsys.sdo_dim_element('Y', 0, 10, 0.01)),
        null);

-- zad b
select sdo_tune.estimate_rtree_index_size(3000000, 8192, 10, 2, 0)
from dual;

-- zad c
create index figury_ksztalt_idx
    on figury (ksztalt) INDEXTYPE is MDSYS.SPATIAL_INDEX_V2;

-- zad d
select id
from figury
where sdo_filter(
              ksztalt,
              sdo_geometry(2001, null, sdo_point_type(3, 3, null), null, null)
      ) = 'TRUE';
-- nie jest to prawda, wykorzystywane jedynie przyblizenie na podstawie indeksu

-- zad e
select id
from figury
where sdo_relate(
              ksztalt,
              sdo_geometry(2001, null, sdo_point_type(3, 3, null), null, null),
              'mask=ANYINTERACT'
      ) = 'TRUE';
-- to jest prawda, z przyblizen za pomoca metod dokladnych zostal wyznaczony punkt

-- cw 2
-- zad a
with warsaw_geom as (select geom
                     from major_cities
                     where city_name = 'Warsaw')
select mc.city_name as miasto, sdo_nn_distance(1) as odl
from major_cities mc,
     warsaw_geom wg
where sdo_nn(
              mc.geom,
              wg.geom,
              'sdo_num_res=9 unit=km',
              1
      ) = 'TRUE'
  and mc.city_name != 'Warsaw';

-- zad b
with warsaw_geom as (select geom
                     from major_cities
                     where city_name = 'Warsaw')
select mc.city_name as miasto
from major_cities mc,
     warsaw_geom wg
where sdo_within_distance(
              mc.geom,
              wg.geom,
              'distance=100 unit=km'
      ) = 'TRUE'
  and mc.city_name != 'Warsaw';

-- zad c
with slovakia_geom as (select cntry_name, geom
                       from country_boundaries
                       where cntry_name = 'Slovakia')
select sg.cntry_name as kraj, mc.city_name as miasto
from major_cities mc,
     slovakia_geom sg
where sdo_relate(
              sg.geom,
              mc.geom,
              'mask=CONTAINS'
      ) = 'TRUE';

-- zad d
with poland_geom as (select cntry_name, geom
                     from country_boundaries
                     where cntry_name = 'Poland')
select cb.cntry_name as panstwo, sdo_geom.sdo_distance(cb.geom, pg.geom, 1, 'unit=km') as odl
from country_boundaries cb,
     poland_geom pg
where sdo_relate(
              pg.geom,
              cb.geom,
              'mask=TOUCH'
      ) != 'TRUE' and cb.cntry_name != 'Poland';

-- cw 3
-- zad a
with poland_geom as (select cntry_name, geom
                     from country_boundaries
                     where cntry_name = 'Poland')
select cb.cntry_name,
       sdo_geom.sdo_length(sdo_geom.sdo_intersection(cb.geom, pg.geom, 1), 1, 'unit=km') as odleglosc
from country_boundaries cb,
     poland_geom pg
where sdo_relate(
              pg.geom,
              cb.geom,
              'mask=TOUCH'
      ) = 'TRUE';

-- zad b
select cb.cntry_name
from country_boundaries cb
where sdo_geom.sdo_area(cb.geom) = (select max(sdo_geom.sdo_area(geom))
                                    from country_boundaries);

-- zad c
with warsaw_geom as (select geom
                     from major_cities
                     where city_name = 'Warsaw'),
     lodz_geom as (select geom
                   from major_cities
                   where city_name = 'Lodz')
select sdo_geom.sdo_area(
               sdo_geom.sdo_mbr(
                       sdo_geom.sdo_union(
                               wg.geom,
                               lg.geom,
                               0.01
                       )
               ), 0.01, 'unit=SQ_KM'
       ) as sq_km
from warsaw_geom wg,
     lodz_geom lg;

-- zad d
with poland_geom as (select geom
                     from country_boundaries
                     where cntry_name = 'Poland'),
     praga_geom as (select geom
                    from major_cities
                    where city_name = 'Prague')
select sdo_geom.sdo_union(pog.geom, prg.geom, 0.01).get_dims() ||
       sdo_geom.sdo_union(pog.geom, prg.geom, 0.01).get_lrs_dim() ||
       lpad(sdo_geom.sdo_union(pog.geom, prg.geom, 0.01).get_gtype(), 2, '0') as gtype
from poland_geom pog,
     praga_geom prg;

-- zad e
select mc.city_name, cb.cntry_name
from country_boundaries cb
         inner join major_cities mc on cb.cntry_name = mc.cntry_name
where sdo_geom.sdo_distance(mc.geom, sdo_geom.sdo_centroid(cb.geom, 1), 1) =
      (select min(sdo_geom.sdo_distance(mc.geom, sdo_geom.sdo_centroid(cb.geom, 1), 1)) as min_distance
       from country_boundaries cb
                inner join major_cities mc on cb.cntry_name = mc.cntry_name);

-- zad f
with poland_geom as (select geom
                     from country_boundaries
                     where cntry_name = 'Poland')
select r.name,
       sdo_geom.sdo_length(
               sdo_aggr_union(
                       mdsys.sdoaggrtype(
                               sdo_geom.sdo_intersection(r.geom, pg.geom, 1),
                               1
                       )
               ),
               1,
               'unit=KM'
       )
from rivers r,
     poland_geom pg
where sdo_relate(
              pg.geom,
              r.geom,
              'mask=ANYINTERACT'
      ) = 'TRUE'
group by r.name;
