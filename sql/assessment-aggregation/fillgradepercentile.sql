select percentile_grade_wrapper(1);
select percentile_grade_wrapper(7);
select percentile_grade_wrapper(8);
select percentile_grade_wrapper(19);
select percentile_grade_wrapper(39);
select percentile_grade_wrapper(46);

--pid 58 assid 246
select fill_assessment_grade_percentilerank(123,246,ARRAY[246]);
select fill_student_grade_percentile(123,246,ARRAY[246]);
select fill_institution_percentile(246);
select fill_studentgroup_percentile(246);
select fill_boundary_percentile(246);
select fill_boundary_studentgroup_percentile(246);
select fill_studentgroup_percentile_gender(246);
select fill_studentgroup_percentile_mt(246);
select fill_boundary_studentgroup_percentile_gender(246);
select fill_boundary_studentgroup_percentile_mt(246);

--pid 58 assid 247
select fill_assessment_grade_percentilerank(123,247,ARRAY[247]);
select fill_student_grade_percentile(123,247,ARRAY[247]);
select fill_institution_percentile(247);
select fill_studentgroup_percentile(247);
select fill_boundary_percentile(247);
select fill_boundary_studentgroup_percentile(247);
select fill_studentgroup_percentile_gender(247);
select fill_studentgroup_percentile_mt(247);
select fill_boundary_studentgroup_percentile_gender(247);
select fill_boundary_studentgroup_percentile_mt(247);

