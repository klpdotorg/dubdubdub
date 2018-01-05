CREATE OR REPLACE FUNCTION upsert_students()
RETURNS numeric AS $$
declare cnt numeric;
declare err_context text;
BEGIN
    DELETE 
    FROM students_staging
    WHERE ctid NOT IN (SELECT min(ctid) FROM students_staging GROUP BY uid);
    GET DIAGNOSTICS cnt = ROW_COUNT;
    RAISE NOTICE '% duplicates removed', cnt;
 

    UPDATE students_v2 as a
    SET student_id = b.student_id,
    school_code = b.school_code,
    school_name = b.school_name,
    class_num = b.class_num,
    cluster = b.cluster,
    block = b.block,
    district = b.district,
    child_name = b.child_name,
    dob = b.dob,
    sex = substring(b.sex,1,1),
    father_name = b.father_name,
    mother_name = b.mother_name
    FROM students_staging as b
    WHERE a.uid = b.uid;
    GET DIAGNOSTICS cnt = ROW_COUNT;
    RAISE NOTICE '% rows updated', cnt;

    INSERT INTO students_v2
    SELECT uid,
    student_id,
    school_code,
    school_name,
    class_num,
    cluster,
    block,
    district,
    child_name,
    dob,
    substring(sex,1,1),
    father_name,
    mother_name,
    now()
    FROM students_staging a
    WHERE NOT EXISTS (
        SELECT * FROM students_v2 b
        WHERE b.uid = a.uid );
    GET DIAGNOSTICS cnt = ROW_COUNT;
    RAISE NOTICE '% rows inserted', cnt;
    return 0;
    exception
    when others then
        GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RAISE INFO 'Error Context:%', err_context;
        return -1;

END;
$$ LANGUAGE plpgsql;
