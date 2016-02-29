/*
Table for storing the mean and percentile value for an institution per assessment.
*/
DROP TABLE IF EXISTS "tb_institution_assessment_percentile";
CREATE TABLE "tb_institution_assessment_percentile"(
    "sid" integer REFERENCES "tb_school" ("id") ON DELETE CASCADE,
    "assid" integer REFERENCES "tb_assessment" ("id") on DELETE CASCADE,
    "percentile" numeric(6,2),
  PRIMARY KEY  ("sid","assid")
);

/*
Table for storing the mean value for an assessment.
*/
DROP TABLE IF EXISTS "tb_assessment_mean";
CREATE TABLE "tb_assessment_mean"(
    "assid" integer REFERENCES "tb_assessment" ("id") on DELETE CASCADE,
    "mean" numeric(6,2),
  PRIMARY KEY  ("assid")
);



/*
Table for storing percentile for a student per assessment
*/
DROP TABLE IF EXISTS "tb_student_assessment_percentile";
CREATE TABLE "tb_student_assessment_percentile" (
  "stuid" integer REFERENCES "tb_student" ("id") ON DELETE CASCADE,
  "studentgroup" varchar, 
  "sid" integer REFERENCES "tb_school" ("id") ON DELETE CASCADE,
  "assid" integer REFERENCES "tb_assessment" ("id") ON DELETE CASCADE,
  "percentile" numeric(6,2),
  PRIMARY KEY  ("stuid","assid")
);


/*
Table for storing the percentile rank of the grade per assessment.
The percentile rank is:-
 In order to calculate the percentile rank associated with a particular letter grade in a particular assessment, we first count the number of students who have got a lower grade in the assessment. To this, we will add half the number of students that have got this particular letter grade. We then divide this by the total number of students who took the test to get the percentile rank for this particular grade. 
*/
DROP TABLE IF EXISTS "tb_assessment_grade_percentilerank";
CREATE TABLE "tb_assessment_grade_percentilerank"(
  "assid" integer REFERENCES "tb_assessment" ("id") ON DELETE CASCADE,
  "grade" character(30),
  "percentilerank" numeric,
  PRIMARY KEY("assid","grade")
);

/*
Table for storing the percentile value for a boundary per assessment.
*/
DROP TABLE IF EXISTS "tb_boundary_assessment_percentile";
CREATE TABLE "tb_boundary_assessment_percentile"(
    "bid" integer REFERENCES "tb_boundary" ("id") ON DELETE CASCADE,
    "assid" integer REFERENCES "tb_assessment" ("id") on DELETE CASCADE,
    "percentile" numeric(6,2),
  PRIMARY KEY  ("bid","assid")
);



/*
This function calculates the mean value for an assessment
The mean is calcuated for the cohorts values only.
INPUT:- academic id, assessment id, array of cohorts assessment (e.g. pretest test and post test ids)
OUTPUT:- Fills the tb_assessment_mean with the mean value
*/
DROP function fill_assessment_mean(int,int,int[]);
CREATE OR REPLACE function fill_assessment_mean(inayid int,inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='SELECT sum(case when q.qtype=1 then se.mark else se.grade::int end)/count(distinct se.stuid) as mean from tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id AND stusg.ayid = '||inayid||' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and (se.mark is not null or  se.grade is not null)';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select distinct stuid from tb_student_eval where qid in (select id from tb_question where assid='||inallassid[i]||')  and (mark is not null or grade is not null))';
        end loop;
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_assessment_mean values (inassid,schs.mean);
        end loop;
end;
$$ language plpgsql;


