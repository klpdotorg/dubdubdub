DROP TABLE IF EXISTS "tb_institution_assessment_cohorts";
CREATE TABLE "tb_institution_assessment_cohorts" (
  "sid" integer REFERENCES "tb_school" ("id") ON DELETE CASCADE,
  "assid" integer REFERENCES "tb_assessment" ("id") ON DELETE CASCADE,
  "studentgroup" varchar(50),
  "sex" sex,
  "mt" school_moi,
  "cohortsnum" integer,
  PRIMARY KEY  ("sid","assid","studentgroup","sex","mt")
);


DROP TABLE IF EXISTS "tb_institution_assessment_singlescore";
CREATE TABLE "tb_institution_assessment_singlescore"(
  "sid" integer REFERENCES "tb_school" ("id") ON DELETE CASCADE,
  "assid" integer REFERENCES "tb_assessment" ("id") ON DELETE CASCADE,
  "studentgroup" varchar(50),
  "singlescore" numeric(6,2),
  "percentile" numeric(6,2),
  PRIMARY KEY  ("sid","assid","studentgroup")
);

DROP TABLE IF EXISTS "tb_institution_assessment_singlescore_gender";
CREATE TABLE "tb_institution_assessment_singlescore_gender"(
  "sid" integer REFERENCES "tb_school" ("id") ON DELETE CASCADE,
  "assid" integer REFERENCES "tb_assessment" ("id") ON DELETE CASCADE,
  "studentgroup" varchar(50),
  "sex" sex,
  "singlescore" numeric(6,2),
  "percentile" numeric(6,2),
  PRIMARY KEY  ("sid","assid","studentgroup","sex")
);


DROP TABLE IF EXISTS "tb_institution_assessment_singlescore_mt";
CREATE TABLE "tb_institution_assessment_singlescore_mt"(
  "sid" integer REFERENCES "tb_school" ("id") ON DELETE CASCADE,
  "assid" integer REFERENCES "tb_assessment" ("id") ON DELETE CASCADE,
  "studentgroup" varchar(50),
  "mt" school_moi,
  "singlescore" numeric(6,2),
  "percentile" numeric(6,2),
  PRIMARY KEY  ("sid","assid","studentgroup","mt")
);

DROP TABLE IF EXISTS "tb_boundary_assessment_singlescore";
CREATE TABLE "tb_boundary_assessment_singlescore"(
  "bid" integer REFERENCES "tb_boundary" ("id") ON DELETE CASCADE,
  "assid" integer REFERENCES "tb_assessment" ("id") ON DELETE CASCADE,
  "studentgroup" varchar(50),
  "singlescore" numeric(6,2),
  "percentile" numeric(6,2),
  PRIMARY KEY  ("bid","assid","studentgroup")
);

DROP TABLE IF EXISTS "tb_boundary_assessment_singlescore_gender";
CREATE TABLE "tb_boundary_assessment_singlescore_gender"(
  "bid" integer REFERENCES "tb_boundary" ("id") ON DELETE CASCADE,
  "assid" integer REFERENCES "tb_assessment" ("id") ON DELETE CASCADE,
  "studentgroup" varchar(50),
  "sex" sex,
  "singlescore" numeric(6,2),
  "percentile" numeric(6,2),
  PRIMARY KEY  ("bid","assid","studentgroup","sex")
);


DROP TABLE IF EXISTS "tb_boundary_assessment_singlescore_mt";
CREATE TABLE "tb_boundary_assessment_singlescore_mt"(
  "bid" integer REFERENCES "tb_boundary" ("id") ON DELETE CASCADE,
  "assid" integer REFERENCES "tb_assessment" ("id") ON DELETE CASCADE,
  "studentgroup" varchar(50),
  "mt" school_moi,
  "singlescore" numeric(6,2),
  "percentile" numeric(6,2),
  PRIMARY KEY  ("bid","assid","studentgroup","mt")
);




