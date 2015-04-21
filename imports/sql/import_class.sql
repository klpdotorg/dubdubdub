CREATE OR REPLACE FUNCTION import_class() RETURNS VOID AS
$$
DECLARE
    r RECORD;
BEGIN
    -- first try to update the key
    UPDATE tb_class as www
    SET name = ems.class,
        section = ems.section
    FROM ems_tb_class as ems
    WHERE www.id=ems.id AND www.sid=ems.institution_id AND
        (
            www.name <> ems.class OR
            www.section <> ems.section
        );

    RAISE NOTICE 'SOMETHING UPDATED: %', found;

    FOR r IN
        SELECT ems_tb_class.id AS ems_id,
               tb_class.id AS www_id
        FROM ems_tb_class
        LEFT JOIN tb_class ON ems_tb_class.id=tb_class.id
        WHERE tb_class.id IS NULL
        ORDER BY ems_id
    LOOP
        RAISE NOTICE 'NEW CLASS: %', r.ems_id;

        INSERT INTO tb_class SELECT
            ems_cl.id as id,
            ems_cl.institution_id as sid,
            ems_cl.class::text as name,
            ems_cl.section::text as section
            FROM ems_tb_class as ems_cl
            WHERE ems_cl.id = r.ems_id;
    END LOOP;
    RAISE NOTICE 'END OF LOOP, CREATED ALL NEW CLASSES';
    RETURN;
END;
$$
LANGUAGE plpgsql;

SELECT import_class();
