CREATE MATERIALIZED VIEW mvw_libinfra AS
SELECT t1.sid,
    t1.libstatus,
    t1.handoveryear,
    t1.libtype,
    t1.numbooks,
    t1.numracks,
    t1.numtables,
    t1.numchairs,
    t1.numcomputers,
    t1.numups
FROM dblink('host=localhost dbname=libinfra user=klp password=klp'::text, 'select * from tb_libinfra'::text) t1(sid integer, libstatus character varying(300), handoveryear integer, libtype character varying(300), numbooks integer, numracks integer, numtables integer, numchairs integer, numcomputers integer, numups integer);

CREATE MATERIALIZED VIEW mvw_lib_borrow AS
SELECT t1.trans_year,
    t1.class,
    t1.issue_date,
    t1.klp_school_id,
    t1.school_name,
    t1.klp_child_id
FROM dblink('host=localhost dbname=library user=klp password=klp'::text, 'select trans_year,class,issue_date,klp_school_id,school_name,klp_child_id from libentry where flag is not null'::text) t1(trans_year character varying(30), class numeric(3,0), issue_date character varying(20), klp_school_id numeric(7,0), school_name character varying(50), klp_child_id character varying(30));

CREATE MATERIALIZED VIEW mvw_lib_lang_agg AS
SELECT t1.klp_school_id,
    t1.class,
    t1.month,
    t1.year,
    t1.book_lang,
    t1.child_count
FROM dblink('host=localhost dbname=library user=klp password=klp'::text, 'select * from lang_agg'::text) t1(klp_school_id integer, class integer, month character varying(10), year character varying(10), book_lang character varying(50), child_count integer);

CREATE MATERIALIZED VIEW mvw_lib_level_agg AS
SELECT t1.klp_school_id,
    t1.class,
    t1.month,
    t1.year,
    t1.book_level,
    t1.child_count
FROM dblink('host=localhost dbname=library user=klp password=klp'::text, 'select * from level_agg'::text) t1(klp_school_id integer, class integer, month character varying(10), year character varying(10), book_level character varying(50), child_count integer);
