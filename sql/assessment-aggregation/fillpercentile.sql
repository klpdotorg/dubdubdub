/*
script for filling the percentile values
*/
select percentile_grade_wrapper(1);

select percentile_mark_wrapper(2);
select percentile_mark_wrapper(3);
select percentile_mark_wrapper(5);
select percentile_mark_wrapper(6);

select percentile_grade_wrapper(7);
select percentile_grade_wrapper(8);

select percentile_mark_wrapper(9);

--pid 14

select fill_assessment_mean(101,41,ARRAY[41,42]);
select fill_student_percentile(101,'4',41,ARRAY[41,42]);
select fill_institution_percentile(41);
select fill_studentgroup_percentile(41);
select fill_boundary_percentile(41);
select fill_boundary_studentgroup_percentile(41);
select fill_studentgroup_percentile_gender(41);
select fill_studentgroup_percentile_mt(41);
select fill_boundary_studentgroup_percentile_gender(41);
select fill_boundary_studentgroup_percentile_mt(41);

select fill_assessment_mean(101,42,ARRAY[41,42]);
select fill_student_percentile(101,'4',42,ARRAY[41,42]);
select fill_institution_percentile(42);
select fill_studentgroup_percentile(42);
select fill_boundary_percentile(42);
select fill_boundary_studentgroup_percentile(42);
select fill_studentgroup_percentile_gender(42);
select fill_studentgroup_percentile_mt(42);
select fill_boundary_studentgroup_percentile_gender(42);
select fill_boundary_studentgroup_percentile_mt(42);

select fill_assessment_mean(101,45,ARRAY[45,46]);
select fill_student_percentile(101,'4',45,ARRAY[45,46]);
select fill_institution_percentile(45);
select fill_studentgroup_percentile(45);
select fill_boundary_percentile(45);
select fill_boundary_studentgroup_percentile(45);
select fill_studentgroup_percentile_gender(45);
select fill_studentgroup_percentile_mt(45);
select fill_boundary_studentgroup_percentile_gender(45);
select fill_boundary_studentgroup_percentile_mt(45);

select fill_assessment_mean(101,46,ARRAY[45,46]);
select fill_student_percentile(101,'4',46,ARRAY[45,46]);
select fill_institution_percentile(46);
select fill_studentgroup_percentile(46);
select fill_boundary_percentile(46);
select fill_boundary_studentgroup_percentile(46);
select fill_studentgroup_percentile_gender(46);
select fill_studentgroup_percentile_mt(46);
select fill_boundary_studentgroup_percentile_gender(46);
select fill_boundary_studentgroup_percentile_mt(46);

select fill_assessment_mean(101,43,ARRAY[43,44]);
select fill_student_percentile(101,'5',43,ARRAY[43,44]);
select fill_institution_percentile(43);
select fill_studentgroup_percentile(43);
select fill_boundary_percentile(43);
select fill_boundary_studentgroup_percentile(43);
select fill_studentgroup_percentile_gender(43);
select fill_studentgroup_percentile_mt(43);
select fill_boundary_studentgroup_percentile_gender(43);
select fill_boundary_studentgroup_percentile_mt(43);

select fill_assessment_mean(101,44,ARRAY[43,44]);
select fill_student_percentile(101,'5',44,ARRAY[43,44]);
select fill_institution_percentile(44);
select fill_studentgroup_percentile(44);
select fill_boundary_percentile(44);
select fill_boundary_studentgroup_percentile(44);
select fill_studentgroup_percentile_gender(44);
select fill_studentgroup_percentile_mt(44);
select fill_boundary_studentgroup_percentile_gender(44);
select fill_boundary_studentgroup_percentile_mt(44);

select fill_assessment_mean(101,47,ARRAY[47,48]);
select fill_student_percentile(101,'5',47,ARRAY[47,48]);
select fill_institution_percentile(47);
select fill_studentgroup_percentile(47);
select fill_boundary_percentile(47);
select fill_boundary_studentgroup_percentile(47);
select fill_studentgroup_percentile_gender(47);
select fill_studentgroup_percentile_mt(47);
select fill_boundary_studentgroup_percentile_gender(47);
select fill_boundary_studentgroup_percentile_mt(47);

