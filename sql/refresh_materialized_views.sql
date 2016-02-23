REFRESH MATERIALIZED VIEW mvw_boundary_primary;
REFRESH MATERIALIZED VIEW mvw_institution_aggregations;
REFRESH MATERIALIZED VIEW mvw_school_extra;
REFRESH MATERIALIZED VIEW mvw_school_details;
REFRESH MATERIALIZED VIEW mvw_electedrep_master;
REFRESH MATERIALIZED VIEW mvw_school_electedrep;
REFRESH MATERIALIZED VIEW mvw_dise_rte_agg;
REFRESH MATERIALIZED VIEW mvw_dise_facility_agg;
REFRESH MATERIALIZED VIEW mvw_school_class_total_year;
REFRESH MATERIALIZED VIEW mvw_inst_coord;
REFRESH MATERIALIZED VIEW mvw_mdm_agg;
REFRESH MATERIALIZED VIEW mvw_dise_info_olap;
REFRESH MATERIALIZED VIEW mvw_ang_infra_agg;
REFRESH MATERIALIZED VIEW mvw_ang_display_master;
REFRESH MATERIALIZED VIEW mvw_libinfra;
REFRESH MATERIALIZED VIEW mvw_lib_borrow;
REFRESH MATERIALIZED VIEW mvw_lib_lang_agg;
REFRESH MATERIALIZED VIEW mvw_lib_level_agg;
REFRESH MATERIALIZED VIEW mvw_boundary_coord;
REFRESH MATERIALIZED VIEW mvw_dise_display_master;
REFRESH MATERIALIZED VIEW mvw_paisa_data;
REFRESH MATERIALIZED VIEW mvw_school_eval;
REFRESH MATERIALIZED VIEW mvw_anginfra_agg;


---------------------------------
-- Not a materialized View, but
-- this model needs to update too
-- every time the mviews update
---------------------------------
UPDATE schools_locality
SET assembly_id=mvw_assembly.id
FROM mvw_inst_coord, mvw_assembly
WHERE
    school_id=mvw_inst_coord.instid AND
    ST_Within(mvw_inst_coord.coord, mvw_assembly.the_geom);

UPDATE schools_locality
SET parliament_id=mvw_parliament.id
FROM mvw_inst_coord, mvw_parliament
WHERE
    school_id=mvw_inst_coord.instid AND
    ST_Within(mvw_inst_coord.coord, mvw_parliament.the_geom);

UPDATE schools_locality
SET pincode_id=mvw_postal.pin_id
FROM mvw_inst_coord, mvw_postal
WHERE
    school_id=mvw_inst_coord.instid AND
    ST_Within(mvw_inst_coord.coord, mvw_postal.the_geom);

UPDATE schools_locality
SET assembly_id=mvw_school_electedrep.mla_const_id,
    parliament_id=mvw_school_electedrep.mp_const_id
FROM mvw_school_electedrep
WHERE (assembly_id IS NULL OR parliament_id IS NULL)
    AND school_id=mvw_school_electedrep.sid;
