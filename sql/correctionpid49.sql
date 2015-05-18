delete from tb_institution_assessment_cohorts where assid in (190,191,213,214,218,219);
delete from tb_institution_assessment_singlescore where assid in (190,191,213,214,218,219);
delete from tb_institution_assessment_singlescore_mt where assid in (190,191,213,214,218,219);
delete from tb_institution_assessment_singlescore_gender where assid in (190,191,213,214,218,219);
delete from tb_boundary_assessment_singlescore where assid in (190,191,213,214,218.219);
delete from tb_boundary_assessment_singlescore_mt where assid in (190,191,213,214,218,219);
delete from tb_boundary_assessment_singlescore_gender where assid in (190,191,213,214,218,219);
-- pid 49
select fill_inst_assess_cohorts(122,'Anganwadi Class',190,ARRAY[190,218]);
select fill_agg_singlescore(122,'Anganwadi Class',190,ARRAY[190,218]);
select fill_agg_singlescore_mt(122,'Anganwadi Class',190,ARRAY[190,218]);
select fill_agg_singlescore_gender(122,'Anganwadi Class',190,ARRAY[190,218]);
select fill_agg_singlescore_admin1(122,'Anganwadi Class',190,ARRAY[190,218]);
select fill_agg_singlescore_admin1_mt(122,'Anganwadi Class',190,ARRAY[190,218]);
select fill_agg_singlescore_admin1_gender(122,'Anganwadi Class',190,ARRAY[190,218]);
select fill_agg_singlescore_admin2(122,'Anganwadi Class',190,ARRAY[190,218]);
select fill_agg_singlescore_admin2_mt(122,'Anganwadi Class',190,ARRAY[190,218]);
select fill_agg_singlescore_admin2_gender(122,'Anganwadi Class',190,ARRAY[190,218]);
select fill_agg_singlescore_admin3(122,'Anganwadi Class',190,ARRAY[190,218]);
select fill_agg_singlescore_admin3_mt(122,'Anganwadi Class',190,ARRAY[190,218]);
select fill_agg_singlescore_admin3_gender(122,'Anganwadi Class',190,ARRAY[190,218]);

select fill_inst_assess_cohorts(122,'Anganwadi Class',218,ARRAY[218,190]);
select fill_agg_singlescore(122,'Anganwadi Class',218,ARRAY[218,190]);
select fill_agg_singlescore_mt(122,'Anganwadi Class',218,ARRAY[218,190]);
select fill_agg_singlescore_gender(122,'Anganwadi Class',218,ARRAY[218,190]);
select fill_agg_singlescore_admin1(122,'Anganwadi Class',218,ARRAY[218,190]);
select fill_agg_singlescore_admin1_mt(122,'Anganwadi Class',218,ARRAY[218,190]);
select fill_agg_singlescore_admin1_gender(122,'Anganwadi Class',218,ARRAY[218,190]);
select fill_agg_singlescore_admin2(122,'Anganwadi Class',218,ARRAY[218,190]);
select fill_agg_singlescore_admin2_mt(122,'Anganwadi Class',218,ARRAY[218,190]);
select fill_agg_singlescore_admin2_gender(122,'Anganwadi Class',218,ARRAY[218,190]);
select fill_agg_singlescore_admin3(122,'Anganwadi Class',218,ARRAY[218,190]);
select fill_agg_singlescore_admin3_mt(122,'Anganwadi Class',218,ARRAY[218,190]);
select fill_agg_singlescore_admin3_gender(122,'Anganwadi Class',218,ARRAY[218,190]);

select fill_inst_assess_cohorts(122,'Anganwadi Class',191,ARRAY[191,219]);
select fill_agg_singlescore(122,'Anganwadi Class',191,ARRAY[191,219]);
select fill_agg_singlescore_mt(122,'Anganwadi Class',191,ARRAY[191,219]);
select fill_agg_singlescore_gender(122,'Anganwadi Class',191,ARRAY[191,219]);
select fill_agg_singlescore_admin1(122,'Anganwadi Class',191,ARRAY[191,219]);
select fill_agg_singlescore_admin1_mt(122,'Anganwadi Class',191,ARRAY[191,219]);
select fill_agg_singlescore_admin1_gender(122,'Anganwadi Class',191,ARRAY[191,219]);
select fill_agg_singlescore_admin2(122,'Anganwadi Class',191,ARRAY[191,219]);
select fill_agg_singlescore_admin2_mt(122,'Anganwadi Class',191,ARRAY[191,219]);
select fill_agg_singlescore_admin2_gender(122,'Anganwadi Class',191,ARRAY[191,219]);
select fill_agg_singlescore_admin3(122,'Anganwadi Class',191,ARRAY[191,219]);
select fill_agg_singlescore_admin3_mt(122,'Anganwadi Class',191,ARRAY[191,219]);
select fill_agg_singlescore_admin3_gender(122,'Anganwadi Class',191,ARRAY[191,219]);

select fill_inst_assess_cohorts(122,'Anganwadi Class',219,ARRAY[219,191]);
select fill_agg_singlescore(122,'Anganwadi Class',219,ARRAY[219,191]);
select fill_agg_singlescore_mt(122,'Anganwadi Class',219,ARRAY[219,191]);
select fill_agg_singlescore_gender(122,'Anganwadi Class',219,ARRAY[219,191]);
select fill_agg_singlescore_admin1(122,'Anganwadi Class',219,ARRAY[219,191]);
select fill_agg_singlescore_admin1_mt(122,'Anganwadi Class',219,ARRAY[219,191]);
select fill_agg_singlescore_admin1_gender(122,'Anganwadi Class',219,ARRAY[219,191]);
select fill_agg_singlescore_admin2(122,'Anganwadi Class',219,ARRAY[219,191]);
select fill_agg_singlescore_admin2_mt(122,'Anganwadi Class',219,ARRAY[219,191]);
select fill_agg_singlescore_admin2_gender(122,'Anganwadi Class',219,ARRAY[219,191]);
select fill_agg_singlescore_admin3(122,'Anganwadi Class',219,ARRAY[219,191]);
select fill_agg_singlescore_admin3_mt(122,'Anganwadi Class',219,ARRAY[219,191]);
select fill_agg_singlescore_admin3_gender(122,'Anganwadi Class',219,ARRAY[219,191]);



