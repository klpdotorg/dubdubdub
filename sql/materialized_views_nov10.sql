CREATE MATERIALIZED VIEW mvw_boundary_coord AS SELECT t1.id_bndry,
    t1.type,
    t1.coord
   FROM dblink('host=localhost dbname=klp-coord user=klp password=klp'::text, 'select * from boundary_coord'::text) t1(id_bndry integer, type character varying(20), coord geometry);
