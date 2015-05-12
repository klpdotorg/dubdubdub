CREATE OR REPLACE FUNCTION import_teacher_qual() RETURNS VOID AS
$$
DECLARE
    r RECORD;
BEGIN
    -- there is no primary key, so can't update anything
    FOR r IN
        SELECT ems_tb_teacher_qual.staff_id AS ems_id,
               ems_tb_teacher_qual.qualification as ems_qualification,
               tb_teacher_qual.tid AS www_id,
               tb_teacher_qual.qualification as www_qualification
        FROM ems_tb_teacher_qual
        LEFT JOIN tb_teacher_qual ON
            (
                ems_tb_teacher_qual.staff_id=tb_teacher_qual.tid AND
                ems_tb_teacher_qual.qualification=tb_teacher_qual.qualification
            )
        WHERE tb_teacher_qual.tid IS NULL
    LOOP
        RAISE NOTICE 'NEW TEACHER QUAL: %', r.ems_id;
        INSERT INTO tb_teacher_qual(tid, qualification) SELECT
            ems.staff_id,
            ems.qualification
        FROM ems_tb_teacher_qual as ems
        WHERE ems.staff_id = r.ems_id AND
            ems.qualification = r.ems_qualification;
    END LOOP;
    RETURN;
END;
$$
LANGUAGE plpgsql;

SELECT import_teacher_qual();