select fill_assessment_mean(101,48,ARRAY[47,48]);
select fill_student_percentile(101,'5',48,ARRAY[47,48]);
select fill_institution_percentile(48);
select fill_studentgroup_percentile(48);
select fill_boundary_percentile(48);
select fill_boundary_studentgroup_percentile(48);
select fill_studentgroup_percentile_gender(48);
select fill_studentgroup_percentile_mt(48);
select fill_boundary_studentgroup_percentile_gender(48);
select fill_boundary_studentgroup_percentile_mt(48);

select percentile_mark_wrapper(15);
select percentile_mark_wrapper(18);

select percentile_grade_wrapper(19);

--pid 23
select fill_assessment_mean(102,65,ARRAY[65,75]);
select fill_student_percentile(102,'1',65,ARRAY[65,75]);
select fill_institution_percentile(65);
select fill_studentgroup_percentile(65);
select fill_boundary_percentile(65);
select fill_boundary_studentgroup_percentile(65);
select fill_studentgroup_percentile_gender(65);
select fill_studentgroup_percentile_mt(65);
select fill_boundary_studentgroup_percentile_gender(65);
select fill_boundary_studentgroup_percentile_mt(65);

select fill_assessment_mean(102,75,ARRAY[65,75]);
select fill_student_percentile(102,'1',75,ARRAY[65,75]);
select fill_institution_percentile(75);
select fill_studentgroup_percentile(75);
select fill_boundary_percentile(75);
select fill_boundary_studentgroup_percentile(75);
select fill_studentgroup_percentile_gender(75);
select fill_studentgroup_percentile_mt(75);
select fill_boundary_studentgroup_percentile_gender(75);
select fill_boundary_studentgroup_percentile_mt(75);

select fill_assessment_mean(102,66,ARRAY[66,76]);
select fill_student_percentile(102,'2',66,ARRAY[66,76]);
select fill_institution_percentile(66);
select fill_studentgroup_percentile(66);
select fill_boundary_percentile(66);
select fill_boundary_studentgroup_percentile(66);
select fill_studentgroup_percentile_gender(66);
select fill_studentgroup_percentile_mt(66);
select fill_boundary_studentgroup_percentile_gender(66);
select fill_boundary_studentgroup_percentile_mt(66);

select fill_assessment_mean(102,76,ARRAY[66,76]);
select fill_student_percentile(102,'2',76,ARRAY[66,76]);
select fill_institution_percentile(76);
select fill_studentgroup_percentile(76);
select fill_boundary_percentile(76);
select fill_boundary_studentgroup_percentile(76);
select fill_studentgroup_percentile_gender(76);
select fill_studentgroup_percentile_mt(76);
select fill_boundary_studentgroup_percentile_gender(76);
select fill_boundary_studentgroup_percentile_mt(76);

select fill_assessment_mean(102,67,ARRAY[67,77]);
select fill_student_percentile(102,'3',67,ARRAY[67,77]);
select fill_institution_percentile(67);
select fill_studentgroup_percentile(67);
select fill_boundary_percentile(67);
select fill_boundary_studentgroup_percentile(67);
select fill_studentgroup_percentile_gender(67);
select fill_studentgroup_percentile_mt(67);
select fill_boundary_studentgroup_percentile_gender(67);
select fill_boundary_studentgroup_percentile_mt(67);

select fill_assessment_mean(102,77,ARRAY[67,77]);
select fill_student_percentile(102,'3',77,ARRAY[67,77]);
select fill_institution_percentile(77);
select fill_studentgroup_percentile(77);
select fill_boundary_percentile(77);
select fill_boundary_studentgroup_percentile(77);
select fill_studentgroup_percentile_gender(77);
select fill_studentgroup_percentile_mt(77);
select fill_boundary_studentgroup_percentile_gender(77);
select fill_boundary_studentgroup_percentile_mt(77);





select percentile_mark_wrapper(24);
select percentile_mark_wrapper(25);
select percentile_mark_wrapper(26);
select percentile_mark_wrapper(27);
select percentile_mark_wrapper(28);
select percentile_mark_wrapper(29);
select percentile_mark_wrapper(30);
select percentile_mark_wrapper(31);
select percentile_mark_wrapper(32);
select percentile_mark_wrapper(34);
select percentile_mark_wrapper(35);
select percentile_mark_wrapper(36);

