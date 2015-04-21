CREATE OR REPLACE FUNCTION import_student_class() RETURNS VOID AS
$$
DECLARE
    r RECORD;
BEGIN
    -- first try to update the key
    UPDATE tb_student_class as www
    SET ayid = ems.academic_id,
        status = ems.active
    FROM ems_tb_student_class as ems
    WHERE www.stuid = ems.student_id AND
        www.clid = ems.student_group_id AND
        www.ayid = ems.academic_id AND
        www.status <> ems.active;

    RAISE NOTICE 'SOMETHING UPDATED: %', found;

    FOR r IN
        SELECT ems_tb_student_class.student_id AS ems_id,
               tb_student_class.stuid AS www_id
        FROM ems_tb_student_class
        LEFT JOIN tb_student_class ON ems_tb_student_class.student_id=tb_student_class.stuid
        WHERE tb_student_class.stuid IS NULL
        ORDER BY ems_id
    LOOP
        RAISE NOTICE 'NEW STUDENT CLASS: %', r.ems_id;

        INSERT INTO tb_student_class SELECT
            ems_cl.student_id as stuid,
            ems_cl.student_group_id as clid,
            ems_cl.academic_id::integer as ayid,
            ems_cl.active::integer as status
        FROM ems_tb_student_class as ems_cl
        WHERE ems_cl.student_id = r.ems_id;
    END LOOP;
    RAISE NOTICE 'END OF LOOP';
    RETURN;
END;
$$
LANGUAGE plpgsql;

SELECT import_student_class();
