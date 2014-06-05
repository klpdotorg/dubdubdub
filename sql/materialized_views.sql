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

CREATE MATERIALIZED VIEW mvw_school_details as
select tbs.id as id,
tb1.id as cluster_or_circle_id,
tb2.id as block_or_project_id,
tb3.id as district_id,
tb1.type as type
from tb_school tbs, tb_boundary tb1, tb_boundary tb2, tb_boundary tb3
where tbs.bid=tb1.id
and tb1.parent=tb2.id
and tb2.parent=tb3.id;