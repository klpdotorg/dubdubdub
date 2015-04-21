CREATE OR REPLACE FUNCTION import_children() RETURNS VOID AS
$$
DECLARE
    r RECORD;
BEGIN
    -- first try to update the key
    UPDATE tb_child as www
    SET name = regexp_replace(concat_ws(' ', ems.first_name, ems.middle_name, ems.last_name), '\s+', ' ', 'g'),
        dob = ems.dob,
        sex = ems.gender::sex,
        mt = ems.mt::school_moi
    FROM ems_tb_child as ems
    WHERE www.id=ems.id AND
        (
            lower(regexp_replace(www.name, '\s+', ' ', 'g')) <> lower(regexp_replace(concat_ws(' ', ems.first_name, ems.middle_name, ems.last_name), '\s+', ' ', 'g')) OR
            www.dob <> ems.dob OR
            www.sex::text <> ems.gender OR
            www.mt::text <> ems.mt
        );

    RAISE NOTICE '%', found;

    -- not there, so try to insert the key
    -- if someone else inserts the same key concurrently,
    -- we could get a unique-key failure
    FOR r IN
        SELECT ems_tb_child.id AS ems_id,
               tb_child.id AS www_id
        FROM ems_tb_child
        LEFT JOIN tb_child ON ems_tb_child.id=tb_child.id
        WHERE tb_child.id IS NULL
    LOOP
        RAISE NOTICE 'NEW CHILD: %', r.ems_id;

        INSERT INTO tb_child(id, name, dob, sex, mt) SELECT
            ems.id,
            regexp_replace(concat_ws(' ', ems.first_name, ems.middle_name, ems.last_name), '\s+', ' ', 'g') as name,
            ems.dob as dob,
            ems.gender::sex as sex,
            ems.mt::school_moi as mt
        FROM ems_tb_child as ems
        WHERE ems.id = r.ems_id;
    END LOOP;
    RETURN;
END;
$$
LANGUAGE plpgsql;

SELECT import_children();
