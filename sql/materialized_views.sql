-- Materialized view for electedrep views

DROP MATERIALIZED VIEW IF EXISTS mvw_electedrep_master CASCADE;
CREATE MATERIALIZED VIEW mvw_electedrep_master AS
SELECT t7.id,
    t7.parent,
    t7.dise_slug,
    t7.elec_comm_code,
    t7.const_ward_name,
    t7.const_ward_type,
    t7.neighbours,
    t7.current_elected_rep,
    t7.current_elected_party,
    t7.status
   FROM dblink(
        'host=localhost dbname=electrep_new user=klp'::text, 'select id, parent, dise_slug, elec_comm_code, const_ward_name, const_ward_type, neighbours, current_elected_rep, current_elected_party, status from tb_electedrep_master'::text
    ) t7(
        id integer,
        parent integer,
        dise_slug text,
        elec_comm_code integer,
        const_ward_name character varying(300),
        const_ward_type admin_heirarchy,
        neighbours character varying(100),
        current_elected_rep character varying(300),
        current_elected_party character varying(300),
        status character varying(20)
    );
CREATE INDEX ON mvw_electedrep_master (elec_comm_code);
CREATE INDEX ON mvw_electedrep_master (dise_slug);
ANALYZE mvw_electedrep_master;

DROP MATERIALIZED VIEW IF EXISTS mvw_school_electedrep CASCADE;
CREATE MATERIALIZED VIEW mvw_school_electedrep AS
SELECT t8.sid,
    t8.ward_id,
    t8.mla_const_id,
    t8.mp_const_id,
    t8.heirarchy,
    t8.gram_panchayat
   FROM dblink('host=localhost dbname=electrep_new user=klp'::text, 'select sid, ward_id, mla_const_id, mp_const_id, heirarchy, gram_panchayat from tb_school_electedrep'::text) t8(sid integer, ward_id integer, mla_const_id integer, mp_const_id integer, heirarchy integer, gram_panchayat text);

-- View for Assembly table.
DROP MATERIALIZED VIEW IF EXISTS mvw_assembly CASCADE;
CREATE MATERIALIZED VIEW mvw_assembly AS
 SELECT mvw_electedrep_master.id, gid, ac_id,
    ac_no,
    ac_name,
    state_ut,
    the_geom
   FROM dblink('host=localhost dbname=spatial user=klp '::text, 'select gid, ac_id, ac_no, ac_name, state_ut, the_geom from assembly'::text)
        assembly(
            gid integer,
            ac_id integer,
            ac_no integer,
            ac_name character varying(35),
            state_ut character varying(35),
            the_geom geometry
        ), mvw_electedrep_master
    WHERE assembly.ac_no=mvw_electedrep_master.elec_comm_code and
          mvw_electedrep_master.status='active' and
          mvw_electedrep_master.const_ward_type='MLA Constituency';
CREATE INDEX ON mvw_assembly (id);
ANALYZE mvw_assembly;

-- View for Parliament table.
DROP MATERIALIZED VIEW IF EXISTS mvw_parliament CASCADE;
CREATE MATERIALIZED VIEW mvw_parliament AS
 SELECT mvw_electedrep_master.id, gid, pc_id,
    pc_no,
    pc_name,
    state_ut,
    the_geom
   FROM dblink('host=localhost dbname=spatial user=klp'::text, 'select gid, pc_id, pc_no, pc_name, state_ut, the_geom from parliament'::text)
        parliament(
            gid integer,
            pc_id integer,
            pc_no integer,
            pc_name character varying(35),
            state_ut character varying(35),
            the_geom geometry
        ), mvw_electedrep_master
    WHERE parliament.pc_no=mvw_electedrep_master.elec_comm_code and
          mvw_electedrep_master.status='active' and
          mvw_electedrep_master.const_ward_type='MP Constituency';
CREATE INDEX ON mvw_parliament (id);
ANALYZE mvw_parliament;

-- View for Postal table.
DROP MATERIALIZED VIEW IF EXISTS mvw_postal CASCADE;
CREATE MATERIALIZED VIEW mvw_postal AS
 SELECT gid,
    pin_id,
    pincode,
    the_geom
   FROM dblink('host=localhost dbname=spatial user=klp'::text, 'select gid, pin_id, pincode, the_geom from postal'::text) postal(gid integer, pin_id integer, pincode character varying(35), the_geom geometry);

DROP MATERIALIZED VIEW IF EXISTS mvw_inst_coord CASCADE;
CREATE materialized VIEW mvw_inst_coord AS
SELECT t2.instid,
       t2.coord
