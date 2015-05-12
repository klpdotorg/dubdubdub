CREATE OR REPLACE FUNCTION import_teacher_class() RETURNS VOID AS
$$
DECLARE
    r RECORD;
BEGIN
    -- first try to update the key
    UPDATE tb_teacher_class as www
    SET ayid = ems.academic_id,
        status = ems.active
    FROM ems_tb_teacher_class as ems
    WHERE www.teacherid = ems.staff_id AND
        www.clid = ems.student_group_id AND
        www.ayid = ems.academic_id AND
        www.status <> ems.active;

    RAISE NOTICE 'SOMETHING UPDATED: %', found;

    FOR r IN
        SELECT ems_tb_teacher_class.staff_id AS ems_id,
               tb_teacher_class.teacherid AS www_id
        FROM ems_tb_teacher_class
        LEFT JOIN tb_teacher_class ON ems_tb_teacher_class.staff_id=tb_teacher_class.teacherid
        WHERE tb_teacher_class.teacherid IS NULL
        ORDER BY ems_id
    LOOP
        RAISE NOTICE 'NEW TEACHER CLASS: %', r.ems_id;

        INSERT INTO tb_teacher_class SELECT
            ems_cl.staff_id as teacherid,
            ems_cl.student_group_id as clid,
            ems_cl.academic_id::integer as ayid,
            ems_cl.active::integer as status
        FROM ems_tb_teacher_class as ems_cl
        WHERE ems_cl.staff_id = r.ems_id;
    END LOOP;
    RAISE NOTICE 'END OF LOOP';
    RETURN;
END;
$$
LANGUAGE plpgsql;

SELECT import_teacher_class();
