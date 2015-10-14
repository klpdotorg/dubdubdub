/*
script for filling the percentile values
*/
select fill_institution_mean(1,'2',5,ARRAY[5,9]);
select fill_student_percentile(1,'2',5,ARRAY[5,9]);
select fill_institution_percentile(5);
select fill_studentgroup_percentile(5);
select fill_boundary_percentile(5);
select fill_boundary_studentgroup_percentile(5);

select fill_assessment_grade_percentilerank(90,1,ARRAY[1,2,3,4]);
select fill_student_grade_percentile(90,1,ARRAY[1,2,3,4]);
select fill_institution_grade_percentile(1);
select fill_studentgroup_percentile(1);
select fill_boundary_percentile(1);
select fill_boundary_studentgroup_percentile(1);