--pid 37
select fill_assessment_mean(121,125,ARRAY[125,148]);
select fill_student_percentile(121,'Anganwadi Class',125,ARRAY[125,148]);
select fill_institution_percentile(125);
select fill_studentgroup_percentile(125);
select fill_boundary_percentile(125);
select fill_boundary_studentgroup_percentile(125);
select fill_studentgroup_percentile_gender(125);
select fill_studentgroup_percentile_mt(125);
select fill_boundary_studentgroup_percentile_gender(125);
select fill_boundary_studentgroup_percentile_mt(125);

select fill_assessment_mean(121,148,ARRAY[125,148]);
select fill_student_percentile(121,'Anganwadi Class',148,ARRAY[125,148]);
select fill_institution_percentile(148);
select fill_studentgroup_percentile(148);
select fill_boundary_percentile(148);
select fill_boundary_studentgroup_percentile(148);
select fill_studentgroup_percentile_gender(148);
select fill_studentgroup_percentile_mt(148);
select fill_boundary_studentgroup_percentile_gender(148);
select fill_boundary_studentgroup_percentile_mt(148);

select fill_assessment_mean(121,126,ARRAY[126,149]);
select fill_student_percentile(121,'Anganwadi Class',126,ARRAY[126,149]);
select fill_institution_percentile(126);
select fill_studentgroup_percentile(126);
select fill_boundary_percentile(126);
select fill_boundary_studentgroup_percentile(126);
select fill_studentgroup_percentile_gender(126);
select fill_studentgroup_percentile_mt(126);
select fill_boundary_studentgroup_percentile_gender(126);
select fill_boundary_studentgroup_percentile_mt(126);

select fill_assessment_mean(121,149,ARRAY[126,149]);
select fill_student_percentile(121,'Anganwadi Class',149,ARRAY[126,149]);
select fill_institution_percentile(149);
select fill_studentgroup_percentile(149);
select fill_boundary_percentile(149);
select fill_boundary_studentgroup_percentile(149);
select fill_studentgroup_percentile_gender(149);
select fill_studentgroup_percentile_mt(149);
select fill_boundary_studentgroup_percentile_gender(149);
select fill_boundary_studentgroup_percentile_mt(149);


select percentile_mark_wrapper(38);

select percentile_grade_wrapper(39);

--pid 40
select fill_assessment_mean(121,160,ARRAY[160]);
select fill_student_percentile(121,'Anganwadi Class',160,ARRAY[160]);
select fill_institution_percentile(160);
select fill_studentgroup_percentile(160);
select fill_boundary_percentile(160);
select fill_boundary_studentgroup_percentile(160);
select fill_studentgroup_percentile_gender(160);
select fill_studentgroup_percentile_mt(160);
select fill_boundary_studentgroup_percentile_gender(160);
select fill_boundary_studentgroup_percentile_mt(160);

select fill_assessment_mean(121,161,ARRAY[161]);
select fill_student_percentile(121,'Anganwadi Class',161,ARRAY[161]);
select fill_institution_percentile(161);
select fill_studentgroup_percentile(161);
select fill_boundary_percentile(161);
select fill_boundary_studentgroup_percentile(161);
select fill_studentgroup_percentile_gender(161);
select fill_studentgroup_percentile_mt(161);
select fill_boundary_studentgroup_percentile_gender(161);
select fill_boundary_studentgroup_percentile_mt(161);


select percentile_mark_wrapper(44);
select percentile_mark_wrapper(45);

select percentile_grade_wrapper(46);

select percentile_mark_wrapper(47);
select percentile_mark_wrapper(48);

--pid 49
select fill_assessment_mean(122,190,ARRAY[190,218]);
select fill_student_percentile(122,'Anganwadi Class',190,ARRAY[190,218]);
select fill_institution_percentile(190);
select fill_studentgroup_percentile(190);
select fill_boundary_percentile(190);
select fill_boundary_studentgroup_percentile(190);
select fill_studentgroup_percentile_gender(190);
select fill_studentgroup_percentile_mt(190);
select fill_boundary_studentgroup_percentile_gender(190);
select fill_boundary_studentgroup_percentile_mt(190);

