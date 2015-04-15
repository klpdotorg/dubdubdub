CREATE OR REPLACE FUNCTION import_student_eval() RETURNS VOID AS
$$
DECLARE
    r RECORD;
BEGIN
    -- first try to update the key
    UPDATE tb_student_eval as www
    SET mark = ems.answer_score::numeric,
        grade = ems.answer_grade
    FROM ems_tb_student_eval as ems
    WHERE www.qid=ems.question_id AND
        www.stuid=ems.student_id AND
        (
            www.mark <> ems.answer_score::numeric(5,2) OR
            www.grade <> ems.answer_grade
        );

    RAISE NOTICE '%', found;

    -- not there, so try to insert the key
    -- if someone else inserts the same key concurrently,
    -- we could get a unique-key failure
    FOR r IN
        SELECT ems_tb_student_eval.question_id AS ems_qid,
               ems_tb_student_eval.object_id AS ems_stuid,
               tb_student_eval.qid AS www_qid,
               tb_student_eval.stuid as www_stuid
        FROM ems_tb_student_eval
        LEFT JOIN tb_student_eval
            ON (
                ems_tb_student_eval.question_id=tb_student_eval.qid AND
                ems_tb_student_eval.object_id=tb_student_eval.stuid
            )
        WHERE tb_student_eval.qid IS NULL
    LOOP
        INSERT INTO tb_student_eval(qid, stuid, mark, grade) SELECT
            ems.question_id,
            ems.object_id,
            ems.answer_score::numeric(5,2),
            ems.answer_grade
        FROM ems_tb_student_eval as ems
        WHERE ems.id = r.ems_qid AND ems.object_id=r.ems_stuid;
    END LOOP;
    RETURN;
END;
$$
LANGUAGE plpgsql;

SELECT import_student_eval();