/*
This function calculates the percentile value for an assessment for each student.
It uses the formula specified in the "KLP Aggregating Test Scores.pdf" Document.
The algorithm for scaling can be described as follows: !
1. Choose a “desired mean”. One way to pick this would be as a mean of means of all assessments held so far. Let’s call this value DM. !
2. Map the highest score of the assessment (let’s call this MX) to 100.!
3. Map the mean score of the assessment (let’s call that MS) to DM.!
4. Every test score TS higher than MS gets transformed to DM + (TS-MS)*(100-DM)/(MX-MS)!
5. Every test score TS that is lower than MS gets transformed to TS * DM / MS

The value of dm is chosen as 70 and value of mx as 100
ms is mean of the assessment of all the institutions.

INPUT:- academic id,class,assessment id, cohorts assessment array
OUTPUT:-inserts valus in tb_student_assessment_percentile
*/
DROP function fill_student_percentile(int,text,int,int[]);
CREATE OR REPLACE function fill_student_percentile(inayid int,insg text,inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
        dm integer:=70;
        mx integer:=100;

begin
    query:='SELECT distinct stuid as stuid,sid as sid,sgname as sgname, case when ts>ms.mean then ('||dm||'+(ts-ms.mean)*(100-'||dm||')/('||mx||'-ms.mean)) else (ts*'||dm||'/ms.mean) end as testscore FROM( select distinct stu.id  as stuid,sg.name as sgname, sg.sid as sid,sum(case when q.qtype=1 then se.mark else se.grade::int end) as ts from tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_student stu  WHERE se.stuid=stu.id and se.qid=q.id and stusg.stuid=stu.id and stusg.clid=sg.id and stusg.ayid = '||inayid||' and sg.name='''||insg||''' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and (se.mark is not null or  se.grade is not null)';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select distinct stuid from tb_student_eval where qid in (select id from tb_question where assid='||inallassid[i]||')  and (mark is not null or grade is not null))';
        end loop;
        query=query||'group by stu.id,sg.sid,sg.name) as innerloop,tb_assessment_mean ms where ms.assid='||inassid||'';
        RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_student_assessment_percentile values (schs.stuid,schs.sgname,schs.sid,inassid,schs.testscore);
        end loop;
end;
$$ language plpgsql;




/*
This function calculates the percentile for an institution for the given assessment.
INPUT:- assessment id
OUTPUT:- inserts percentile value in  tb_institution_assessment_percentile
*/
DROP function fill_institution_percentile(int);
CREATE OR REPLACE function fill_institution_percentile(inassid int) returns void as $$
declare
        schs RECORD;
        query text;

begin
    query:='select distinct sid,sum(percentile)/count(stuid) as percentilemean from tb_student_assessment_percentile where assid='||inassid||' group by sid';
        for schs in execute query
        loop
          insert into tb_institution_assessment_percentile values(schs.sid,inassid,schs.percentilemean);
        end loop;
end;
$$ language plpgsql;



/*
This function calculates the percentile for a studentgtroup,of an institution, for the given assessment.
INPUT:- assessment id
OUTPUT:- updates tb_institution_assessment_singlescore with the percentile value.
*/
DROP function fill_studentgroup_percentile(int);
CREATE OR REPLACE function fill_studentgroup_percentile(inassid int) returns void as $$
declare
        schs RECORD;
        query text;

begin
    query:='select distinct sid,studentgroup,sum(percentile)/count(stuid) as percentilemean from tb_student_assessment_percentile where assid='||inassid||' group by sid,studentgroup';
        for schs in execute query
        loop
          update tb_institution_assessment_singlescore set percentile=schs.percentilemean where sid=schs.sid and assid=inassid and studentgroup=schs.studentgroup;
        end loop;
end;
$$ language plpgsql;

/*
This function calculates the percentile for a studentgtroup,of an institution, for the given assessment based on gender
INPUT:- assessment id
OUTPUT:- updates tb_institution_assessment_singlescore_gender with the percentile value.
*/
DROP function fill_studentgroup_percentile_gender(int);
CREATE OR REPLACE function fill_studentgroup_percentile_gender(inassid int) returns void as $$
declare
        schs RECORD;
        query text;

begin
    query:='select distinct perc.sid as sid,perc.studentgroup as studentgroup,c.sex as gender,sum(perc.percentile)/count(perc.stuid) as percentilemean from tb_student_assessment_percentile perc,tb_child c,tb_student stu where perc.stuid=stu.id and stu.cid=c.id and assid='||inassid||' group by perc.sid,perc.studentgroup,c.sex';
        for schs in execute query
        loop
          update tb_institution_assessment_singlescore_gender set percentile=schs.percentilemean where sid=schs.sid and assid=inassid and studentgroup=schs.studentgroup and sex=schs.gender;
        end loop;
end;
$$ language plpgsql;


/*
This function calculates the percentile for a studentgtroup,of an institution, for the given assessment based on mt 
INPUT:- assessment id
OUTPUT:- updates tb_institution_assessment_singlescore_mt with the percentile value.
*/
DROP function fill_studentgroup_percentile_mt(int);
CREATE OR REPLACE function fill_studentgroup_percentile_mt(inassid int) returns void as $$
declare
        schs RECORD;
        query text;

begin
    query:='select distinct perc.sid as sid,perc.studentgroup as studentgroup,c.mt as mt,sum(perc.percentile)/count(perc.stuid) as percentilemean from tb_student_assessment_percentile perc,tb_child c,tb_student stu where perc.stuid=stu.id and stu.cid=c.id and assid='||inassid||' group by perc.sid,perc.studentgroup,c.mt';
        for schs in execute query
        loop
          update tb_institution_assessment_singlescore_mt set percentile=schs.percentilemean where sid=schs.sid and assid=inassid and studentgroup=schs.studentgroup and mt=schs.mt;
        end loop;
end;
$$ language plpgsql;



/*
This function calculates the percentile for a boundary for the given assessment.
INPUT:- assessment id
OUTPUT:- inserts percentile values in tb_boundary_assessment_percentile
*/
DROP function fill_boundary_percentile(int);
CREATE OR REPLACE function fill_boundary_percentile(inassid int) returns void as $$
declare
        schs RECORD;
        query text;

begin
    query:='select distinct s.bid as bid,sum(percentile)/count(stuid) as percentilemean from tb_student_assessment_percentile perc,tb_school s where perc.sid=s.id and assid='||inassid||' group by s.bid';
        for schs in execute query
        loop
          insert into tb_boundary_assessment_percentile values(schs.bid,inassid,schs.percentilemean);
        end loop;
    query:='select distinct b.parent as bid,sum(percentile)/count(stuid) as percentilemean from tb_boundary b,tb_student_assessment_percentile perc,tb_school s where perc.sid=s.id and s.bid=b.id and assid='||inassid||' group by b.parent';
        for schs in execute query
        loop
          insert into tb_boundary_assessment_percentile values(schs.bid,inassid,schs.percentilemean);
        end loop;
    query:='select distinct b1.parent as bid,sum(percentile)/count(stuid) as percentilemean from tb_boundary b,tb_boundary b1, tb_student_assessment_percentile perc,tb_school s where perc.sid=s.id and s.bid=b.id and b.parent=b1.id and assid='||inassid||' group by b1.parent';
        for schs in execute query
        loop
          insert into tb_boundary_assessment_percentile values(schs.bid,inassid,schs.percentilemean);
        end loop;
end;
$$ language plpgsql;



/*
This function calculates the percentile for a studentgroup of a  boundary for the given assessment.
INPUT:- assessment id
OUTPUT:- updates percentile values in tb_boundary_assessment_singlescore table
*/
DROP function fill_boundary_studentgroup_percentile(int);
CREATE OR REPLACE function fill_boundary_studentgroup_percentile(inassid int) returns void as $$
declare
        schs RECORD;
        query text;

begin
    query:='select distinct s.bid as bid,perc.studentgroup as studentgroup,sum(percentile)/count(stuid) as percentilemean from tb_student_assessment_percentile perc,tb_school s where perc.sid=s.id and assid='||inassid||' group by s.bid,perc.studentgroup';
        for schs in execute query
        loop
          update tb_boundary_assessment_singlescore set percentile=schs.percentilemean where bid=schs.bid and assid=inassid and studentgroup=schs.studentgroup;
        end loop;
    query:='select distinct b.parent as bid,perc.studentgroup as studentgroup,sum(percentile)/count(stuid) as percentilemean from tb_boundary b,tb_student_assessment_percentile perc,tb_school s where perc.sid=s.id and s.bid=b.id and assid='||inassid||' group by b.parent,perc.studentgroup';
        for schs in execute query
        loop
          update tb_boundary_assessment_singlescore set percentile=schs.percentilemean where bid=schs.bid and assid=inassid and studentgroup=schs.studentgroup;
        end loop;
    query:='select distinct b1.parent as bid,perc.studentgroup as studentgroup,sum(percentile)/count(stuid) as percentilemean from tb_boundary b,tb_boundary b1, tb_student_assessment_percentile perc,tb_school s where perc.sid=s.id and s.bid=b.id and b.parent=b1.id and assid='||inassid||' group by b1.parent,perc.studentgroup';
        for schs in execute query
        loop
          update tb_boundary_assessment_singlescore set percentile=schs.percentilemean where bid=schs.bid and assid=inassid and studentgroup=schs.studentgroup;
        end loop;
end;
$$ language plpgsql;


/*
This function calculates the percentile for a studentgroup of a  boundary for the given assessment based on gender
INPUT:- assessment id
OUTPUT:- updates percentile values in tb_boundary_assessment_singlescore_gender table
*/
DROP function fill_boundary_studentgroup_percentile_gender(int);
CREATE OR REPLACE function fill_boundary_studentgroup_percentile_gender(inassid int) returns void as $$
declare
        schs RECORD;
        query text;

begin
    query:='select distinct s.bid as bid,perc.studentgroup as studentgroup,c.sex as gender,sum(percentile)/count(stuid) as percentilemean from tb_student_assessment_percentile perc,tb_school s,tb_student stu,tb_child c where perc.sid=s.id and perc.stuid=stu.id and stu.cid=c.id  and assid='||inassid||' group by s.bid,perc.studentgroup,c.sex';
        for schs in execute query
        loop
          update tb_boundary_assessment_singlescore_gender set percentile=schs.percentilemean where bid=schs.bid and assid=inassid and studentgroup=schs.studentgroup and sex=schs.gender;
        end loop;
    query:='select distinct b.parent as bid,perc.studentgroup as studentgroup,c.sex as gender,sum(percentile)/count(stuid) as percentilemean from tb_boundary b,tb_student_assessment_percentile perc,tb_school s,tb_student stu,tb_child c where perc.sid=s.id and perc.stuid=stu.id and stu.cid=c.id and s.bid=b.id and assid='||inassid||' group by b.parent,perc.studentgroup,c.sex';
        for schs in execute query
        loop
          update tb_boundary_assessment_singlescore_gender set percentile=schs.percentilemean where bid=schs.bid and assid=inassid and studentgroup=schs.studentgroup and sex=schs.gender;
        end loop;
    query:='select distinct b1.parent as bid,perc.studentgroup as studentgroup, c.sex as gender,sum(percentile)/count(stuid) as percentilemean from tb_boundary b,tb_boundary b1, tb_student_assessment_percentile perc,tb_school s,tb_student stu,tb_child c where perc.sid=s.id and perc.stuid=stu.id and stu.cid=c.id  and s.bid=b.id and b.parent=b1.id and assid='||inassid||' group by b1.parent,perc.studentgroup,c.sex';
        for schs in execute query
        loop
          update tb_boundary_assessment_singlescore_gender set percentile=schs.percentilemean where bid=schs.bid and assid=inassid and studentgroup=schs.studentgroup and sex=schs.gender;
        end loop;
end;
$$ language plpgsql;


/*
This function calculates the percentile for a studentgroup of a  boundary for the given assessment based on mt 
INPUT:- assessment id
OUTPUT:- updates percentile values in tb_boundary_assessment_singlescore_mt table
*/
DROP function fill_boundary_studentgroup_percentile_mt(int);
CREATE OR REPLACE function fill_boundary_studentgroup_percentile_mt(inassid int) returns void as $$
declare
        schs RECORD;
        query text;

begin
    query:='select distinct s.bid as bid,perc.studentgroup as studentgroup,c.mt as mt ,sum(percentile)/count(stuid) as percentilemean from tb_student_assessment_percentile perc,tb_school s,tb_student stu,tb_child c where perc.sid=s.id and perc.stuid=stu.id and stu.cid=c.id  and assid='||inassid||' group by s.bid,perc.studentgroup,c.mt';
        for schs in execute query
        loop
          update tb_boundary_assessment_singlescore_mt set percentile=schs.percentilemean where bid=schs.bid and assid=inassid and studentgroup=schs.studentgroup and mt=schs.mt;
        end loop;
    query:='select distinct b.parent as bid,perc.studentgroup as studentgroup,c.mt as mt ,sum(percentile)/count(stuid) as percentilemean from tb_boundary b,tb_student_assessment_percentile perc,tb_school s,tb_student stu,tb_child c where perc.sid=s.id and perc.stuid=stu.id and stu.cid=c.id and s.bid=b.id and assid='||inassid||' group by b.parent,perc.studentgroup,c.mt';
        for schs in execute query
        loop
          update tb_boundary_assessment_singlescore_mt set percentile=schs.percentilemean where bid=schs.bid and assid=inassid and studentgroup=schs.studentgroup and mt=schs.mt ;
        end loop;
    query:='select distinct b1.parent as bid,perc.studentgroup as studentgroup, c.mt as mt ,sum(percentile)/count(stuid) as percentilemean from tb_boundary b,tb_boundary b1, tb_student_assessment_percentile perc,tb_school s,tb_student stu,tb_child c where perc.sid=s.id and perc.stuid=stu.id and stu.cid=c.id  and s.bid=b.id and b.parent=b1.id and assid='||inassid||' group by b1.parent,perc.studentgroup,c.mt';
        for schs in execute query
        loop
          update tb_boundary_assessment_singlescore_mt set percentile=schs.percentilemean where bid=schs.bid and assid=inassid and studentgroup=schs.studentgroup and mt=schs.mt;
        end loop;
end;
$$ language plpgsql;



/*
This function is used to calculate the percentile rank of the grade assessments.
It uses the following logic:
In order to calculate the percentile rank associated with a particular letter grade in a particular assessment, we first count the number of students who have got a lower grade in the assessment. To this, we will add half the number of students that have got this particular letter grade. We then divide this by the total number of students who took the test to get the percentile rank for this particular grade. 
INPUT:- acadmic id, assessment id and array of assessments for getting cohorts value
OUTPUT:- inserts ranks of the grades in the tb_assessment_grade_percentilerank table
*/
DROP function fill_assessment_grade_percentilerank(int,int,int[]);
CREATE OR REPLACE function fill_assessment_grade_percentilerank(inayid int,inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;
begin
    query:='select round((((Ocount/2)/totcount)*100)::numeric,2) as Orank,round((((Ocount+(Lcount/2))/totcount)*100)::numeric,2) as Lrank, round((((Ocount+Lcount+(Wcount/2))/totcount)*100)::numeric,2) as Wrank, round((((Ocount+Lcount+Wcount+(Scount/2))/totcount)*100)::numeric,2) as Srank, round((((Ocount+Lcount+Wcount+Scount+(Pcount/2))/totcount)*100)::numeric,2) as Prank from (select count(se.grade)::float as totcount,count(case trim(se.grade) when ''0'' then 1 when ''O'' then 1 end)::float as Ocount,count(case trim(se.grade) when ''L'' then 1 end)::float as Lcount,count(case trim(se.grade) when ''W'' then 1 end)::float as Wcount,count(case trim(se.grade) when ''S'' then 1 end)::float as Scount,count(case trim(se.grade) when ''P'' then 1 end)::float as Pcount from tb_student_eval se,tb_question q, tb_student_class stusg,tb_class sg where se.stuid=stusg.stuid and se.qid=q.id and stusg.clid=sg.id AND stusg.ayid = '||inayid||' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
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
        end loop;
end;
$$ language plpgsql;


/*
This function converts grade to percentile rank for each student for an assessment.
INPUT:- academic id,assessment id,cohorts assessment array
OUTPUT:- inserts values in tb_student_assessment_percentile table
*/
DROP function fill_student_grade_percentile(int,int,int[]);
CREATE OR REPLACE function fill_student_grade_percentile(inayid int,inassid int,inallassid int[]) returns void as $$
declare
        schs RECORD;
        query text;

begin
    query:='SELECT distinct se.stuid as stuid,sg.name as studentgroup,sg.sid as sid, percrank.percentilerank as percentilemean FROM tb_student_eval se, tb_student_class stusg, tb_class sg,tb_question q,tb_assessment_grade_percentilerank percrank WHERE se.qid=q.id and stusg.stuid=se.stuid and stusg.clid=sg.id and stusg.ayid = '||inayid||' and trim(se.grade)=percrank.grade and percrank.assid='||inassid||' and q.id in (select distinct id from tb_question where assid ='||inassid||' and "desc" !~ ''^.*(AB|Attendance|Parihara).*'') and se.grade is not null';
        FOR i in array_lower(inallassid,1)..array_upper(inallassid,1)
        loop
          query:= query||' and se.stuid in (select distinct stuid from tb_student_eval where qid in (select id from tb_question where assid='||inallassid[i]||') and grade is not null)';
        end loop;
        --RAISE NOTICE '%', query;
        for schs in execute query
        loop
          insert into tb_student_assessment_percentile values(schs.stuid,schs.studentgroup,schs.sid,inassid,schs.percentilemean);
        end loop;
end;
$$ language plpgsql;

/*
wrapper for calling the percentile function
INPUT:- programme id
*/
drop function percentile_mark_wrapper(int);
CREATE OR REPLACE function percentile_mark_wrapper(inpid int)returns void as $$
declare
        schs RECORD;
begin        
        for schs in 
        select ayid,array_agg(distinct trim(sgname)) as sgname_arr,assid_arr from(select distinct p.ayid as ayid,sg.name as sgname, array_agg(distinct ass.id) assid_arr from tb_assessment ass,tb_programme p,tb_student_eval se,tb_student_class stusg,tb_class sg,tb_question q,tb_school s,tb_boundary b where se.qid=q.id and q.assid=ass.id and ass.pid=p.id and p.id=inpid and se.stuid=stusg.stuid and stusg.clid=sg.id and stusg.ayid=p.ayid and sg.sid=s.id and s.bid=b.id and b.type=p.type group by p.ayid,sg.name)sub group by ayid,assid_arr
        loop
            for i in 1..array_length(schs.assid_arr,1) 
            loop
                RAISE NOTICE '%,%,%,%',inpid,schs.ayid,schs.assid_arr[i],schs.assid_arr;
                perform fill_assessment_mean(schs.ayid,schs.assid_arr[i],schs.assid_arr);
                for j in 1..array_length(schs.sgname_arr,1)
                loop
                   RAISE NOTICE '%,%,%,%,%',inpid,schs.ayid,schs.sgname_arr[j],schs.assid_arr[i],schs.assid_arr;
                   perform fill_student_percentile(schs.ayid,schs.sgname_arr[j],schs.assid_arr[i],schs.assid_arr);
                end loop;
                perform fill_institution_percentile(schs.assid_arr[i]);
                perform fill_studentgroup_percentile(schs.assid_arr[i]);
                perform fill_boundary_percentile(schs.assid_arr[i]);
                perform fill_boundary_studentgroup_percentile(schs.assid_arr[i]);
                perform fill_studentgroup_percentile_gender(schs.assid_arr[i]);
                perform fill_studentgroup_percentile_mt(schs.assid_arr[i]);
                perform fill_boundary_studentgroup_percentile_gender(schs.assid_arr[i]);
                perform fill_boundary_studentgroup_percentile_mt(schs.assid_arr[i]);
                RAISE NOTICE 'percentile done';
            end loop;
        end loop;
end;
$$ language plpgsql;


/*
wrapper for calling the percentile grade functions
INPUT:- programme id
*/
drop function percentile_grade_wrapper(int);
CREATE OR REPLACE function percentile_grade_wrapper(inpid int)returns void as $$
declare
        schs RECORD;
begin        
        for schs in 
        select distinct p.ayid as ayid,array_agg(distinct ass.id) assid_arr from tb_assessment ass,tb_programme p,tb_student_eval se,tb_student_class stusg,tb_class sg,tb_question q,tb_school s,tb_boundary b where se.qid=q.id and q.assid=ass.id and ass.pid=p.id and p.id=inpid and se.stuid=stusg.stuid and stusg.clid=sg.id and stusg.ayid=p.ayid and sg.sid=s.id and s.bid=b.id and b.type=p.type group by p.ayid
        loop
            for i in 1..array_length(schs.assid_arr,1) 
            loop
                RAISE NOTICE '%,%,%,%',inpid,schs.ayid,schs.assid_arr[i],schs.assid_arr;
                perform fill_assessment_grade_percentilerank(schs.ayid,schs.assid_arr[i],schs.assid_arr);
                perform fill_student_grade_percentile(schs.ayid,schs.assid_arr[i],schs.assid_arr);
                perform fill_institution_percentile(schs.assid_arr[i]);
                perform fill_studentgroup_percentile(schs.assid_arr[i]);
                perform fill_boundary_percentile(schs.assid_arr[i]);
                perform fill_boundary_studentgroup_percentile(schs.assid_arr[i]);
                perform fill_studentgroup_percentile_gender(schs.assid_arr[i]);
                perform fill_studentgroup_percentile_mt(schs.assid_arr[i]);
                perform fill_boundary_studentgroup_percentile_gender(schs.assid_arr[i]);
                perform fill_boundary_studentgroup_percentile_mt(schs.assid_arr[i]);
                RAISE NOTICE 'percentile done';
            end loop;
        end loop;
end;
$$ language plpgsql;

