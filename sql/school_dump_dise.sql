COPY (
    SELECT
        mvw_dise_info_olap.dise_code,
        tb_school.id as klp_id,
        tb_school.name,
        mvw_assembly.ac_name,
        mvw_parliament.pc_name,
        mvw_dise_info_olap.lowest_class,
        mvw_dise_info_olap.highest_class,
        (SELECT '2013-14') AS acyear,
        mvw_dise_info_olap.sg_recd as school_dev_grant_recd,
        mvw_dise_info_olap.sg_expnd as school_dev_grant_expnd,
        mvw_dise_info_olap.tlm_recd as tlm_grant_recd,
        mvw_dise_info_olap.tlm_expnd as tlm_grant_expnd,
        mvw_dise_info_olap.ffs_recd as funds_from_students_recd,
        mvw_dise_info_olap.ffs_expnd as funds_from_students_expnd,
        mvw_dise_info_olap.classroom_count,
        mvw_dise_info_olap.books_in_library,
        mvw_dise_info_olap.teacher_count,
        mvw_dise_info_olap.boys_count,
        mvw_dise_info_olap.girls_count
    FROM mvw_dise_info_olap, tb_school, mvw_assembly, mvw_parliament
    WHERE
        tb_school.dise_code=mvw_dise_info_olap.dise_code AND
        mvw_assembly.id=mvw_dise_info_olap.assembly_id AND
        mvw_parliament.id=mvw_dise_info_olap.parliament_id
) TO STDOUT WITH ( FORMAT CSV, HEADER true, FORCE_QUOTE * );
