CREATE OR REPLACE FUNCTION import_question() RETURNS VOID AS
$$
DECLARE
    r RECORD;
BEGIN
    -- first try to update the key
    UPDATE tb_question as www
    SET assid = ems.assessment_id,
        "desc" = regexp_replace(ems.name, '\s+', ' ', 'g'),
        qtype = ems.question_type,
        maxmarks = ems.score_max::numeric,
        minmarks = ems.score_min::numeric,
        grade = ems.grade
    FROM ems_tb_question as ems
    WHERE www.id=ems.id AND
        (
            assid <> ems.assessment_id OR
            "desc" <> regexp_replace(ems.name, '\s+', ' ', 'g') OR
            qtype <> ems.question_type OR
            maxmarks <> ems.score_max::numeric OR
            minmarks <> ems.score_min::numeric OR
            www.grade <> ems.grade
        );

    RAISE NOTICE '%', found;

    -- not there, so try to insert the key
    -- if someone else inserts the same key concurrently,
    -- we could get a unique-key failure
    FOR r IN
        SELECT ems_tb_question.id AS ems_id,
               tb_question.id AS www_id
        FROM ems_tb_question
        LEFT JOIN tb_question ON ems_tb_question.id=tb_question.id
        WHERE tb_question.id IS NULL
    LOOP
        RAISE NOTICE 'NEW QUESTION: %', r.ems_id;
        INSERT INTO tb_question(id, assid, "desc", qtype, maxmarks, minmarks, grade) SELECT
            ems.id,
            ems.assessment_id,
            regexp_replace(ems.name, '\s+', ' ', 'g'),
            ems.question_type,
            ems.score_max::numeric,
            ems.score_min::numeric,
            ems.grade
        FROM ems_tb_question as ems
        WHERE ems.id = r.ems_id;
    END LOOP;
    RETURN;
END;
$$
LANGUAGE plpgsql;

SELECT import_question();
