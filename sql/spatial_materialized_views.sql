
-- View for Assembly table.
CREATE MATERIALIZED VIEW mvw_assembly AS
 SELECT gid, ac_id,
    ac_no,
    ac_name,
    state_ut,
    the_geom
   FROM dblink('host=localhost dbname=spatial user=klp password=klp'::text, 'select gid, ac_id, ac_no, ac_name, state_ut, the_geom from assembly'::text) assembly(gid integer, ac_id integer, ac_no integer, ac_name character varying(35), state_ut character varying(35), the_geom geometry);

-- View for Parliament table.
CREATE MATERIALIZED VIEW mvw_parliament AS
 SELECT gid, pc_id,
    pc_no,
    pc_name,
    state_ut,
    the_geom
   FROM dblink('host=localhost dbname=spatial user=klp password=klp'::text, 'select gid, pc_id, pc_no, pc_name, state_ut, the_geom from parliament'::text) parliament(gid integer, pc_id integer, pc_no integer, pc_name character varying(35), state_ut character varying(35), the_geom geometry);

-- View for Postal table.
CREATE MATERIALIZED VIEW mvw_postal AS
 SELECT gid,
    pin_id,
    pincode,
    the_geom
   FROM dblink('host=localhost dbname=spatial user=klp password=klp'::text, 'select gid, pin_id, pincode, the_geom from postal'::text) postal(gid integer, pin_id integer, pincode character varying(35), the_geom geometry);