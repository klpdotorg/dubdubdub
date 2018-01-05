CREATE OR REPLACE FUNCTION insert_ekstep_assess()
RETURNS numeric AS $$
declare cnt numeric;
declare err_context text;
BEGIN
    DELETE FROM ekstep_assess_staging a USING ekstep_assess b where a.assess_uid = b.assess_uid;
    GET DIAGNOSTICS cnt = ROW_COUNT;
    RAISE NOTICE '% rows deleted', cnt;

    DELETE FROM ekstep_assess_staging where ctid not in (select min(ctid) from ekstep_assess_staging group by assess_uid,question_id, question_idx);
    GET DIAGNOSTICS cnt = ROW_COUNT;
    RAISE NOTICE '% duplicates removed', cnt;

    INSERT INTO ekstep_assess
    SELECT assess_uid, student_uid, device_id, content_id, question_idx, question_id, time_taken, assessed_ts,
           score, pass, result, question_title, sync_ts
    FROM ekstep_assess_staging;
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