DROP FUNCTION fill_inst_assess_cohorts(int,character(50),int,int[]);
CREATE OR REPLACE function fill_inst_assess_cohorts(int,character(50),int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
        query:='SELECT distinct s.id as id,ass.id as assid,sg.name as sgname,c.sex as sex, c.mt as mt, count(distinct stu.id) AS count FROM tb_student_eval se,tb_question q,tb_assessment ass,tb_student stu, tb_class sg, tb_student_class stusg, tb_child c, tb_school s,tb_programme p WHERE se.stuid=stu.id and se.qid=q.id and q.assid=ass.id and ass.pid=p.id and stusg.stuid=stu.id and stusg.clid=sg.id AND sg.sid = s.id AND sg.name='||$2||'::text and stu.cid = c.id AND stusg.ayid ='|| $1||' and ass.id='||$3||' and stusg.ayid=p.ayid and (se.grade is not null or se.mark is not null)';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and (se.grade is not null or se.mark is not null) and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'GROUP BY s.id, ass.id,sg.name,c.sex,c.mt'; 
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_institution_assessment_cohorts values (schs.id, schs.assid, schs.sgname,schs.sex, schs.mt, schs.count);
        end loop;
end;
$$ language plpgsql;


DROP function fill_agg_singlescore(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT innerloop.sid as id,innerloop.sgname as sgname, round((sum(innerloop.totscore)/count(innerloop.stuid))*100/assmaxscore.maxscore) as mean FROM( select distinct se.stuid as stuid, sg.sid as sid,q.assid as assid, sum(case when q.qtype=1 then se.mark else se.grade::int end) as totscore,sg.name as sgname from tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q WHERE se.stuid=stusg.stuid and se.qid=q.id and  stusg.clid=sg.id AND stusg.ayid = '||inayid||' and sg.name='||insgname||'::text and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and (se.grade is not null or se.mark is not null)';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and (se.grade is not null or se.mark is not null) and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by se.stuid,sg.sid,sg.name,q.assid ) as innerloop,(select sum(case when qtype=1 then maxmarks else 1 end) as maxscore from tb_question where assid='||inassid||' and ("desc" !~ ''^.*(AB|Attendance|Parihara).*''))as assmaxscore group by innerloop.sid,innerloop.sgname,assmaxscore.maxscore';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_institution_assessment_singlescore values (schs.id,inassid,schs.sgname, schs.mean);
        end loop;
end;
$$ language plpgsql;


DROP function fill_agg_singlescore_gender(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_gender(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT innerloop.sid as id,innerloop.sgname as sgname,innerloop.gender as gender, round((sum(innerloop.totscore)/count(innerloop.stuid))*100/assmaxscore.maxscore) as mean FROM( select distinct se.stuid as stuid, sg.sid as sid,q.assid as assid,c.sex as gender, sum(case when q.qtype=1 then se.mark else se.grade::int end) as totscore,sg.name as sgname from tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='||insgname||'::text and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and (se.grade is not null or se.mark is not null)';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and (se.grade is not null or se.mark is not null) and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by se.stuid,sg.sid,sg.name,q.assid,c.sex ) as innerloop,(select sum(case when qtype=1 then maxmarks else 1 end) as maxscore from tb_question where assid='||inassid||'and ("desc"  !~ ''^.*(AB|Attendance|Parihara).*''))as assmaxscore group by innerloop.sid,innerloop.sgname,innerloop.gender,assmaxscore.maxscore';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_institution_assessment_singlescore_gender values (schs.id,inassid,schs.sgname,schs.gender, schs.mean);
        end loop;
end;
$$ language plpgsql;



DROP function fill_agg_singlescore_mt(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_mt(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
        query:='SELECT innerloop.sid as id,innerloop.sgname as sgname,innerloop.mt as mt, round((sum(innerloop.totscore)/count(innerloop.stuid))*100/assmaxscore.maxscore) as mean FROM( select distinct se.stuid as stuid, sg.sid as sid,c.mt as mt,q.assid as assid, sum(case when q.qtype=1 then se.mark else se.grade::int end) as totscore,sg.name as sgname from tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and stu.cid=c.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id AND stusg.ayid = '||inayid||' and sg.name='||insgname||'::text and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and (se.grade is not null or se.mark is not null)';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and (se.grade is not null or se.mark is not null) and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by se.stuid,sg.sid,sg.name,c.mt,q.assid ) as innerloop,(select sum(case when qtype=1 then maxmarks else 1 end) as maxscore from tb_question where assid='||inassid||'and ("desc"  !~ ''^.*(AB|Attendance|Parihara).*''))as assmaxscore group by innerloop.sid,innerloop.sgname,innerloop.mt,assmaxscore.maxscore';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_institution_assessment_singlescore_mt values (schs.id,inassid,schs.sgname,schs.mt, schs.mean);
        end loop;
end;
$$ language plpgsql;


DROP function fill_agg_singlescore_admin3(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_admin3(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
        query:='SELECT innerloop.admin3 as admin3,innerloop.sgname as sgname, round((sum(innerloop.totscore)/count(innerloop.stuid))*100/assmaxscore.maxscore) as mean FROM( select distinct se.stuid as stuid,s.bid as admin3,q.assid as assid, sum(case when q.qtype=1 then se.mark else se.grade::int end) as totscore,sg.name as sgname from tb_school s, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q WHERE se.stuid=stusg.stuid and se.qid=q.id and stusg.clid=sg.id and sg.sid=s.id AND stusg.ayid = '||inayid||' and sg.name='||insgname||'::text and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'' ) and (se.grade is not null or se.mark is not null)';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and (se.grade is not null or se.mark is not null)and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by se.stuid,s.bid,sg.name,q.assid ) as innerloop,(select sum(case when qtype=1 then maxmarks else 1 end) as maxscore from tb_question where assid='||inassid||'and ("desc"  !~ ''^.*(AB|Attendance|Parihara).*''))as assmaxscore group by innerloop.admin3,innerloop.sgname,assmaxscore.maxscore';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_boundary_assessment_singlescore values (schs.admin3,inassid,schs.sgname, schs.mean);
        end loop;
end;
$$ language plpgsql;


DROP function fill_agg_singlescore_admin3_gender(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_admin3_gender(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT innerloop.admin3 as admin3,innerloop.sgname as sgname,innerloop.gender as gender, round((sum(innerloop.totscore)/count(innerloop.stuid))*100/assmaxscore.maxscore) as mean FROM( select distinct se.stuid as stuid, s.bid  as admin3,q.assid as assid,c.sex as gender, sum(case when q.qtype=1 then se.mark else  se.grade::int end) as totscore,sg.name as sgname from tb_school s, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='||insgname||'::text and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and (se.grade is not null or se.mark is not null)';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and (se.grade is not null or se.mark is not null) and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by se.stuid,s.bid,sg.name,q.assid,c.sex ) as innerloop,(select sum(case when qtype=1 then maxmarks else 1 end) as maxscore from tb_question where assid='||inassid||'and ("desc"  !~ ''^.*(AB|Attendance|Parihara).*''))as assmaxscore group by innerloop.admin3,innerloop.sgname,innerloop.gender,assmaxscore.maxscore';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_boundary_assessment_singlescore_gender values (schs.admin3,inassid,schs.sgname,schs.gender, schs.mean);
        end loop;
end;
$$ language plpgsql;



DROP function fill_agg_singlescore_admin3_mt(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_admin3_mt(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
        query:='SELECT innerloop.admin3 as admin3,innerloop.sgname as sgname,innerloop.mt as mt, round((sum(innerloop.totscore)/count(innerloop.stuid))*100/assmaxscore.maxscore) as mean FROM( select distinct se.stuid as stuid, s.bid as admin3,c.mt as mt,q.assid as assid, sum(case when q.qtype=1 then se.mark else se.grade::int end) as totscore,sg.name as sgname from tb_school s, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and stu.cid=c.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id AND stusg.ayid = '||inayid||' and sg.name='||insgname||'::text and q.id in (select distinct id from tb_question where assid ='||inassid||' and ("desc"  !~ ''^.*(AB|Attendance|Parihara).*'')) and (se.grade is not null or se.mark is not null)';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and (se.grade is not null or se.mark is not null) and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by se.stuid,s.bid,sg.name,c.mt,q.assid ) as innerloop,(select sum(case when qtype=1 then maxmarks else 1 end) as maxscore from tb_question where assid='||inassid||'and ("desc"  !~ ''^.*(AB|Attendance|Parihara).*''))as assmaxscore group by innerloop.admin3,innerloop.sgname,innerloop.mt,assmaxscore.maxscore';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_boundary_assessment_singlescore_mt values (schs.admin3,inassid,schs.sgname,schs.mt, schs.mean);
        end loop;
end;
$$ language plpgsql;



DROP function fill_agg_singlescore_admin2(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_admin2(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
        query:='SELECT innerloop.admin2 as admin2,innerloop.sgname as sgname, round((sum(innerloop.totscore)/count(innerloop.stuid))*100/assmaxscore.maxscore) as mean FROM( select distinct se.stuid as stuid,b.parent as admin2,q.assid as assid, sum(case when q.qtype=1 then se.mark else se.grade::int end) as totscore,sg.name as sgname from tb_boundary b, tb_school s, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q WHERE se.stuid=stusg.stuid and se.qid=q.id and  stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id AND stusg.ayid = '||inayid||' and sg.name='||insgname||'::text and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and (se.grade is not null or se.mark is not null)';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and (se.grade is not null or se.mark is not null)and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by se.stuid,b.parent,sg.name,q.assid ) as innerloop,(select sum(case when qtype=1 then maxmarks else 1 end) as maxscore from tb_question where assid='||inassid||'and ("desc"  !~ ''^.*(AB|Attendance|Parihara).*''))as assmaxscore group by innerloop.admin2,innerloop.sgname,assmaxscore.maxscore';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_boundary_assessment_singlescore values (schs.admin2,inassid,schs.sgname, schs.mean);
        end loop;
end;
$$ language plpgsql;


DROP function fill_agg_singlescore_admin2_gender(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_admin2_gender(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT innerloop.admin2 as admin2,innerloop.sgname as sgname,innerloop.gender as gender, round((sum(innerloop.totscore)/count(innerloop.stuid))*100/assmaxscore.maxscore) as mean FROM( select distinct se.stuid as stuid, b.parent as admin2,q.assid as assid,c.sex as gender, sum(case when q.qtype=1 then se.mark else se.grade::int end) as totscore,sg.name as sgname from tb_school s, tb_boundary b, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='||insgname||'::text and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'' )and (se.grade is not null or se.mark is not null)';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and (se.grade is not null or se.mark is not null) and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by se.stuid,b.parent,sg.name,q.assid,c.sex ) as innerloop,(select sum(case when qtype=1 then maxmarks else 1 end) as maxscore from tb_question where assid='||inassid||'and ("desc"  !~ ''^.*(AB|Attendance|Parihara).*''))as assmaxscore group by innerloop.admin2,innerloop.sgname,innerloop.gender,assmaxscore.maxscore';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_boundary_assessment_singlescore_gender values (schs.admin2,inassid,schs.sgname,schs.gender, schs.mean);
        end loop;
end;
$$ language plpgsql;



DROP function fill_agg_singlescore_admin2_mt(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_admin2_mt(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
        query:='SELECT innerloop.admin2 as admin2,innerloop.sgname as sgname,innerloop.mt as mt, round((sum(innerloop.totscore)/count(innerloop.stuid))*100/assmaxscore.maxscore) as mean FROM( select distinct se.stuid as stuid, b.parent as admin2,c.mt as mt,q.assid as assid, sum(case when q.qtype=1 then se.mark else  se.grade::int end) as totscore,sg.name as sgname from tb_school s,tb_boundary b, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and stu.cid=c.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id AND stusg.ayid = '||inayid||' and sg.name='||insgname||'::text and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and (se.grade is not null or se.mark is not null)';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and (se.grade is not null or se.mark is not null) and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by se.stuid,b.parent,sg.name,c.mt,q.assid ) as innerloop,(select sum(case when qtype=1 then maxmarks else 1 end) as maxscore from tb_question where assid='||inassid||'and ("desc"  !~ ''^.*(AB|Attendance|Parihara).*''))as assmaxscore group by innerloop.admin2,innerloop.sgname,innerloop.mt,assmaxscore.maxscore';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_boundary_assessment_singlescore_mt values (schs.admin2,inassid,schs.sgname,schs.mt, schs.mean);
        end loop;
end;
$$ language plpgsql;




DROP function fill_agg_singlescore_admin1(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_admin1(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
        query:='SELECT innerloop.admin1 as admin1,innerloop.sgname as sgname, round((sum(innerloop.totscore)/count(innerloop.stuid))*100/assmaxscore.maxscore) as mean FROM( select distinct se.stuid as stuid, b1.parent as admin1,q.assid as assid, sum(case when q.qtype=1 then se.mark else se.grade::int end) as totscore,sg.name as sgname from tb_boundary b,tb_boundary b1, tb_school s, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q WHERE se.stuid=stusg.stuid and se.qid=q.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id and b.parent=b1.id AND stusg.ayid = '||inayid||' and sg.name='||insgname||'::text and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and (se.grade is not null or se.mark is not null)';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and (se.grade is not null or se.mark is not null)and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by se.stuid,b1.parent,sg.name,q.assid ) as innerloop,(select sum(case when qtype=1 then maxmarks else 1 end) as maxscore from tb_question where assid='||inassid||'and ("desc"  !~ ''^.*(AB|Attendance|Parihara).*''))as assmaxscore group by innerloop.admin1,innerloop.sgname,assmaxscore.maxscore';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_boundary_assessment_singlescore values (schs.admin1,inassid,schs.sgname, schs.mean);
        end loop;
end;
$$ language plpgsql;


DROP function fill_agg_singlescore_admin1_gender(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_admin1_gender(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT innerloop.admin1 as admin1,innerloop.sgname as sgname,innerloop.gender as gender, round((sum(innerloop.totscore)/count(innerloop.stuid))*100/assmaxscore.maxscore) as mean FROM( select distinct se.stuid as stuid, b1.parent as admin1,q.assid as assid,c.sex as gender, sum(case when q.qtype=1 then se.mark else se.grade::int end) as totscore,sg.name as sgname from tb_school s, tb_boundary b,tb_boundary b1, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id and b.parent=b1.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='||insgname||'::text and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and (se.grade is not null or se.mark is not null)';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and (se.grade is not null or se.mark is not null) and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by se.stuid,b1.parent,sg.name,q.assid,c.sex ) as innerloop,(select sum(case when qtype=1 then maxmarks else 1 end) as maxscore from tb_question where assid='||inassid||'and ("desc"  !~ ''^.*(AB|Attendance|Parihara).*''))as assmaxscore group by innerloop.admin1,innerloop.sgname,innerloop.gender,assmaxscore.maxscore';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_boundary_assessment_singlescore_gender values (schs.admin1,inassid,schs.sgname,schs.gender, schs.mean);
        end loop;
end;
$$ language plpgsql;



DROP function fill_agg_singlescore_admin1_mt(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_admin1_mt(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
        query:='SELECT innerloop.admin1 as admin1,innerloop.sgname as sgname,innerloop.mt as mt, round((sum(innerloop.totscore)/count(innerloop.stuid))*100/assmaxscore.maxscore) as mean FROM( select distinct se.stuid as stuid, b1.parent as admin1,c.mt as mt,q.assid as assid, sum(case when q.qtype=1 then se.mark else  se.grade::int end) as totscore,sg.name as sgname from tb_school s,tb_boundary b,tb_boundary b1, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and stu.cid=c.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id and b.parent=b1.id AND stusg.ayid = '||inayid||' and sg.name='||insgname||'::text and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and (se.grade is not null or se.mark is not null)';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and (se.grade is not null or se.mark is not null) and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by se.stuid,b1.parent,sg.name,c.mt,q.assid ) as innerloop,(select sum(case when qtype=1 then maxmarks else 1 end) as maxscore from tb_question where assid='||inassid||'and ("desc"  !~ ''^.*(AB|Attendance|Parihara).*''))as assmaxscore group by innerloop.admin1,innerloop.sgname,innerloop.mt,assmaxscore.maxscore';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_boundary_assessment_singlescore_mt values (schs.admin1,inassid,schs.sgname,schs.mt, schs.mean);
        end loop;
end;
$$ language plpgsql;



drop function cohorts_wrapper(int);
CREATE OR REPLACE function cohorts_wrapper(inpid int)returns void as $$
declare
        schs RECORD;
begin        
        for schs in 
        select distinct p.ayid as ayid,sg.name as sgname, array_agg(distinct ass.id) assid_arr from tb_assessment ass,tb_programme p,tb_student_eval se,tb_student_class stusg,tb_class sg,tb_question q where se.qid=q.id and q.assid=ass.id and ass.pid=p.id and p.id=inpid and se.stuid=stusg.stuid and stusg.clid=sg.id and stusg.ayid=p.ayid group by p.ayid,sg.name
        loop
            for i in 1..array_length(schs.assid_arr,1) 
            loop
                RAISE NOTICE '%,%,%,%,%',inpid,schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr;
                perform fill_inst_assess_cohorts(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                RAISE NOTICE 'cohort done';
                perform fill_agg_singlescore(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                perform fill_agg_singlescore_mt(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                perform fill_agg_singlescore_gender(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                RAISE NOTICE 'singlescore done';
            end loop;
        end loop;
end;
$$ language plpgsql;

drop function cohorts_wrapper_boundary(int);
CREATE OR REPLACE function cohorts_wrapper_boundary(inpid int)returns void as $$
declare
        schs RECORD;
begin        
        for schs in 
        select distinct p.ayid as ayid,sg.name as sgname, array_agg(distinct ass.id) assid_arr from tb_assessment ass,tb_programme p,tb_student_eval se,tb_student_class stusg,tb_class sg,tb_question q where se.qid=q.id and q.assid=ass.id and ass.pid=p.id and p.id=inpid and se.stuid=stusg.stuid and stusg.clid=sg.id and stusg.ayid=p.ayid group by p.ayid,sg.name
        loop
            for i in 1..array_length(schs.assid_arr,1) 
            loop
                RAISE NOTICE '%,%,%,%,%',inpid,schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr;
 
                perform fill_agg_singlescore_admin1(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                perform fill_agg_singlescore_admin1_mt(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                perform fill_agg_singlescore_admin1_gender(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                RAISE NOTICE 'admin1 done';
                perform fill_agg_singlescore_admin2(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                perform fill_agg_singlescore_admin2_mt(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                perform fill_agg_singlescore_admin2_gender(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                RAISE NOTICE 'admin2 done';
                perform fill_agg_singlescore_admin3(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                perform fill_agg_singlescore_admin3_mt(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                perform fill_agg_singlescore_admin3_gender(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                RAISE NOTICE 'admin3 done';

            end loop;
        end loop;
end;
$$ language plpgsql;
