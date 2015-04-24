CREATE OR REPLACE FUNCTION import_assessment() RETURNS VOID AS
$$
DECLARE
    r RECORD;
BEGIN
    -- first try to update the key
    UPDATE tb_assessment as www
    SET name = regexp_replace(ems.name, '\s+', ' ', 'g'),
        pid = ems.programme_id,
        start = ems.start_date,
        "end" = ems.end_date
    FROM ems_tb_assessment as ems
    WHERE www.id=ems.id AND
        (
            lower(regexp_replace(www.name, '\s+', ' ', 'g')) <> lower(regexp_replace(ems.name, '\s+', ' ', 'g')) OR
            www.pid <> ems.programme_id OR
            www.start <> ems.start_date OR
            www.end <> ems.end_date
        );

    RAISE NOTICE '%', found;

    -- not there, so try to insert the key
    -- if someone else inserts the same key concurrently,
    -- we could get a unique-key failure
    FOR r IN
        SELECT ems_tb_assessment.id AS ems_id,
               tb_assessment.id AS www_id
        FROM ems_tb_assessment
        LEFT JOIN tb_assessment ON ems_tb_assessment.id=tb_assessment.id
        WHERE tb_assessment.id IS NULL
    LOOP
        INSERT INTO tb_assessment(id, name, pid, start, "end") SELECT
            ems.id,
            regexp_replace(ems.name, '\s+', ' ', 'g'),
            ems.programme_id,
            ems.start_date,
            ems.end_date
        FROM ems_tb_assessment as ems
        WHERE ems.id = r.ems_id;
    END LOOP;
    RETURN;
END;
$$
LANGUAGE plpgsql;

SELECT import_assessment();
