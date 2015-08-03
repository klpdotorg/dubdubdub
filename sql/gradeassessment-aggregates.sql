ALTER TABLE tb_institution_assessment_singlescore ADD COLUMN gradesinglescore character(30);
ALTER TABLE tb_institution_assessment_singlescore_gender ADD COLUMN gradesinglescore character(30);
ALTER TABLE tb_institution_assessment_singlescore_mt ADD COLUMN gradesinglescore character(30);
ALTER TABLE tb_boundary_assessment_singlescore ADD COLUMN gradesinglescore character(30);
ALTER TABLE tb_boundary_assessment_singlescore_gender ADD COLUMN gradesinglescore character(30);
ALTER TABLE tb_boundary_assessment_singlescore_mt ADD COLUMN gradesinglescore character(30);


CREATE OR REPLACE FUNCTION grade_median(NUMERIC[])
   RETURNS NUMERIC AS
$$
   SELECT (case when count(distinct val)=1 then min(val) else 100 end)
   FROM (
     SELECT val
     FROM unnest($1) val
     ORDER BY 1
     LIMIT  2 - MOD(array_upper($1, 1), 2)
     OFFSET CEIL(array_upper($1, 1) / 2.0) - 1
   ) sub;
$$
LANGUAGE 'sql' IMMUTABLE;


