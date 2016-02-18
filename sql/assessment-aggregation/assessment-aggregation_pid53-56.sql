--Math aggregate functions for pid 53-56
DROP function fill_agg_singlescore_math(int,character(50),int,int[]); 
CREATE OR REPLACE function fill_agg_singlescore_math(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT sid as id,sgname as sgname, case grade_median(inarr) when 1 then ''O'' when 2 then ''D'' when 3 then ''N'' when 4 then ''A'' when 5 then ''S'' when 6 then ''M'' when 7 then ''DIV''  end as mediangrade FROM( select sg.sid as sid ,sg.name as sgname,array_agg(case trim(se.grade)  when ''O'' then 1 when ''0'' then 1 when ''D'' then 2 when ''N'' then 3 when ''A'' then 4 when ''S'' then 5 when ''M'' then 6 when ''DIV'' then 7 end) as inarr from tb_student_eval se,tb_question q, tb_student_class stusg,tb_class sg where se.stuid=stusg.stuid and se.qid=q.id and stusg.clid=sg.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
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

DROP function fill_agg_singlescore_math_gender(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_math_gender(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT sid as id,sgname as sgname,gender as gender, case grade_median(inarr) when 1 then ''O'' when 2 then ''D'' when 3 then ''N'' when 4 then ''A'' when 5 then ''S'' when 6 then ''M'' when 7 then ''DIV'' end as mediangrade FROM( select distinct sg.sid as sid,c.sex as gender, sg.name as sgname ,array_agg(case trim(se.grade) when ''O'' then 1 when ''0'' then 1 when ''D'' then 2 when ''N'' then 3 when ''A'' then 4 when ''S'' then 5 when ''M'' then 6 when ''DIV'' then 7 end) as inarr from tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
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

DROP function fill_agg_singlescore_math_mt(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_math_mt(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT sid as id,sgname as sgname,mt as mt, case grade_median(inarr) when 1 then ''O'' when 2 then ''D'' when 3 then ''N'' when 4 then ''A'' when 5 then ''S'' when 6 then ''M'' when 7 then ''DIV'' end as mediangrade FROM( select distinct sg.sid as sid,c.mt as mt, sg.name as sgname ,array_agg(case trim(se.grade) when ''O'' then 1 when ''0'' then 1 when ''D'' then 2 when ''N'' then 3 when ''A'' then 4 when ''S'' then 5 when ''M'' then 6 when ''DIV'' then 7 end) as inarr from tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
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

DROP function fill_agg_singlescore_math_admin3(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_math_admin3(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
        query:='SELECT admin3 as admin3,sgname as sgname, case grade_median(inarr) when 1 then ''O'' when 2 then ''D'' when 3 then ''N'' when 4 then ''A'' when 5 then ''S'' when 6 then ''M'' when 7 then ''DIV'' end as mediangrade FROM( select distinct s.bid as admin3, sg.name as sgname, array_agg(case trim(se.grade) when ''O'' then 1 when ''0'' then 1 when ''D'' then 2 when ''N'' then 3 when ''A'' then 4 when ''S'' then 5 when ''M'' then 6 when ''DIV'' then 7 end) as inarr from tb_school s, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q WHERE se.stuid=stusg.stuid and se.qid=q.id and stusg.clid=sg.id and sg.sid=s.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'' ) and se.grade is not null';
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


DROP function fill_agg_singlescore_math_admin3_gender(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_math_admin3_gender(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin3 as admin3,sgname as sgname,gender as gender,case grade_median(inarr) when 1 then ''O'' when 2 then ''D'' when 3 then ''N'' when 4 then ''A'' when 5 then ''S'' when 6 then ''M'' when 7 then ''DIV'' end as mediangrade FROM( select distinct s.bid  as admin3,c.sex as gender, sg.name as sgname,array_agg(case trim(se.grade) when ''O'' then 1 when ''0'' then 1 when ''D'' then 2 when ''N'' then 3 when ''A'' then 4 when ''S'' then 5 when ''M'' then 6 when ''DIV'' then 7 end) as inarr from tb_school s, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
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

DROP function fill_agg_singlescore_math_admin3_mt(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_math_admin3_mt(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin3 as admin3,sgname as sgname,mt as mt,case grade_median(inarr) when 1 then ''O'' when 2 then ''D'' when 3 then ''N'' when 4 then ''A'' when 5 then ''S'' when 6 then ''M'' when 7 then ''DIV'' end as mediangrade FROM( select distinct s.bid  as admin3,c.mt as mt, sg.name as sgname,array_agg(case trim(se.grade) when ''O'' then 1 when ''0'' then 1 when ''D'' then 2 when ''N'' then 3 when ''A'' then 4 when ''S'' then 5 when ''M'' then 6 when ''DIV'' then 7 end) as inarr from tb_school s, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
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


DROP function fill_agg_singlescore_math_admin2(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_math_admin2(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin2 as admin2,sgname as sgname,case grade_median(inarr) when 1 then ''O'' when 2 then ''D'' when 3 then ''N'' when 4 then ''A'' when 5 then ''S'' when 6 then ''M'' when 7 then ''DIV'' end as mediangrade  FROM( select distinct b.parent as admin2,sg.name as sgname,array_agg(case trim(se.grade) when ''O'' then 1 when ''0'' then 1 when ''D'' then 2 when ''N'' then 3 when ''A'' then 4 when ''S'' then 5 when ''M'' then 6 when ''DIV'' then 7 end) as inarr from tb_boundary b, tb_school s, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q WHERE se.stuid=stusg.stuid and se.qid=q.id and  stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
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


DROP function fill_agg_singlescore_math_admin2_gender(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_math_admin2_gender(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin2 as admin2,sgname as sgname,gender as gender,case grade_median(inarr) when 1 then ''O'' when 2 then ''D'' when 3 then ''N'' when 4 then ''A'' when 5 then ''S'' when 6 then ''M'' when 7 then ''DIV'' end as mediangrade FROM( select distinct b.parent as admin2,c.sex as gender,sg.name as sgname,array_agg(case trim(se.grade) when ''O'' then 1 when ''0'' then 1 when ''D'' then 2 when ''N'' then 3 when ''A'' then 4 when ''S'' then 5 when ''M'' then 6 when ''DIV'' then 7 end) as inarr from tb_school s, tb_boundary b, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'' )and se.grade is not null';
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

DROP function fill_agg_singlescore_math_admin2_mt(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_math_admin2_mt(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin2 as admin2,sgname as sgname,mt as mt,case grade_median(inarr) when 1 then ''O'' when 2 then ''D'' when 3 then ''N'' when 4 then ''A'' when 5 then ''S'' when 6 then ''M'' when 7 then ''DIV'' end as mediangrade FROM( select distinct b.parent as admin2,c.mt as mt,sg.name as sgname,array_agg(case trim(se.grade) when ''O'' then 1 when ''0'' then 1 when ''D'' then 2 when ''N'' then 3 when ''A'' then 4 when ''S'' then 5 when ''M'' then 6 when ''DIV'' then 7 end) as inarr from tb_school s, tb_boundary b, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'' )and se.grade is not null';
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


DROP function fill_agg_singlescore_math_admin1(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_math_admin1(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin1 as admin1,sgname as sgname,case grade_median(inarr) when 1 then ''O'' when 2 then ''D'' when 3 then ''N'' when 4 then ''A'' when 5 then ''S'' when 6 then ''M'' when 7 then ''DIV'' end as mediangrade  FROM( select distinct  b1.parent as admin1,sg.name as sgname,array_agg(case trim(se.     grade) when ''0'' then 1 when ''D'' then 2 when ''N'' then 3 when ''A'' then 4 when ''S'' then 5 when ''M'' then 6 when ''DIV'' then 7 end) as inarr from tb_boundary b,tb_boundary b1, tb_school s, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q WHERE se.stuid=stusg.stuid and se.qid=q.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id and b.parent=b1.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
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


DROP function fill_agg_singlescore_math_admin1_gender(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_math_admin1_gender(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin1 as admin1,sgname as sgname,gender as gender,case grade_median(inarr) when 1 then ''O'' when 2 then ''D'' when 3 then ''N'' when 4 then ''A'' when 5 then ''S'' when 6 then ''M'' when 7 then ''DIV'' end as mediangrade  FROM( select distinct  b1.parent as admin1,c.sex as gender,sg.name as sgname,array_agg(case trim(se.     grade) when ''0'' then 1 when ''D'' then 2 when ''N'' then 3 when ''A'' then 4 when ''S'' then 5 when ''M'' then 6 when ''DIV'' then 7 end) as inarr from tb_school s, tb_boundary b,tb_boundary b1, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id and b.parent=b1.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
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



DROP function fill_agg_singlescore_math_admin1_mt(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_math_admin1_mt(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin1 as admin1,sgname as sgname,mt as mt ,case grade_median(inarr) when 1 then ''O'' when 2 then ''D'' when 3 then ''N'' when 4 then ''A'' when 5 then ''S'' when 6 then ''M'' when 7 then ''DIV'' end as mediangrade FROM( select distinct  b1.parent as admin1,c.mt as mt,sg.name as sgname, array_agg(case trim(se.     grade) when ''0'' then 1 when ''D'' then 2 when ''N'' then 3 when ''A'' then 4 when ''S'' then 5 when ''M'' then 6 when ''DIV'' then 7 end)   as inarr from tb_school s,tb_boundary b,tb_boundary b1, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and stu.cid=c.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id and b.parent=b1.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
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

DROP function fill_assessment_math_percentilerank(int,int,int[]);
CREATE OR REPLACE function fill_assessment_math_percentilerank(inayid int,inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='select round((((Ocount/2)/totcount)*100)::numeric,2) as Orank,round((((Ocount+(Dcount/2))/totcount)*100)::numeric,2) as Drank, round((((Ocount+Dcount+(Ncount/2))/totcount)*100)::numeric,2) as Nrank, round((((Ocount+Dcount+Ncount+(Acount/2))/totcount)*100)::numeric,2) as Arank, round((((Ocount+Dcount+Ncount+Acount+(Scount/2))/totcount)*100)::numeric,2) as Srank, round((((Ocount+Dcount+Ncount+Acount+Scount+(Mcount/2))/totcount)*100)::numeric,2) as Mrank, round((((Ocount+Dcount+Ncount+Acount+Scount+Mcount+(Divcount/2))/totcount)*100)::numeric,2) as Divrank from (select count(se.grade)::float as totcount,count(case trim(se.grade) when ''O'' then 1 when ''0'' then 1 end)::float as Ocount,count(case trim(se.grade) when ''D'' then 1 end)::float as Dcount,count(case trim(se.grade) when ''N'' then 1 end)::float as Ncount,count(case trim(se.grade) when ''A'' then 1 end)::float as Acount,count(case trim(se.grade) when ''S'' then 1 end)::float as Scount,count(case trim(se.grade) when ''M'' then 1 end)::float as Mcount,count(case trim(se.grade) when ''DIV'' then 1 end)::float as Divcount from tb_student_eval se,tb_question q, tb_student_class stusg,tb_class sg where se.stuid=stusg.stuid and se.qid=q.id and stusg.clid=sg.id AND stusg.ayid = '||inayid||' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select distinct stuid from tb_student_eval where qid in (select id from tb_question where assid='||inallassid[i]||') and grade is not null)';
        end loop;
        query:=query||')as innerloop';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_assessment_grade_percentilerank values (inassid,'0',schs.Orank);
          insert into tb_assessment_grade_percentilerank values (inassid,'D',schs.Drank);
          insert into tb_assessment_grade_percentilerank values (inassid,'N',schs.Nrank);
          insert into tb_assessment_grade_percentilerank values (inassid,'A',schs.Arank);
          insert into tb_assessment_grade_percentilerank values (inassid,'S',schs.Srank);
          insert into tb_assessment_grade_percentilerank values (inassid,'M',schs.Mrank);
          insert into tb_assessment_grade_percentilerank values (inassid,'DIV',schs.Divrank);
        end loop;
end;
$$ language plpgsql;


--Reading agg functions for pid 53-56
DROP function fill_agg_singlescore_reading(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_reading(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT sid as id,sgname as sgname, case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then ''S'' when 5 then ''P'' when 6 then ''ST'' end as mediangrade FROM( select sg.sid as sid ,sg.name as sgname,array_agg(case trim(se.grade) when ''O'' then 1 when ''0'' then 1 when ''L'' then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 when ''ST'' then 6 end) as inarr from tb_student_eval se,tb_question q, tb_student_class stusg,tb_class sg where se.stuid=stusg.stuid and se.qid=q.id and stusg.clid=sg.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
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


DROP function fill_agg_singlescore_reading_gender(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_reading_gender(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT sid as id,sgname as sgname,gender as gender, case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then ''S'' when 5 then ''P'' when 6 then ''ST'' end as mediangrade FROM( select distinct sg.sid as sid,c.sex as gender, sg.name as sgname ,array_agg(case trim(se.grade) when ''O'' then 1 when ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 when ''ST'' then 6 end) as inarr from tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
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

DROP function fill_agg_singlescore_reading_mt(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_reading_mt(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT sid as id,sgname as sgname,mt as mt, case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then ''S'' when 5 then      ''P'' when 6 then ''ST'' end as mediangrade FROM( select distinct sg.sid as sid,c.mt as mt, sg.name as sgname ,array_agg(case trim(se.grade) when ''O'' then 1 when ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 when ''ST'' then 6 end) as inarr from tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
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

DROP function fill_agg_singlescore_reading_admin3(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_reading_admin3(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
        query:='SELECT admin3 as admin3,sgname as sgname, case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then ''S'' when 5 then      ''P'' when 6 then ''ST'' end as mediangrade FROM( select distinct s.bid as admin3, sg.name as sgname, array_agg(case trim(se.grade) when ''O'' then 1 when ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 when ''ST'' then 6 end) as inarr from tb_school s, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q WHERE se.stuid=stusg.stuid and se.qid=q.id and stusg.clid=sg.id and sg.sid=s.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'' ) and se.grade is not null';
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


DROP function fill_agg_singlescore_reading_admin3_gender(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_reading_admin3_gender(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin3 as admin3,sgname as sgname,gender as gender,case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then ''S'' when  5 then      ''P'' when 6 then ''ST'' end as mediangrade FROM( select distinct s.bid  as admin3,c.sex as gender, sg.name as sgname,array_agg(case trim(se.grade) when ''O'' then 1 when   ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 when ''ST'' then 6 end) as inarr from tb_school s, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
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

DROP function fill_agg_singlescore_reading_admin3_mt(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_reading_admin3_mt(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin3 as admin3,sgname as sgname,mt as mt,case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then ''S'' when  5 then      ''P'' when 6 then ''ST'' end as mediangrade FROM( select distinct s.bid  as admin3,c.mt as mt, sg.name as sgname,array_agg(case trim(se.grade) when ''O'' then 1 when   ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 when ''ST'' then 6 end) as inarr from tb_school s, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
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


DROP function fill_agg_singlescore_reading_admin2(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_reading_admin2(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin2 as admin2,sgname as sgname,case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then ''S''   when  5 then      ''P'' when 6 then ''ST'' end as mediangrade  FROM( select distinct b.parent as admin2,sg.name as sgname,array_agg(case trim(se.grade) when    ''O'' then 1 when   ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 when ''ST'' then 6 end) as inarr from tb_boundary b, tb_school s, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q WHERE se.stuid=stusg.stuid and se.qid=q.id and  stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
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


DROP function fill_agg_singlescore_reading_admin2_gender(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_reading_admin2_gender(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin2 as admin2,sgname as sgname,gender as gender,case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then ''S''   when  5  then      ''P'' when 6 then ''ST'' end as mediangrade FROM( select distinct b.parent as admin2,c.sex as gender,sg.name as sgname,array_agg(case trim(se.grade) when    ''O'' then 1     when   ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 when ''ST'' then 6 end) as inarr from tb_school s, tb_boundary b, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'' )and se.grade is not null';
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

DROP function fill_agg_singlescore_reading_admin2_mt(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_reading_admin2_mt(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin2 as admin2,sgname as sgname,mt as mt,case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then ''S''   when  5  then      ''P'' when 6 then ''ST'' end as mediangrade FROM( select distinct b.parent as admin2,c.mt as mt,sg.name as sgname,array_agg(case trim(se.grade) when    ''O'' then 1     when   ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 when ''ST'' then 6 end) as inarr from tb_school s, tb_boundary b, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'' )and se.grade is not null';
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


DROP function fill_agg_singlescore_reading_admin1(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_reading_admin1(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin1 as admin1,sgname as sgname,case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then         ''S''   when  5  then      ''P'' when 6 then ''ST'' end as mediangrade  FROM( select distinct  b1.parent as admin1,sg.name as sgname,array_agg(case trim(se.     grade) when    ''O'' then 1     when   ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 when ''ST'' then 6 end) as inarr from tb_boundary b,tb_boundary b1, tb_school s, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q WHERE se.stuid=stusg.stuid and se.qid=q.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id and b.parent=b1.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
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


DROP function fill_agg_singlescore_reading_admin1_gender(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_reading_admin1_gender(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin1 as admin1,sgname as sgname,gender as gender,case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4 then         ''S''    when  5  then      ''P'' when 6 then ''ST'' end as mediangrade  FROM( select distinct  b1.parent as admin1,c.sex as gender,sg.name as sgname,array_agg(case trim(se.     grade) when     ''O'' then 1     when   ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 when ''ST'' then 6 end) as inarr from tb_school s, tb_boundary b,tb_boundary b1, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id and b.parent=b1.id and stu.cid=c.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
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



DROP function fill_agg_singlescore_reading_admin1_mt(int,character(50),int,int[]);
CREATE OR REPLACE function fill_agg_singlescore_reading_admin1_mt(inayid int,insgname character(50),inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT admin1 as admin1,sgname as sgname,mt as mt ,case grade_median(inarr) when 1 then ''O'' when 2 then ''L'' when 3 then ''W'' when 4      then         ''S''    when  5  then      ''P'' when 6 then ''ST'' end as mediangrade FROM( select distinct  b1.parent as admin1,c.mt as mt,sg.name as sgname, array_agg(case trim(se.     grade) when     ''O'' then 1     when   ''0'' then 1 when ''L''   then 2 when ''W'' then 3 when ''S'' then 4 when ''P'' then 5 when ''ST'' then 6 end)   as inarr from tb_school s,tb_boundary b,tb_boundary b1, tb_child c, tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and stu.cid=c.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and sg.sid=s.id and s.bid=b.id and b.parent=b1.id AND stusg.ayid = '||inayid||' and sg.name='''||insgname||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
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

DROP function fill_assessment_reading_percentilerank(int,int,int[]);
CREATE OR REPLACE function fill_assessment_reading_percentilerank(inayid int,inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='select round((((Ocount/2)/totcount)*100)::numeric,2) as Orank,round((((Ocount+(Lcount/2))/totcount)*100)::numeric,2) as Lrank, round((((Ocount+Lcount+(Wcount/2))/totcount)*100)::numeric,2) as Wrank, round((((Ocount+Lcount+Wcount+(Scount/2))/totcount)*100)::numeric,2) as Srank, round((((Ocount+Lcount+Wcount+Scount+(Pcount/2))/totcount)*100)::numeric,2) as Prank,round((((Ocount+Lcount+Wcount+Scount+Pcount+(STcount/2))/totcount)*100)::numeric,2) as  STrank from (select count(se.grade)::float as totcount,count(case trim(se.grade) when ''O'' then 1 when ''0'' then 1 end)::float as Ocount,count(case trim(se.grade) when ''L'' then 1 end)::float as Lcount,count(case trim(se.grade) when ''W'' then 1 end)::float as Wcount,count(case trim(se.grade) when ''S'' then 1 end)::float as Scount,count(case trim(se.grade) when ''P'' then 1 end)::float as Pcount,count(case trim(se.grade) when ''ST'' then 1 end)::float as STcount from tb_student_eval se,tb_question q, tb_student_class stusg,tb_class sg where se.stuid=stusg.stuid and se.qid=q.id and stusg.clid=sg.id AND stusg.ayid = '||inayid||' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select distinct stuid from tb_student_eval where qid in (select id from tb_question where assid='||inallassid[i]||') and grade is not null)';
        end loop;
        query:=query||')as innerloop';
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_assessment_grade_percentilerank values (inassid,'0',schs.Orank);
          insert into tb_assessment_grade_percentilerank values (inassid,'O',schs.Orank);
          insert into tb_assessment_grade_percentilerank values (inassid,'L',schs.Lrank);
          insert into tb_assessment_grade_percentilerank values (inassid,'W',schs.Wrank);
          insert into tb_assessment_grade_percentilerank values (inassid,'S',schs.Srank);
          insert into tb_assessment_grade_percentilerank values (inassid,'P',schs.Prank);
          insert into tb_assessment_grade_percentilerank values (inassid,'ST',schs.STrank);
        end loop;
end;
$$ language plpgsql;


