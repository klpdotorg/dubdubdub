--pid 1
select cohorts_grade_wrapper(1);
select cohorts_grade_wrapper_boundary(1);

--pid 7
select cohorts_grade_wrapper(7);
select cohorts_grade_wrapper_boundary(7);

--pid 8
select cohorts_grade_wrapper(8);
select cohorts_grade_wrapper_boundary(8);


--pid 19
select cohorts_grade_wrapper(19);
select cohorts_grade_wrapper_boundary(19);


--pid 39
select cohorts_grade_wrapper(39);
select cohorts_grade_wrapper_boundary(39);

--pid 46
select cohorts_grade_wrapper(46);
select cohorts_grade_wrapper_boundary(46);

--pid 58 assid 246
select fill_inst_assess_cohorts(123,'6',246,ARRAY[246]);
select fill_agg_singlescore_grade(123,'6',246,ARRAY[246]);
select fill_agg_singlescore_grade_mt(123,'6',246,ARRAY[246]);
select fill_agg_singlescore_grade_gender(123,'6',246,ARRAY[246]);
select fill_agg_singlescore_grade_admin1(123,'6',246,ARRAY[246]);
select fill_agg_singlescore_grade_admin1_mt(123,'6',246,ARRAY[246]);
select fill_agg_singlescore_grade_admin1_gender(123,'6',246,ARRAY[246]);
select fill_agg_singlescore_grade_admin2(123,'6',246,ARRAY[246]);
select fill_agg_singlescore_grade_admin2_mt(123,'6',246,ARRAY[246]);
select fill_agg_singlescore_grade_admin2_gender(123,'6',246,ARRAY[246]);
select fill_agg_singlescore_grade_admin3(123,'6',246,ARRAY[246]);
select fill_agg_singlescore_grade_admin3_mt(123,'6',246,ARRAY[246]);
select fill_agg_singlescore_grade_admin3_gender(123,'6',246,ARRAY[246]);

--pid 58 assid 247
select fill_inst_assess_cohorts(123,'7',247,ARRAY[247]);
select fill_agg_singlescore_grade(123,'7',247,ARRAY[247]);
select fill_agg_singlescore_grade_mt(123,'7',247,ARRAY[247]);
select fill_agg_singlescore_grade_gender(123,'7',247,ARRAY[247]);
select fill_agg_singlescore_grade_admin1(123,'7',247,ARRAY[247]);
select fill_agg_singlescore_grade_admin1_mt(123,'7',247,ARRAY[247]);
select fill_agg_singlescore_grade_admin1_gender(123,'7',247,ARRAY[247]);
select fill_agg_singlescore_grade_admin2(123,'7',247,ARRAY[247]);
select fill_agg_singlescore_grade_admin2_mt(123,'7',247,ARRAY[247]);
select fill_agg_singlescore_grade_admin2_gender(123,'7',247,ARRAY[247]);
select fill_agg_singlescore_grade_admin3(123,'7',247,ARRAY[247]);
select fill_agg_singlescore_grade_admin3_mt(123,'7',247,ARRAY[247]);
select fill_agg_singlescore_grade_admin3_gender(123,'7',247,ARRAY[247]);