select fill_assessment_mean(122,218,ARRAY[190,218]);
select fill_student_percentile(122,'Anganwadi Class',218,ARRAY[190,218]);
select fill_institution_percentile(218);
select fill_studentgroup_percentile(218);
select fill_boundary_percentile(218);
select fill_boundary_studentgroup_percentile(218);
select fill_studentgroup_percentile_gender(218);
select fill_studentgroup_percentile_mt(218);
select fill_boundary_studentgroup_percentile_gender(218);
select fill_boundary_studentgroup_percentile_mt(218);

select fill_assessment_mean(122,191,ARRAY[191,219]);
select fill_student_percentile(122,'Anganwadi Class',191,ARRAY[191,219]);
select fill_institution_percentile(191);
select fill_studentgroup_percentile(191);
select fill_boundary_percentile(191);
select fill_boundary_studentgroup_percentile(191);
select fill_studentgroup_percentile_gender(191);
select fill_studentgroup_percentile_mt(191);
select fill_boundary_studentgroup_percentile_gender(191);
select fill_boundary_studentgroup_percentile_mt(191);

select fill_assessment_mean(122,219,ARRAY[191,219]);
select fill_student_percentile(122,'Anganwadi Class',219,ARRAY[191,219]);
select fill_institution_percentile(219);
select fill_studentgroup_percentile(219);
select fill_boundary_percentile(219);
select fill_boundary_studentgroup_percentile(219);
select fill_studentgroup_percentile_gender(219);
select fill_studentgroup_percentile_mt(219);
select fill_boundary_studentgroup_percentile_gender(219);
select fill_boundary_studentgroup_percentile_mt(219);



select percentile_mark_wrapper(50);
select percentile_mark_wrapper(51);


--pid 53
select fill_assessment_grade_percentilerank(123,230,ARRAY[230,273]);
select fill_student_grade_percentile(123,230,ARRAY[230,273]);
select fill_institution_percentile(230);
select fill_studentgroup_percentile(230);
select fill_boundary_percentile(230);
select fill_boundary_studentgroup_percentile(230);
select fill_studentgroup_percentile_gender(230);
select fill_studentgroup_percentile_mt(230);
select fill_boundary_studentgroup_percentile_gender(230);
select fill_boundary_studentgroup_percentile_mt(230);

select fill_assessment_grade_percentilerank(123,273,ARRAY[230,273]);
select fill_student_grade_percentile(123,273,ARRAY[230,273]);
select fill_institution_percentile(273);
select fill_studentgroup_percentile(273);
select fill_boundary_percentile(273);
select fill_boundary_studentgroup_percentile(273);
select fill_studentgroup_percentile_gender(273);
select fill_studentgroup_percentile_mt(273);
select fill_boundary_studentgroup_percentile_gender(273);
select fill_boundary_studentgroup_percentile_mt(273);

select fill_assessment_grade_percentilerank(123,231,ARRAY[231,274]);
select fill_student_grade_percentile(123,231,ARRAY[231,274]);
select fill_institution_percentile(231);
select fill_studentgroup_percentile(231);
select fill_boundary_percentile(231);
select fill_boundary_studentgroup_percentile(231);
select fill_studentgroup_percentile_gender(231);
select fill_studentgroup_percentile_mt(231);
select fill_boundary_studentgroup_percentile_gender(231);
select fill_boundary_studentgroup_percentile_mt(231);

select fill_assessment_grade_percentilerank(123,274,ARRAY[231,274]);
select fill_student_grade_percentile(123,274,ARRAY[231,274]);
select fill_institution_percentile(274);
select fill_studentgroup_percentile(274);
select fill_boundary_percentile(274);
select fill_boundary_studentgroup_percentile(274);
select fill_studentgroup_percentile_gender(274);
select fill_studentgroup_percentile_mt(274);
select fill_boundary_studentgroup_percentile_gender(274);
select fill_boundary_studentgroup_percentile_mt(274);

