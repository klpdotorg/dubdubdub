COPY (
    SELECT
        tb_school.id, tb_school.name, mgmt, moi, cat, sex,

        vtb_cluster.name AS cluster_name,
        vtb_block.name AS block_name,
        vtb_district.name AS district_name,
        'primary' as school_type,
        mvw_assembly.ac_name AS assembly_name,
        mvw_parliament.pc_name AS parliament_name,
        mvw_postal.pincode,

        concat_ws(', ', NULLIF(tb_address.address, ''), NULLIF(tb_address.area, '')) AS address,
        tb_address.landmark, tb_address.bus,

        ST_AsText(mvw_inst_coord.coord) as coord

    FROM tb_school

    LEFT OUTER JOIN tb_address ON (tb_address.id=tb_school.aid)
    LEFT OUTER JOIN mvw_school_details ON (mvw_school_details.id=tb_school.id)
    LEFT OUTER JOIN tb_boundary AS vtb_cluster ON (mvw_school_details.cluster_or_circle_id=vtb_cluster.id)
    LEFT OUTER JOIN tb_boundary AS vtb_block ON (mvw_school_details.block_or_project_id=vtb_block.id)
    LEFT OUTER JOIN tb_boundary AS vtb_district ON (mvw_school_details.district_id=vtb_district.id)
    LEFT OUTER JOIN mvw_assembly ON (mvw_assembly.id=mvw_school_details.assembly_id)
    LEFT OUTER JOIN mvw_parliament ON (mvw_parliament.id=mvw_school_details.parliament_id)
    LEFT OUTER JOIN mvw_postal ON (mvw_postal.pin_id=mvw_school_details.pin_id)
    LEFT OUTER JOIN mvw_inst_coord ON (mvw_inst_coord.instid=tb_school.id)

    WHERE mvw_school_details.stype=1 AND
        tb_school.status=2
) TO STDOUT WITH ( FORMAT CSV, HEADER true, FORCE_QUOTE * );