FROM dblink('host=localhost dbname=klp-coord user=klp'::text, 'select * from inst_coord'::text) t2(instid integer, coord geometry);
CREATE UNIQUE INDEX udx_instid ON mvw_inst_coord (instid);
CREATE INDEX idx_inst_geom ON mvw_inst_coord USING gist(coord);

DROP MATERIALIZED VIEW IF EXISTS mvw_boundary_primary CASCADE;
CREATE materialized VIEW mvw_boundary_primary AS
SELECT tb1.id AS cluster_id,
       tb2.id AS block_id,
       tb3.id AS district_id
FROM tb_boundary tb1,
     tb_boundary tb2,
     tb_boundary tb3
WHERE tb1.hid=11
    AND tb1.type=1
    AND tb2.hid=10
    AND tb2.type=1
    AND tb1.parent=tb2.id
    AND tb3.hid=9
    AND tb3.type=1
    AND tb2.parent=tb3.id;


DROP MATERIALIZED VIEW IF EXISTS mvw_institution_aggregations CASCADE;
CREATE MATERIALIZED VIEW mvw_institution_aggregations AS
SELECT format('A%sS%s', sc.ayid, s.id) as id,
       sc.ayid AS academic_year_id,
       s.id AS school_id,
       s.bid AS boundary_id,
       c.sex AS gender,
       c.mt AS mt,
       count(DISTINCT stu.id) AS num
FROM tb_student stu,
     tb_class cl,
     tb_student_class sc,
     tb_child c,
     tb_school s
WHERE cl.sid = s.id
    AND sc.clid = cl.id
    AND sc.stuid = stu.id
    AND sc.status=1
    AND stu.cid = c.id
    AND s.status=2
GROUP BY academic_year_id,
         school_id,
         boundary_id,
         gender,
         mt;


-- details about the school(both primary and preschools)
-- putting the locations in a view to save query time
-- assembly and parliament IDs as well.
DROP MATERIALIZED VIEW IF EXISTS mvw_school_details CASCADE;
CREATE MATERIALIZED VIEW mvw_school_details as
SELECT tbs.id as id,
    tb1.id as cluster_or_circle_id,
    tb2.id as block_or_project_id,
    tb3.id as district_id,
    tb1.type as stype,
    electrep.aid as assembly_id,
    electrep.pid as parliament_id,
    electrep.pin_id as pin_id
    FROM tb_boundary tb1, tb_boundary tb2, tb_boundary tb3, tb_school tbs
    LEFT JOIN (
        SELECT mva.id as aid, mvp.id as pid, vic.instid as instid, postal.pin_id as pin_id
        FROM mvw_assembly mva, mvw_parliament mvp, mvw_inst_coord vic, mvw_postal postal
        WHERE ST_Within(vic.coord, mva.the_geom) AND ST_Within(vic.coord, mvp.the_geom)
            AND ST_Within(vic.coord, postal.the_geom)
    ) AS electrep ON electrep.instid=tbs.id
    WHERE tbs.bid=tb1.id AND
    tb1.parent=tb2.id AND
    tb2.parent=tb3.id;


DROP MATERIALIZED VIEW IF EXISTS mvw_school_extra CASCADE;
CREATE MATERIALIZED VIEW mvw_school_extra AS
SELECT
    format('A%sS%s', tia.academic_year_id, tia.school_id) as id,
    tia.academic_year_id as academic_year_id,
    tia.school_id as school_id,
    SUM(CASE tia.gender WHEN 'male' THEN tia.num ELSE 0 END) as num_boys,
    SUM(CASE tia.gender WHEN 'female' THEN tia.num ELSE 0 END) as num_girls
    FROM mvw_institution_aggregations as tia
    GROUP BY academic_year_id, school_id;

DROP MATERIALIZED VIEW IF EXISTS mvw_dise_rte_agg CASCADE;
CREATE MATERIALIZED VIEW mvw_dise_rte_agg AS
SELECT t1.dise_code,
    t1.rte_metric,
    t1.status,
    t1.rte_group
   FROM dblink('host=localhost dbname=dise_all user=klp'::text, 'select * from tb_dise_rte_agg'::text) t1(dise_code character varying(32), rte_metric character varying(36), status character varying(30), rte_group character varying(32));

DROP MATERIALIZED VIEW IF EXISTS mvw_dise_facility_agg CASCADE;
CREATE MATERIALIZED VIEW mvw_dise_facility_agg AS
SELECT t1.dise_code,
    t1.df_metric,
    t1.score,
    t1.df_group
   FROM dblink('host=localhost dbname=dise_all user=klp'::text, 'select * from tb_dise_facility_agg'::text) t1(dise_code character varying(32), df_metric character varying(30), score numeric(5,0), df_group character varying(30));