select fill_assessment_grade_percentilerank(123,232,ARRAY[232,275]);
select fill_student_grade_percentile(123,232,ARRAY[232,275]);
select fill_institution_percentile(232);
select fill_studentgroup_percentile(232);
select fill_boundary_percentile(232);
select fill_boundary_studentgroup_percentile(232);
select fill_studentgroup_percentile_gender(232);
select fill_studentgroup_percentile_mt(232);
select fill_boundary_studentgroup_percentile_gender(232);
select fill_boundary_studentgroup_percentile_mt(232);

select fill_assessment_grade_percentilerank(123,275,ARRAY[232,275]);
select fill_student_grade_percentile(123,275,ARRAY[232,275]);
select fill_institution_percentile(275);
select fill_studentgroup_percentile(275);
select fill_boundary_percentile(275);
select fill_boundary_studentgroup_percentile(275);
select fill_studentgroup_percentile_gender(275);
select fill_studentgroup_percentile_mt(275);
select fill_boundary_studentgroup_percentile_gender(275);
select fill_boundary_studentgroup_percentile_mt(275);

select percentile_grade_wrapper(54);
select percentile_grade_wrapper(55);
select percentile_grade_wrapper(56);


--pid 57
select fill_assessment_mean(123,242,ARRAY[242,286]);
select fill_student_percentile(123,'Anganwadi Class',242,ARRAY[242,286]);
select fill_institution_percentile(242);
select fill_studentgroup_percentile(242);
select fill_boundary_percentile(242);
select fill_boundary_studentgroup_percentile(242);
select fill_studentgroup_percentile_gender(242);
select fill_studentgroup_percentile_mt(242);
select fill_boundary_studentgroup_percentile_gender(242);
select fill_boundary_studentgroup_percentile_mt(242);

select fill_assessment_mean(123,286,ARRAY[242,286]);
select fill_student_percentile(123,'Anganwadi Class',286,ARRAY[242,286]);
select fill_institution_percentile(286);
select fill_studentgroup_percentile(286);
select fill_boundary_percentile(286);
select fill_boundary_studentgroup_percentile(286);
select fill_studentgroup_percentile_gender(286);
select fill_studentgroup_percentile_mt(286);
select fill_boundary_studentgroup_percentile_gender(286);
select fill_boundary_studentgroup_percentile_mt(286);

select fill_assessment_mean(123,243,ARRAY[243,287]);
select fill_student_percentile(123,'Anganwadi Class',243,ARRAY[243,287]);
select fill_institution_percentile(243);
select fill_studentgroup_percentile(243);
select fill_boundary_percentile(243);
select fill_boundary_studentgroup_percentile(243);
select fill_studentgroup_percentile_gender(243);
select fill_studentgroup_percentile_mt(243);
select fill_boundary_studentgroup_percentile_gender(243);
select fill_boundary_studentgroup_percentile_mt(243);

select fill_assessment_mean(123,287,ARRAY[243,287]);
select fill_student_percentile(123,'Anganwadi Class',287,ARRAY[243,287]);
select fill_institution_percentile(287);
select fill_studentgroup_percentile(287);
select fill_boundary_percentile(287);
select fill_boundary_studentgroup_percentile(287);
select fill_studentgroup_percentile_gender(287);
select fill_studentgroup_percentile_mt(287);
select fill_boundary_studentgroup_percentile_gender(287);
select fill_boundary_studentgroup_percentile_mt(287);


--pid 58
select fill_assessment_mean(123,244,ARRAY[244]);
select fill_student_percentile(123,'6',244,ARRAY[244]);
select fill_institution_percentile(244);
select fill_studentgroup_percentile(244);
select fill_boundary_percentile(244);
select fill_boundary_studentgroup_percentile(244);
select fill_studentgroup_percentile_gender(244);
select fill_studentgroup_percentile_mt(244);
select fill_boundary_studentgroup_percentile_gender(244);
select fill_boundary_studentgroup_percentile_mt(244);

select fill_assessment_mean(123,245,ARRAY[245]);
select fill_student_percentile(123,'7',245,ARRAY[245]);
select fill_institution_percentile(245);
select fill_studentgroup_percentile(245);
select fill_boundary_percentile(245);
select fill_boundary_studentgroup_percentile(245);
select fill_studentgroup_percentile_gender(245);
select fill_studentgroup_percentile_mt(245);
select fill_boundary_studentgroup_percentile_gender(245);
select fill_boundary_studentgroup_percentile_mt(245);


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

