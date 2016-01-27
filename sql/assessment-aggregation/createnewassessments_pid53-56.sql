update tb_programme set ayid=123 where id in (54,55,56);

--pid 53
insert into tb_programme values (53230,'Reading-Bangalore Dummy','2014-08-26','2015-12-30',1,123,1);
update tb_assessment set pid=53230 where id in (230,231,232,273,274,275);


insert into tb_assessment values (2305300,'Class 3 Kannada Reading Pretest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2305303,'Class 3 Urdu Reading Pretest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2305304,'Class 3 Tamil Reading Pretest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2305305,'Class 3 Telugu Reading Pretest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2305306,'Class 3 English Reading Pretest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2315301,'Class 4 Kannada Reading Pretest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2315307,'Class 4 Urdu Reading Pretest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2315308,'Class 4 Tamil Reading Pretest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2315309,'Class 4 Telugu Reading Pretest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2315310,'Class 4 English Reading Pretest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2325302,'Class 5 Kannada Reading Pretest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2325311,'Class 5 Urdu Reading Pretest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2325312,'Class 5 Tamil Reading Pretest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2325313,'Class 5 Telugu Reading Pretest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2325314,'Class 5 English Reading Pretest',53,'2014-08-26','2015-12-30');

insert into tb_assessment values (2736306,'Class 3 Kannada Reading Posttest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2736307,'Class 3 Urdu Reading Posttest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2736308,'Class 3 Tamil Reading Posttest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2736309,'Class 3 Telugu Reading Posttest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2736310,'Class 3 English Reading Posttest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2746312,'Class 4 Kannada Reading Posttest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2746313,'Class 4 Urdu Reading Posttest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2746314,'Class 4 Tamil Reading Posttest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2746315,'Class 4 Telugu Reading Posttest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2746316,'Class 4 English Reading Posttest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2756318,'Class 5 Kannada Reading Posttest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2756319,'Class 5 Urdu Reading Posttest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2756320,'Class 5 Tamil Reading Posttest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2756321,'Class 5 Telugu Reading Posttest',53,'2014-08-26','2015-12-30');
insert into tb_assessment values (2756322,'Class 5 English Reading Posttest',53,'2014-08-26','2015-12-30');



update tb_question set assid=2305300 where id=5300;
update tb_question set assid=2305303 where id=5303;
update tb_question set assid=2305304 where id=5304;
update tb_question set assid=2305305 where id=5305;
update tb_question set assid=2305306 where id=5306;

update tb_question set assid=2315301 where id=5301;
update tb_question set assid=2315307 where id=5307;
update tb_question set assid=2315308 where id=5308;
update tb_question set assid=2315309 where id=5309;
update tb_question set assid=2315310 where id=5310;

update tb_question set assid=2325302 where id=5302;
update tb_question set assid=2325311 where id=5311;
update tb_question set assid=2325312 where id=5312;
update tb_question set assid=2325313 where id=5313;
update tb_question set assid=2325314 where id=5314;

update tb_question set assid=2736306 where id=6306;
update tb_question set assid=2736307 where id=6307;
update tb_question set assid=2736308 where id=6308;
update tb_question set assid=2736309 where id=6309;
update tb_question set assid=2736310 where id=6310;

update tb_question set assid=2746312 where id=6312;
update tb_question set assid=2746313 where id=6313;
update tb_question set assid=2746314 where id=6314;
update tb_question set assid=2746315 where id=6315;
update tb_question set assid=2746316 where id=6316;

update tb_question set assid=2756318 where id=6318;
update tb_question set assid=2756319 where id=6319;
update tb_question set assid=2756320 where id=6320;
update tb_question set assid=2756321 where id=6321;
update tb_question set assid=2756322 where id=6322;


--pid 54
insert into tb_programme values (54233,'Reading-Hosakote-Dummy','2014-08-26','2015-12-30',1,123,1);
update tb_assessment set pid=54233 where id in (233,234,235);


insert into tb_assessment values (2335315,'Class 3 Kannada Reading Pretest',54,'2014-08-26','2015-12-30');
insert into tb_assessment values (2335316,'Class 3 Math Reading Pretest',54,'2014-08-26','2015-12-30');
insert into tb_assessment values (2335317,'Class 3 English Reading Pretest',54,'2014-08-26','2015-12-30');
insert into tb_assessment values (2345318,'Class 4 Kannada Reading Pretest',54,'2014-08-26','2015-12-30');
insert into tb_assessment values (2345319,'Class 4 Math Reading Pretest',54,'2014-08-26','2015-12-30');
insert into tb_assessment values (2345320,'Class 4 English Reading Pretest',54,'2014-08-26','2015-12-30');
insert into tb_assessment values (2355321,'Class 5 Kannada Reading Pretest',54,'2014-08-26','2015-12-30');
insert into tb_assessment values (2355322,'Class 5 Math Reading Pretest',54,'2014-08-26','2015-12-30');
insert into tb_assessment values (2355323,'Class 5 English Reading Pretest',54,'2014-08-26','2015-12-30');


update tb_question set assid=2335315 where id=5315;
update tb_question set assid=2335316 where id=5316;
update tb_question set assid=2335317 where id=5317;

update tb_question set assid=2345318 where id=5318;
update tb_question set assid=2345319 where id=5319;
update tb_question set assid=2345320 where id=5320;

update tb_question set assid=2355321 where id=5321;
update tb_question set assid=2355322 where id=5322;
update tb_question set assid=2355323 where id=5323;


--pid 55
insert into tb_programme values (55236,'Reading-Kushtagi-Dummy','2014-09-18','2015-12-30',1,123,1);
update tb_assessment set pid=55236 where id in (236,237,238,294,295,296);

insert into tb_assessment values (2365327,'Class 3 Kannada Reading Pretest',55,'2014-09-18','2015-12-30');
insert into tb_assessment values (2365328,'Class 3 Math Reading Pretest',55,'2014-09-18','2015-12-30');
insert into tb_assessment values (2365329,'Class 3 English Reading Pretest',55,'2014-09-18','2015-12-30');

insert into tb_assessment values (2375330,'Class 4 Kannada Reading Pretest',55,'2014-09-18','2015-12-30');
insert into tb_assessment values (2375331,'Class 4 Math Reading Pretest',55,'2014-09-18','2015-12-30');
insert into tb_assessment values (2375332,'Class 4 English Reading Pretest',55,'2014-09-18','2015-12-30');

insert into tb_assessment values (2385333,'Class 5 Kannada Reading Pretest',55,'2014-09-18','2015-12-30');
insert into tb_assessment values (2385334,'Class 5 Math Reading Pretest',55,'2014-09-18','2015-12-30');
insert into tb_assessment values (2385335,'Class 5 English Reading Pretest',55,'2014-09-18','2015-12-30');

insert into tb_assessment values (2946857,'Class 3 Kannada Reading Posttest',55,'2014-09-18','2015-12-30');
insert into tb_assessment values (2946858,'Class 3 Math Reading Posttest',55,'2014-09-18','2015-12-30');
insert into tb_assessment values (2946859,'Class 3 English Reading Posttest',55,'2014-09-18','2015-12-30');

insert into tb_assessment values (2956860,'Class 4 Kannada Reading Posttest',55,'2014-09-18','2015-12-30');
insert into tb_assessment values (2956861,'Class 4 Math Reading Posttest',55,'2014-09-18','2015-12-30');
insert into tb_assessment values (2956862,'Class 4 English Reading Posttest',55,'2014-09-18','2015-12-30');

insert into tb_assessment values (2966863,'Class 5 Kannada Reading Posttest',55,'2014-09-18','2015-12-30');
insert into tb_assessment values (2966864,'Class 5 Math Reading Posttest',55,'2014-09-18','2015-12-30');
insert into tb_assessment values (2966865,'Class 5 English Reading Posttest',55,'2014-09-18','2015-12-30');

update tb_question set assid=2365327 where id=5327;
update tb_question set assid=2365328 where id=5328;
update tb_question set assid=2365329 where id=5329;

update tb_question set assid=2375330 where id=5330;
update tb_question set assid=2375331 where id=5331;
update tb_question set assid=2375332 where id=5332;

update tb_question set assid=2385333 where id=5333;
update tb_question set assid=2385334 where id=5334;
update tb_question set assid=2385335 where id=5335;

update tb_question set assid=2946857 where id=6857;
update tb_question set assid=2946858 where id=6858;
update tb_question set assid=2946859 where id=6859;

update tb_question set assid=2956860 where id=6860;
update tb_question set assid=2956861 where id=6861;
update tb_question set assid=2956862 where id=6862;

update tb_question set assid=2966863 where id=6863;
update tb_question set assid=2966864 where id=6864;
update tb_question set assid=2966865 where id=6865;


--pid 56
insert into tb_programme values (56239,'Reading-Mundaragi-Dummy','2014-09-18','2015-12-30',1,123,1);
update tb_assessment set pid=56239 where id in (239,240,241,288,289,290);

insert into tb_assessment values (2395336,'Class 3 Kannada Reading Pretest',56,'2014-09-19','2015-12-30');
insert into tb_assessment values (2395337,'Class 3 Math Reading Pretest',56,'2014-09-19','2015-12-30');
insert into tb_assessment values (2395338,'Class 3 English Reading Pretest',56,'2014-09-19','2015-12-30');

insert into tb_assessment values (2405339,'Class 4 Kannada Reading Pretest',56,'2014-09-19','2015-12-30');
insert into tb_assessment values (2405340,'Class 4 Math Reading Pretest',56,'2014-09-19','2015-12-30');
insert into tb_assessment values (2405341,'Class 4 English Reading Pretest',56,'2014-09-19','2015-12-30');

insert into tb_assessment values (2415342,'Class 5 Kannada Reading Pretest',56,'2014-09-19','2015-12-30');
insert into tb_assessment values (2415343,'Class 5 Math Reading Pretest',56,'2014-09-19','2015-12-30');
insert into tb_assessment values (2415344,'Class 5 English Reading Pretest',56,'2014-09-19','2015-12-30');

insert into tb_assessment values (2886688,'Class 3 Kannada Reading Posttest',56,'2014-09-19','2015-12-30');
insert into tb_assessment values (2886689,'Class 3 Math Reading Posttest',56,'2014-09-19','2015-12-30');
insert into tb_assessment values (2886690,'Class 3 English Reading Posttest',56,'2014-09-19','2015-12-30');

insert into tb_assessment values (2896691,'Class 4 Kannada Reading Posttest',56,'2014-09-19','2015-12-30');
insert into tb_assessment values (2896692,'Class 4 Math Reading Posttest',56,'2014-09-19','2015-12-30');
insert into tb_assessment values (2896693,'Class 4 English Reading Posttest',56,'2014-09-19','2015-12-30');

insert into tb_assessment values (2906694,'Class 5 Kannada Reading Posttest',56,'2014-09-19','2015-12-30');
insert into tb_assessment values (2906695,'Class 5 Math Reading Posttest',56,'2014-09-19','2015-12-30');
insert into tb_assessment values (2906696,'Class 5 English Reading Posttest',56,'2014-09-19','2015-12-30');

update tb_question set assid=2395336 where id=5336;
update tb_question set assid=2395337 where id=5337;
update tb_question set assid=2395338 where id=5338;

update tb_question set assid=2405339 where id=5339;
update tb_question set assid=2405340 where id=5340;
update tb_question set assid=2405341 where id=5341;

update tb_question set assid=2415342 where id=5342;
update tb_question set assid=2415343 where id=5343;
update tb_question set assid=2415344 where id=5344;

update tb_question set assid=2886688 where id=6688;
update tb_question set assid=2886689 where id=6689;
update tb_question set assid=2886690 where id=6690;

update tb_question set assid=2896691 where id=6691;
update tb_question set assid=2896692 where id=6692;
update tb_question set assid=2896693 where id=6693;

update tb_question set assid=2906694 where id=6694;
update tb_question set assid=2906695 where id=6695;
update tb_question set assid=2906696 where id=6696;

