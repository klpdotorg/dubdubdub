CREATE OR REPLACE FUNCTION insert_ekstep_usage()
RETURNS numeric AS $$
declare cnt numeric;
declare err_context text;
BEGIN
    DELETE FROM ekstep_usage_staging a USING ekstep_usage b where a.access_uid = b.access_uid;
    GET DIAGNOSTICS cnt = ROW_COUNT;
    RAISE NOTICE '% rows deleted', cnt;

    DELETE FROM ekstep_usage_staging where ctid not in (select min(ctid) from ekstep_usage_staging group by access_uid);
    GET DIAGNOSTICS cnt = ROW_COUNT;
    RAISE NOTICE '% duplicates removed', cnt;

    INSERT INTO ekstep_usage
    SELECT access_uid, student_uid, device_id, time_taken, content_id, accessed_start,accessed_end, sync_ts
    FROM ekstep_usage_staging;
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

