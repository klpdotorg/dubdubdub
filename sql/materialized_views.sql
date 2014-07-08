CREATE MATERIALIZED VIEW mvw_dise_info AS
 SELECT t1.dise_code,
    t1.classroom_count,
    t1.teacher_count,
    t1.boys_count,
    t1.girls_count,
    t1.lowest_class,
    t1.highest_class,
    t1.acyear,
    t1.sg_recd,
    t1.sg_expnd,
    t1.tlm_recd,
    t1.tlm_expnd,
    t1.ffs_recd,
    t1.ffs_expnd,
    t1.books_in_library
   FROM dblink('host=localhost dbname=dise_all user=klp password=klp'::text, 'select df.school_code, to_number(df.tot_clrooms,''999''), to_number(df.male_tch,''999'') + to_number(df.female_tch,''999'') - to_number(df.noresp_tch,''999''),
to_number(de.class1_total_enr_boys,''999'') +
to_number(de. class2_total_enr_boys,''999'') +
to_number(de. class3_total_enr_boys,''999'') +
to_number(de. class4_total_enr_boys,''999'') +
to_number(de. class5_total_enr_boys,''999'') +
to_number(de. class6_total_enr_boys,''999'') +
to_number(de. class7_total_enr_boys,''999'') +
to_number(de. class8_total_enr_boys,''999'') ,
to_number(de. class1_total_enr_girls,''999'') +
to_number(de. class2_total_enr_girls,''999'') +
to_number(de. class3_total_enr_girls,''999'') +
to_number(de. class4_total_enr_girls,''999'') +
to_number(de. class5_total_enr_girls,''999'') +
to_number(de. class6_total_enr_girls,''999'') +
to_number(de. class7_total_enr_girls,''999'') +
to_number(de. class8_total_enr_girl,''999''),
to_number(dg.lowest_class,''999''),
to_number(dg.highest_class,''999''),
de.acyear,
to_number(dg.school_dev_grant_recd,''99999''),
to_number(dg.school_dev_grant_expnd,''99999''),
to_number(dg.tlm_grant_recd,''99999''),
to_number(dg.tlm_grant_expnd,''99999''),
to_number(dg.funds_from_students_recd,''999999''),
to_number(dg.funds_from_students_expnd,''999999''),
to_number(df.books_in_library,''999999'')
from tb_dise_facility df,tb_dise_enrol de,tb_dise_general dg where de.school_code=df.school_code and de.school_code=dg.school_code'::text) t1(dise_code character varying(32), classroom_count integer, teacher_count integer, boys_count integer, girls_count integer, lowest_class integer, highest_class integer, acyear character varying(15), sg_recd integer, sg_expnd integer, tlm_recd integer, tlm_expnd integer, ffs_recd integer, ffs_expnd integer, books_in_library integer);

-- list of cluster ids with block and districts
-- Only for primary schools

CREATE MATERIALIZED VIEW mvw_boundary_primary
as select tb1.id as cluster_id,
tb2.id as block_id,
tb3.id as district_id
from tb_boundary tb1, tb_boundary tb2, tb_boundary tb3
where tb1.hid=11 and tb1.type=1
and tb2.hid=10 and tb2.type=1
and tb1.parent=tb2.id
and tb3.hid=9 and tb3.type=1
and tb2.parent=tb3.id;

-- details about the school(both primary and preschools)
-- putting the locations in a view to save query time
-- assembly and parliament IDs as well.
DROP MATERIALIZED VIEW IF EXISTS mvw_school_details;

CREATE MATERIALIZED VIEW mvw_school_details as
SELECT tbs.id as id,
    tb1.id as cluster_or_circle_id,
    tb2.id as block_or_project_id,
    tb3.id as district_id,
    tb1.type as type,
    assembly.ac_id as assembly_id,
    assembly.pc_id as parliament_id,
    assembly.pin_id as pin_id
    FROM tb_boundary tb1, tb_boundary tb2, tb_boundary tb3, tb_school tbs LEFT JOIN
    (SELECT mva.ac_id as ac_id, mvp.pc_id as pc_id, vic.instid as instid, postal.pin_id as pin_id FROM mvw_assembly mva, mvw_parliament mvp, vw_inst_coord vic, mvw_postal postal WHERE ST_Within(vic.coord, mva.the_geom) AND ST_Within(vic.coord, mvp.the_geom) AND ST_Within(vic.coord, postal.the_geom)) AS assembly
    ON assembly.instid=tbs.id
    WHERE tbs.bid=tb1.id AND
    tb1.parent=tb2.id AND
    tb2.parent=tb3.id;

-- Materialized view for electedrep views

CREATE MATERIALIZED VIEW mvw_electedrep_master AS
SELECT t7.id,
    t7.parent,
    t7.elec_comm_code,
    t7.const_ward_name,
    t7.const_ward_type,
    t7.neighbours,
    t7.current_elected_rep,
    t7.current_elected_party
   FROM dblink('host=localhost dbname=electrep_new user=klp password=klp'::text, 'select id,parent,elec_comm_code,const_ward_name,const_ward_type,neighbours,current_elected_rep,current_elected_party from tb_electedrep_master'::text) t7(id integer, parent integer, elec_comm_code integer, const_ward_name character varying(300), const_ward_type admin_heirarchy, neighbours character varying(100), current_elected_rep character varying(300), current_elected_party character varying(300));

CREATE MATERIALIZED VIEW mvw_school_electedrep AS
SELECT t8.sid,
    t8.ward_id,
    t8.mla_const_id,
    t8.mp_const_id,
    t8.heirarchy,
    t8.bang_yn
   FROM dblink('host=localhost dbname=electrep_new user=klp password=klp'::text, 'select * from tb_school_electedrep'::text) t8(sid integer, ward_id integer, mla_const_id integer, mp_const_id integer, heirarchy integer, bang_yn integer);

CREATE MATERIALIZED VIEW mvw_dise_rte_agg AS
SELECT t1.dise_code,
    t1.rte_metric,
    t1.status,
    t1.rte_group
   FROM dblink('host=localhost dbname=dise_all user=klp password=klp'::text, 'select * from tb_dise_rte_agg'::text) t1(dise_code character varying(32), rte_metric character varying(36), status character varying(30), rte_group character varying(32));

CREATE MATERIALIZED VIEW mvw_dise_facility_agg AS
SELECT t1.dise_code,
    t1.df_metric,
    t1.score,
    t1.df_group
   FROM dblink('host=localhost dbname=dise_all user=klp password=klp'::text, 'select * from tb_dise_facility_agg'::text) t1(dise_code character varying(32), df_metric character varying(30), score numeric(5,0), df_group character varying(30));