CREATE INDEX dise_code_idx ON mvw_dise_facility_agg (dise_code);
ANALYZE mvw_dise_facility_agg;

DROP MATERIALIZED VIEW IF EXISTS mvw_mdm_agg CASCADE;
CREATE materialized VIEW mvw_mdm_agg AS
SELECT id as klpid, mon, wk, indent, attend
FROM dblink('host=localhost dbname=apmdm user=klp'::text, 'select * from tb_mdm_agg'::text) t1(id integer, mon character varying(15), wk integer, indent integer, attend integer);
CREATE INDEX klpid_idx ON mvw_mdm_agg (klpid);
ANALYZE mvw_mdm_agg;

DROP MATERIALIZED VIEW IF EXISTS mvw_dise_info_olap CASCADE;
CREATE MATERIALIZED VIEW mvw_dise_info_olap AS
SELECT t1.school_code as dise_code,
    -- t2.id as assembly_id,
    -- t3.id as parliament_id,
    t1.tot_clrooms as classroom_count,
    t1.teacher_count,
    t1.total_boys AS boys_count,
    t1.total_girls AS girls_count,
    t1.lowest_class,
    t1.highest_class,
    t1.acyear,
    t1.school_dev_grant_recd as sg_recd,
    t1.school_dev_grant_expnd AS sg_expnd,
    t1.tlm_grant_recd AS tlm_recd,
    t1.tlm_grant_expnd AS tlm_expnd,
    t1.funds_from_students_recd AS ffs_recd,
    t1.funds_from_students_expnd AS ffs_expnd,
    t1.books_in_library
FROM dblink(
    'host=localhost dbname=klpdise_olap user=klp'::text,
    'SELECT
        school_code,
        lowest_class,
        highest_class,
        (SELECT ''2015-16'') AS acyear,
        school_dev_grant_recd,
        school_dev_grant_expnd,
        tlm_grant_recd,
        tlm_grant_expnd,
        funds_from_students_recd,
        funds_from_students_expnd,
        tot_clrooms,
        books_in_library,
        (male_tch + female_tch) AS teacher_count,
        total_boys,
        total_girls
    FROM dise_1516_basic_data'
) t1(
    school_code character varying(32),
    -- assembly_name character varying(35),
    -- parliament_name character varying(35),
    lowest_class integer,
    highest_class integer,
    acyear character varying(10),
    school_dev_grant_recd double precision,
    school_dev_grant_expnd double precision,
    tlm_grant_recd double precision,
    tlm_grant_expnd double precision,
    funds_from_students_recd double precision,
    funds_from_students_expnd double precision,
    tot_clrooms integer,
    books_in_library integer,
    teacher_count integer,
    total_boys integer,
    total_girls integer
);--,  mvw_assembly t2, mvw_parliament t3
-- where t2.ac_name=t1.assembly_name and t3.pc_name=t1.parliament_name;

DROP MATERIALIZED VIEW IF EXISTS mvw_ang_infra_agg CASCADE;
CREATE MATERIALIZED VIEW mvw_ang_infra_agg AS
SELECT t1.sid,
    t1.ai_metric,
    t1.perc_score,
    t1.ai_group
FROM dblink(
   'host=localhost dbname=ang_infra user=klp'::text,
   'select NULLIF(sid, 0)::int as sid, ai_metric, perc_score, ai_group from tb_ang_infra_agg'::text) t1(sid integer, ai_metric character varying(30), perc_score numeric(5,0), ai_group character varying(30));
CREATE INDEX sid_idx ON mvw_ang_infra_agg (sid);
ANALYZE mvw_ang_infra_agg;

DROP MATERIALIZED VIEW IF EXISTS mvw_ang_display_master CASCADE;
CREATE MATERIALIZED VIEW mvw_ang_display_master AS
SELECT t1.key,
    t1.value
   FROM dblink('host=localhost dbname=ang_infra user=klp'::text, 'select * from tb_display_master'::text) t1(key character varying(32), value character varying(200));

DROP MATERIALIZED VIEW IF EXISTS mvw_libinfra CASCADE;
CREATE MATERIALIZED VIEW mvw_libinfra AS
SELECT t1.sid,
    t1.libstatus,
    t1.handoveryear,
    t1.libtype,
    t1.numbooks,
    t1.numracks,
    t1.numtables,
    t1.numchairs,
    t1.numcomputers,
    t1.numups
FROM dblink('host=localhost dbname=libinfra user=klp'::text, 'select * from tb_libinfra'::text) t1(sid integer, libstatus character varying(300), handoveryear integer, libtype character varying(300), numbooks integer, numracks integer, numtables integer, numchairs integer, numcomputers integer, numups integer);

