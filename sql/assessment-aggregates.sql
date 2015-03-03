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

DROP TABLE IF EXISTS "tb_institution_assessment_singlescore_boundary";
CREATE TABLE "tb_institution_assessment_singlescore_mt"(
  "bid" integer REFERENCES "tb_boundary" ("id") ON DELETE CASCADE,
  "assid" integer REFERENCES "tb_assessment" ("id") ON DELETE CASCADE,
  "studentgroup" varchar(50),
  "singlescore" numeric(6,2),
  "percentile" numeric(6,2),
  PRIMARY KEY  ("bid","assid","studentgroup")
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


DROP function fill_agg_singlescore_grade(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_grade(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
        query:='SELECT innerloop.sid as id,innerloop.sgname as sgname, round((sum(innerloop.totscore)/count(innerloop.stuid))*100/assmaxscore.maxscore) as mean FROM( select distinct se.stuid as stuid, sg.sid as sid,q.assid as assid, sum(se.grade::int) as totscore,sg.name as sgname from tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id AND stusg.ayid = '||inayid||' and sg.name='||insgname||'::text and q.id in (select distinct id from tb_question where assid ='||inassid||' and se.grade is not null)';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and se.grade is not null and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by se.stuid,sg.sid,sg.id,q.assid ) as innerloop,(select count(*) as maxscore from tb_question where assid='||inassid||')as assmaxscore group by innerloop.sid,innerloop.sgname,assmaxscore.maxscore';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_institution_assessment_singlescore values (schs.id,inassid,schs.sgname, schs.mean);
        end loop;
end;
$$ language plpgsql;



DROP function fill_agg_singlescore_mark(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_mark(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
        query:='SELECT innerloop.sid as id,innerloop.sgname as sgname, round((sum(innerloop.totscore)/count(innerloop.stuid))*100/assmaxscore.maxscore) as mean FROM( select distinct se.stuid as stuid, sg.sid as sid,q.assid as assid, sum(se.mark) as totscore,sg.name as sgname from tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id AND stusg.ayid = '||inayid||' and sg.name='||insgname||'::text and q.id in (select distinct id from tb_question where assid ='||inassid||' and se.mark is not null)';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and se.mark is not null and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by se.stuid,sg.sid,sg.id,q.assid ) as innerloop,(select sum(maxmarks) as maxscore from tb_question where assid='||inassid||')as assmaxscore group by innerloop.sid,innerloop.sgname,assmaxscore.maxscore';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_institution_assessment_singlescore values (schs.id,inassid,schs.sgname, schs.mean);
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
                perform fill_agg_singlescore_mark(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                perform fill_agg_singlescore_grade(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
            end loop;
        end loop;
end;
$$ language plpgsql;





