CREATE OR REPLACE FUNCTION del_staging()
RETURNS numeric AS $$
declare cnt numeric;
declare err_context text;
BEGIN
    DELETE
    FROM ekstep_usage_staging;
    GET DIAGNOSTICS cnt = ROW_COUNT;
    RAISE NOTICE '% rows deleted usage_staging', cnt;

    DELETE
    FROM ekstep_assess_staging;
    GET DIAGNOSTICS cnt = ROW_COUNT;
    RAISE NOTICE '% rows deleted assess_staging', cnt;

    DELETE 
    FROM students_staging a USING students_v2 b 
    where a.uid = b.uid;
    GET DIAGNOSTICS cnt = ROW_COUNT;
    RAISE NOTICE '% rows deleted students_staging', cnt;

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

