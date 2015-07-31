CREATE OR REPLACE FUNCTION import_teacher() RETURNS VOID AS
$$
DECLARE
    r RECORD;
BEGIN
    -- first try to update the key
    UPDATE tb_teacher as www
    SET name = regexp_replace(concat_ws(' ', ems.first_name, ems.middle_name, ems.last_name), '\s+', ' ', 'g'),
        sex = ems.gender::sex,
        status = ems.active,
        mt = ems.mt::school_moi,
        dateofjoining = ems.doj::date,
        type = ems.staff_type
    FROM ems_tb_teacher as ems
    WHERE www.id=ems.id AND
        (
            lower(regexp_replace(www.name, '\s+', ' ', 'g')) <> lower(regexp_replace(concat_ws(' ', ems.first_name, ems.middle_name, ems.last_name), '\s+', ' ', 'g')) OR
            www.sex <> ems.gender::sex OR
            www.status <> ems.active OR
            www.mt <> ems.mt::school_moi OR
            www.dateofjoining <> ems.doj::date OR
            www.type <> ems.staff_type
        );

    RAISE NOTICE '%', found;

    -- not there, so try to insert the key
    -- if someone else inserts the same key concurrently,
    -- we could get a unique-key failure
    FOR r IN
        SELECT ems_tb_teacher.id AS ems_id,
               tb_teacher.id AS www_id
        FROM ems_tb_teacher
        LEFT JOIN tb_teacher ON ems_tb_teacher.id=tb_teacher.id
        WHERE tb_teacher.id IS NULL
    LOOP
        RAISE NOTICE 'NEW TEACHER: %', r.ems_id;

        INSERT INTO tb_teacher(id, name, sex, status, mt, dateofjoining, type) SELECT
            ems.id,
            regexp_replace(concat_ws(' ', ems.first_name, ems.middle_name, ems.last_name), '\s+', ' ', 'g'),
            ems.gender::sex,
            ems.active,
            ems.mt::school_moi,
            ems.doj::date,
            ems.staff_type
        FROM ems_tb_teacher as ems
        WHERE ems.id = r.ems_id;
    END LOOP;
    RETURN;
END;
$$
LANGUAGE plpgsql;

SELECT import_teacher();
