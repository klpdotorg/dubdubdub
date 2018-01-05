CREATE OR REPLACE FUNCTION insert_assess_gka()
RETURNS numeric AS $$
declare cnt numeric;
declare err_context text;
BEGIN
    DELETE FROM assessments_v2 a USING ekstep_assess_staging  b where a.assess_uid = b.assess_uid;
    GET DIAGNOSTICS cnt = ROW_COUNT;
    RAISE NOTICE '% rows deleted', cnt;

    INSERT INTO assessments_v2
    SELECT assess_uid, student_uid::uuid, a.device_id,NULL, question_id, a.content_id, question_idx, pass, score::integer, 
           to_json(result), time_taken::integer, NULL,NULL, assessed_ts  
    FROM  ekstep_assess_staging a, gka_devices b, gka_content c
    WHERE a.device_id = b.device_id
    AND   a.content_id = c.content_id;
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