DROP function fill_agg_singlescore_grade(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_grade(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT sid as id,sgname as sgname, case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then ''S'' when 5 then ''P'' else ''NA'' end as mediangrade FROM( select sg.sid as sid ,sg.name as sgname,array_agg(case trim(se.grade) when ''O'' then 1 when ''0'' then 1 when ''L'' then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 end) as inarr from tb_student_eval se,tb_question q, tb_student_class stusg,tb_class sg where se.stuid=stusg.stuid and se.qid=q.id and stusg.clid=sg.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and se.grade is not null and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by sg.sid,sg.name ) as innerloop group by sid,sgname,inarr';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_institution_assessment_singlescore values (schs.id,inassid,schs.sgname,null,null, schs.mediangrade);
        end loop;
end;
$$ language plpgsql;


DROP function fill_agg_singlescore_grade_gender(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_grade_gender(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT sid as id,sgname as sgname,gender as gender, case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then ''S'' when 5 then      ''P'' else ''NA'' end as mediangrade FROM( select distinct sg.sid as sid,c.sex as gender, sg.name as sgname ,array_agg(case trim(se.grade) when ''O'' then 1 when ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 end) as inarr from tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and se.grade is not null  and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by sg.sid,sg.name,c.sex ) as innerloop group by sid,sgname,gender,inarr';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_institution_assessment_singlescore_gender values (schs.id,inassid,schs.sgname,schs.gender,null,null, schs.mediangrade);
        end loop;
end;
$$ language plpgsql;

DROP function fill_agg_singlescore_grade_mt(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_grade_mt(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT sid as id,sgname as sgname,mt as mt, case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then ''S'' when 5 then      ''P'' else ''NA'' end as mediangrade FROM( select distinct sg.sid as sid,c.mt as mt, sg.name as sgname ,array_agg(case trim(se.grade) when ''O'' then 1 when ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 end) as inarr from tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and se.grade is not null  and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by sg.sid,sg.name,c.mt) as innerloop group by sid,sgname,mt,inarr';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_institution_assessment_singlescore_mt values (schs.id,inassid,schs.sgname,schs.mt,null,null, schs.mediangrade);
        end loop;
end;
$$ language plpgsql;

DROP function fill_agg_singlescore_grade_admin3(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_grade_admin3(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
        query:='SELECT admin3 as admin3,sgname as sgname, case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then ''S'' when 5 then      ''P'' else ''NA'' end as mediangrade FROM( select distinct s.bid as admin3, sg.name as sgname, array_agg(case trim(se.grade) when ''O'' then 1 when ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 end) as inarr from tb_school s, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q WHERE se.stuid=stusg.stuid and se.qid=q.id and stusg.clid=sg.id and sg.sid=s.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'' ) and se.grade is not null';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and se.grade is not null and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by s.bid,sg.name) as innerloop group by admin3,sgname,inarr';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_boundary_assessment_singlescore values (schs.admin3,inassid,schs.sgname,null,null, schs.mediangrade);
        end loop;
end;
$$ language plpgsql;


DROP function fill_agg_singlescore_grade_admin3_gender(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_grade_admin3_gender(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin3 as admin3,sgname as sgname,gender as gender,case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then ''S'' when  5 then      ''P'' else ''NA'' end as mediangrade FROM( select distinct s.bid  as admin3,c.sex as gender, sg.name as sgname,array_agg(case trim(se.grade) when ''O'' then 1 when   ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 end) as inarr from tb_school s, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and se.grade is not null and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by s.bid,sg.name,c.sex ) as innerloop group by admin3,sgname,gender,inarr';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_boundary_assessment_singlescore_gender values (schs.admin3,inassid,schs.sgname,schs.gender,null,null, schs.mediangrade);
        end loop;
end;
$$ language plpgsql;

DROP function fill_agg_singlescore_grade_admin3_mt(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_grade_admin3_mt(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin3 as admin3,sgname as sgname,mt as mt,case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then ''S'' when  5 then      ''P'' else ''NA'' end as mediangrade FROM( select distinct s.bid  as admin3,c.mt as mt, sg.name as sgname,array_agg(case trim(se.grade) when ''O'' then 1 when   ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 end) as inarr from tb_school s, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and se.grade is not null and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by s.bid,sg.name,c.mt) as innerloop group by admin3,sgname,mt,inarr';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_boundary_assessment_singlescore_mt values (schs.admin3,inassid,schs.sgname,schs.mt,null,null, schs.mediangrade);
        end loop;
end;
$$ language plpgsql;


DROP function fill_agg_singlescore_grade_admin2(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_grade_admin2(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin2 as admin2,sgname as sgname,case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then ''S''   when  5 then      ''P'' else ''NA'' end as mediangrade  FROM( select distinct b.parent as admin2,sg.name as sgname,array_agg(case trim(se.grade) when    ''O'' then 1 when   ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 end) as inarr from tb_boundary b, tb_school s, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q WHERE se.stuid=stusg.stuid and se.qid=q.id and  stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and se.grade is not null and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by b.parent,sg.name ) as innerloop group by admin2,sgname,inarr';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_boundary_assessment_singlescore values (schs.admin2,inassid,schs.sgname,null,null, schs.mediangrade);
        end loop;
end;
$$ language plpgsql;


DROP function fill_agg_singlescore_grade_admin2_gender(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_grade_admin2_gender(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin2 as admin2,sgname as sgname,gender as gender,case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then ''S''   when  5  then      ''P'' else ''NA'' end as mediangrade FROM( select distinct b.parent as admin2,c.sex as gender,sg.name as sgname,array_agg(case trim(se.grade) when    ''O'' then 1     when   ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 end) as inarr from tb_school s, tb_boundary b, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'' )and se.grade is not null';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and se.grade is not null and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by b.parent,sg.name,c.sex ) as innerloop group by admin2,sgname,gender,inarr';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_boundary_assessment_singlescore_gender values (schs.admin2,inassid,schs.sgname,schs.gender,null,null, schs.mediangrade);
        end loop;
end;
$$ language plpgsql;

DROP function fill_agg_singlescore_grade_admin2_mt(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_grade_admin2_mt(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin2 as admin2,sgname as sgname,mt as mt,case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then ''S''   when  5  then      ''P'' else ''NA'' end as mediangrade FROM( select distinct b.parent as admin2,c.mt as mt,sg.name as sgname,array_agg(case trim(se.grade) when    ''O'' then 1     when   ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 end) as inarr from tb_school s, tb_boundary b, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'' )and se.grade is not null';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and se.grade is not null and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by b.parent,sg.name,c.mt) as innerloop group by admin2,sgname,mt,inarr';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_boundary_assessment_singlescore_mt values (schs.admin2,inassid,schs.sgname,schs.mt,null,null, schs.mediangrade);
        end loop;
end;
$$ language plpgsql;


DROP function fill_agg_singlescore_grade_admin1(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_grade_admin1(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin1 as admin1,sgname as sgname,case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then         ''S''   when  5  then      ''P'' else ''NA'' end as mediangrade  FROM( select distinct  b1.parent as admin1,sg.name as sgname,array_agg(case trim(se.     grade) when    ''O'' then 1     when   ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 end) as inarr from tb_boundary b,tb_boundary b1, tb_school s, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q WHERE se.stuid=stusg.stuid and se.qid=q.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id and b.parent=b1.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and se.grade is not null and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by b1.parent,sg.name ) as innerloop group by admin1,sgname,inarr';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_boundary_assessment_singlescore values (schs.admin1,inassid,schs.sgname,null,null, schs.mediangrade);
        end loop;
end;
$$ language plpgsql;


DROP function fill_agg_singlescore_grade_admin1_gender(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_grade_admin1_gender(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin1 as admin1,sgname as sgname,gender as gender,case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then         ''S''    when  5  then      ''P'' else ''NA'' end as mediangrade  FROM( select distinct  b1.parent as admin1,c.sex as gender,sg.name as sgname,array_agg(case trim(se.     grade) when     ''O'' then 1     when   ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 end) as inarr from tb_school s, tb_boundary b,tb_boundary b1, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id and b.parent=b1.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and se.grade is not null and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by b1.parent,sg.name,c.sex ) as innerloop group by admin1,sgname,gender,inarr';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_boundary_assessment_singlescore_gender values (schs.admin1,inassid,schs.sgname,schs.gender,null,null, schs.mediangrade);
        end loop;
end;
$$ language plpgsql;



DROP function fill_agg_singlescore_grade_admin1_mt(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_grade_admin1_mt(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin1 as admin1,sgname as sgname,mt as mt ,case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4      then         ''S''    when  5  then      ''P'' else ''NA'' end as mediangrade FROM( select distinct  b1.parent as admin1,c.mt as mt,sg.name as sgname, array_agg(case trim(se.     grade) when     ''O'' then 1     when   ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 end)   as inarr from tb_school s,tb_boundary b,tb_boundary b1, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and stu.cid=c.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id and b.parent=b1.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select se.stuid from tb_student_eval se,tb_question q where se.qid=q.id and se.grade is not null and q.assid = '||inallassid[i]||')';
        end loop;
        query=query||'group by b1.parent,sg.name,c.mt ) as innerloop group by admin1,sgname,mt,inarr';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_boundary_assessment_singlescore_mt values (schs.admin1,inassid,schs.sgname,schs.mt,null,null, schs.mediangrade);
        end loop;
end;
$$ language plpgsql;






drop function cohorts_grade_wrapper(int);
CREATE OR REPLACE function cohorts_grade_wrapper(inpid int)returns void as $$
declare
        schs RECORD;
begin        
        for schs in 
        select distinct p.ayid as ayid,sg.name as sgname, array_agg(distinct ass.id) assid_arr from tb_assessment ass,tb_programme p,tb_student_eval se,tb_student_class stusg,tb_class sg,tb_question q,tb_school s,tb_boundary b where se.qid=q.id and q.assid=ass.id and ass.pid=p.id and p.id=inpid and se.stuid=stusg.stuid and stusg.clid=sg.id and stusg.ayid=p.ayid and sg.sid=s.id and s.bid=b.id and b.type=p.type group by p.ayid,sg.name
        loop
            for i in 1..array_length(schs.assid_arr,1) 
            loop
                RAISE NOTICE '%,%,%,%,%',inpid,schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr;
                perform fill_inst_assess_cohorts(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                RAISE NOTICE 'cohort done';
                perform fill_agg_singlescore_grade(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                perform fill_agg_singlescore_grade_mt(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                perform fill_agg_singlescore_grade_gender(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                RAISE NOTICE 'singlescore done';
            end loop;
        end loop;
end;
$$ language plpgsql;



drop function cohorts_grade_wrapper_boundary(int);
CREATE OR REPLACE function cohorts_grade_wrapper_boundary(inpid int)returns void as $$
declare
        schs RECORD;
begin        
        for schs in 
        select distinct p.ayid as ayid,sg.name as sgname, array_agg(distinct ass.id) assid_arr from tb_assessment ass,tb_programme p,tb_student_eval se,tb_student_class stusg,tb_class sg,tb_question q,tb_school s,tb_boundary b where se.qid=q.id and q.assid=ass.id and ass.pid=p.id and p.id=inpid and se.stuid=stusg.stuid and stusg.clid=sg.id and stusg.ayid=p.ayid and sg.sid=s.id and s.bid=b.id and b.type=p.type  group by p.ayid,sg.name
        loop
            for i in 1..array_length(schs.assid_arr,1) 
            loop
                RAISE NOTICE '%,%,%,%,%',inpid,schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr;
 
                perform fill_agg_singlescore_grade_admin1(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                perform fill_agg_singlescore_grade_admin1_mt(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                perform fill_agg_singlescore_grade_admin1_gender(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                RAISE NOTICE 'admin1 done';
                perform fill_agg_singlescore_grade_admin2(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                perform fill_agg_singlescore_grade_admin2_mt(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                perform fill_agg_singlescore_grade_admin2_gender(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                RAISE NOTICE 'admin2 done';
                perform fill_agg_singlescore_grade_admin3(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                perform fill_agg_singlescore_grade_admin3_mt(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                perform fill_agg_singlescore_grade_admin3_gender(schs.ayid,schs.sgname,schs.assid_arr[i],schs.assid_arr);
                RAISE NOTICE 'admin3 done';

            end loop;
        end loop;
end;
$$ language plpgsql;

