CREATE OR REPLACE FUNCTION import_student() RETURNS VOID AS
$$
DECLARE
    r RECORD;
BEGIN
    -- first try to update the key
    UPDATE tb_student as www
    SET otherstudentid = ems.other_student_id,
        status = ems.active
    FROM ems_tb_student as ems
    WHERE www.id=ems.id AND www.cid=ems.child_id AND
        (
            www.otherstudentid <> ems.other_student_id OR
            www.status <> ems.active
        );

    RAISE NOTICE 'SOMETHING UPDATED: %', found;

    FOR r IN
        SELECT ems_tb_student.id AS ems_id,
               tb_student.id AS www_id
        FROM ems_tb_student
        LEFT JOIN tb_student ON ems_tb_student.id=tb_student.id
        WHERE tb_student.id IS NULL
        ORDER BY ems_id
    LOOP
        RAISE NOTICE 'NEW SCHOOL: %', r.ems_id;

        INSERT INTO tb_student SELECT
            ems_cl.id as id,
            ems_cl.child_id as cid,
            ems_cl.other_student_id::text as otherstudentid,
            ems_cl.active::integer as status
            FROM ems_tb_student as ems_cl
            WHERE ems_cl.id = r.ems_id;
    END LOOP;
    RAISE NOTICE 'END OF LOOP';
    RETURN;
END;
$$
LANGUAGE plpgsql;

SELECT import_student();
