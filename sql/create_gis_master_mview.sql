CREATE MATERIALIZED VIEW mvw_gis_master AS
 SELECT code, name, centroid
   FROM dblink('host=localhost dbname=gis_master user=klp'::text, 'select code, name, centroid from schools'::text) schools(code bigint, name character varying(150), centroid geometry);