DROP MATERIALIZED VIEW IF EXISTS mvw_lib_borrow CASCADE;
CREATE MATERIALIZED VIEW mvw_lib_borrow AS
SELECT t1.trans_year,
    t1.class,
    t1.issue_date,
    t1.klp_school_id,
    t1.school_name,
    t1.klp_child_id
FROM dblink('host=localhost dbname=library user=klp'::text, 'select trans_year,class,issue_date,klp_school_id,school_name,klp_child_id from libentry where flag is not null'::text) t1(trans_year character varying(30), class numeric(3,0), issue_date character varying(20), klp_school_id numeric(7,0), school_name character varying(50), klp_child_id character varying(30));

DROP MATERIALIZED VIEW IF EXISTS mvw_lib_lang_agg CASCADE;
CREATE MATERIALIZED VIEW mvw_lib_lang_agg AS
SELECT t1.klp_school_id,
    t1.class,
    t1.month,
    t1.year,
    t1.book_lang,
    t1.child_count
FROM dblink('host=localhost dbname=library user=klp'::text, 'select * from lang_agg'::text) t1(klp_school_id integer, class integer, month character varying(10), year character varying(10), book_lang character varying(50), child_count integer);

DROP MATERIALIZED VIEW IF EXISTS mvw_lib_level_agg CASCADE;
CREATE MATERIALIZED VIEW mvw_lib_level_agg AS
SELECT t1.klp_school_id,
    t1.class,
    t1.month,
    t1.year,
    t1.book_level,
    t1.child_count
FROM dblink('host=localhost dbname=library user=klp'::text, 'select * from level_agg'::text) t1(klp_school_id integer, class integer, month character varying(10), year character varying(10), book_level character varying(50), child_count integer);

DROP MATERIALIZED VIEW IF EXISTS mvw_boundary_coord CASCADE;
CREATE MATERIALIZED VIEW mvw_boundary_coord AS SELECT t1.id_bndry,
    t1.type,
    t1.coord
   FROM dblink('host=localhost dbname=klp-coord user=klp'::text, 'select * from boundary_coord'::text) t1(id_bndry integer, type character varying(20), coord geometry);

DROP MATERIALIZED VIEW IF EXISTS mvw_dise_display_master CASCADE;
CREATE MATERIALIZED VIEW mvw_dise_display_master AS SELECT t1.key,
    t1.value
   FROM dblink('host=localhost dbname=dise_all user=klp'::text, 'select * from tb_display_master'::text) t1(key character varying(36), value character varying(200));

DROP MATERIALIZED VIEW IF EXISTS mvw_paisa_data CASCADE;
CREATE MATERIALIZED VIEW mvw_paisa_data AS SELECT t1.grant_type,
    t1.grant_amount,
    t1.criteria,
    t1.operator,
    t1.factor
   FROM dblink('host=localhost dbname=dise_all user=klp'::text, 'select * from tb_paisa_data'::text) t1(grant_type character varying(32), grant_amount integer, criteria character varying(32), operator character varying(3), factor character varying(32));

DROP MATERIALIZED VIEW IF EXISTS mvw_school_eval CASCADE;
CREATE MATERIALIZED VIEW mvw_school_eval AS SELECT t.sid,
    t.disecode,
    t.domain,
    t.qid,
    t.value
   FROM dblink('host=localhost dbname=pratham_mysore user=klp'::text, 'select * from tb_school_eval'::text) t(sid integer, disecode character varying(100), domain character varying(100), qid integer, value character varying(50));

DROP MATERIALIZED VIEW IF EXISTS mvw_anginfra_agg CASCADE;
CREATE MATERIALIZED VIEW mvw_anginfra_agg AS SELECT t1.sid,
    t1.ai_metric,
    t1.perc_score,
    t1.ai_group
   FROM dblink('host=localhost dbname=ang_infra user=klp'::text, 'select * from tb_ang_infra_agg'::text) t1(sid integer, ai_metric character varying(30), perc_score numeric(5,0), ai_group character varying(30));

DROP MATERIALIZED VIEW IF EXISTS mvw_school_class_total_year CASCADE;
CREATE MATERIALIZED VIEW mvw_school_class_total_year AS
SELECT sg.sid AS schid,
    btrim(sg.name::text) AS clas,
    count(DISTINCT stu.id) AS total,
    acyear.id AS academic_year
   FROM tb_student_class stusg,
    tb_class sg,
    tb_student stu,
    tb_academic_year acyear
  WHERE stu.id = stusg.stuid AND stusg.clid = sg.id AND stu.status = 2 AND acyear.id = stusg.ayid
  GROUP BY sg.sid, btrim(sg.name::text), acyear.id;

