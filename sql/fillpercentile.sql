/*
script for filling the percentile values
*/
select fill_institution_mean(1,'2',5,ARRAY[5,9]);
select fill_student_percentile(1,'2',5,ARRAY[5,9]);
select fill_institution_percentile(5);
select fill_studentgroup_percentile(5);
select fill_boundary_percentile(5);
select fill_boundary_studentgroup_percentile(5);
select fill_studentgroup_percentile_gender(5);
select fill_studentgroup_percentile_mt(5);
select fill_boundary_studentgroup_percentile_gender(5);
select fill_boundary_studentgroup_percentile_mt(5);

select fill_institution_mean(1,'2',9,ARRAY[5,9]);
select fill_student_percentile(1,'2',9,ARRAY[5,9]);
select fill_institution_percentile(9);
select fill_studentgroup_percentile(9);
select fill_boundary_percentile(9);
select fill_boundary_studentgroup_percentile(9);
select fill_studentgroup_percentile_gender(9);
select fill_studentgroup_percentile_mt(9);
select fill_boundary_studentgroup_percentile_gender(9);
select fill_boundary_studentgroup_percentile_mt(9);



select fill_assessment_grade_percentilerank(90,1,ARRAY[1,2,3,4]);
select fill_student_grade_percentile(90,1,ARRAY[1,2,3,4]);
select fill_institution_grade_percentile(1);
select fill_studentgroup_percentile(1);
select fill_boundary_percentile(1);
select fill_boundary_studentgroup_percentile(1);
select fill_studentgroup_percentile_gender(1);
select fill_studentgroup_percentile_mt(1);
select fill_boundary_studentgroup_percentile_gender(1);
select fill_boundary_studentgroup_percentile_mt(1);


select fill_assessment_grade_percentilerank(90,2,ARRAY[1,2,3,4]);
select fill_student_grade_percentile(90,2,ARRAY[1,2,3,4]);
select fill_institution_grade_percentile(2);
select fill_studentgroup_percentile(2);
select fill_boundary_percentile(2);
select fill_boundary_studentgroup_percentile(2);
select fill_studentgroup_percentile_gender(2);
select fill_studentgroup_percentile_mt(2);
select fill_boundary_studentgroup_percentile_gender(2);
select fill_boundary_studentgroup_percentile_mt(2);

select fill_assessment_grade_percentilerank(90,3,ARRAY[1,2,3,4]);
select fill_student_grade_percentile(90,3,ARRAY[1,2,3,4]);
select fill_institution_grade_percentile(3);
select fill_studentgroup_percentile(3);
select fill_boundary_percentile(3);
select fill_boundary_studentgroup_percentile(3);
select fill_studentgroup_percentile_gender(3);
select fill_studentgroup_percentile_mt(3);
select fill_boundary_studentgroup_percentile_gender(3);
select fill_boundary_studentgroup_percentile_mt(3);

select fill_assessment_grade_percentilerank(90,4,ARRAY[1,2,3,4]);
select fill_student_grade_percentile(90,4,ARRAY[1,2,3,4]);
select fill_institution_grade_percentile(4);
select fill_studentgroup_percentile(4);
select fill_boundary_percentile(4);
select fill_boundary_studentgroup_percentile(4);
select fill_studentgroup_percentile_gender(4);
select fill_studentgroup_percentile_mt(4);
select fill_boundary_studentgroup_percentile_gender(4);
select fill_boundary_studentgroup_percentile_mt(4);

