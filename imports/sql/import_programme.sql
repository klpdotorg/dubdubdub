CREATE OR REPLACE FUNCTION import_programme() RETURNS VOID AS
$$
DECLARE
    r RECORD;
BEGIN
    -- first try to update the key
    UPDATE tb_programme as www
    SET name = regexp_replace(ems.name, '\s+', ' ', 'g'),
        start = ems.start_date,
        "end" = ems.end_date,
        type = ems.programme_institution_category_id::integer
    FROM ems_tb_programme as ems
    WHERE www.id=ems.id AND
        (
            lower(regexp_replace(www.name, '\s+', ' ', 'g')) <> lower(regexp_replace(ems.name, '\s+', ' ', 'g')) OR
            www.start <> ems.start_date OR
            www.end <> ems.end_date OR
            www.type <> ems.programme_institution_category_id
        );

    RAISE NOTICE '%', found;

    -- not there, so try to insert the key
    -- if someone else inserts the same key concurrently,
    -- we could get a unique-key failure
    FOR r IN
        SELECT ems_tb_programme.id AS ems_id,
               tb_programme.id AS www_id
        FROM ems_tb_programme
        LEFT JOIN tb_programme ON ems_tb_programme.id=tb_programme.id
        WHERE tb_programme.id IS NULL
    LOOP
        INSERT INTO tb_programme(id, name, start, "end", type) SELECT
            ems.id,
            regexp_replace(ems.name, '\s+', ' ', 'g'),
            ems.start_date,
            ems.end_date,
            ems.programme_institution_category_id::integer
        FROM ems_tb_programme as ems
        WHERE ems.id = r.ems_id;
    END LOOP;
    RETURN;
END;
$$
LANGUAGE plpgsql;

SELECT import_programme();
