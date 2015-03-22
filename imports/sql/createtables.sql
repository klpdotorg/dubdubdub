CREATE TABLE ems_tb_academic_year (
	id smallint,
	name text,
	active boolean
);
CREATE TABLE ems_tb_address (
	id int,
	address text,
	area text,
	pincode text,
	landmark text,
	instidentification text,
	instidentification2 text,
	route_information text
);
CREATE TABLE ems_tb_assessment (
	id smallint,
	name text,
	programme_id smallint,
	start_date date,
	end_date date
);
CREATE TABLE ems_tb_bhierarchy (
	id smallint,
	boundary_category text
);
CREATE TABLE ems_tb_boundary (
	id smallint,
	parent_id smallint,
	name text,
	boundary_category_id smallint,
	boundary_type_id smallint
);
CREATE TABLE ems_tb_boundary_type (
	id smallint,
	boundary_type text
);
CREATE TABLE ems_tb_child (
	id int,
	first_name text,
	middle_name text,
	last_name text,
	dob date,
	gender text,
	mt text
);
CREATE TABLE ems_tb_class (
	id int,
	institution_id int,
	class text,
	section text
);
CREATE TABLE ems_tb_programme (
	id smallint,
	name text,
	start_date date,
	end_date date,
	programme_institution_category_id smallint
);
CREATE TABLE ems_tb_question (
	id smallint,
	assessment_id smallint,
	name text,
	question_type smallint,
	score_max text,
	score_min text,
	grade text
);
CREATE TABLE ems_tb_school (
	id integer,
	boundary_id smallint,
	inst_address_id text,
	dise_code text,
	inst_name text,
	inst_category text,
	institution_gender text,
	moi text,
	management text,
	active smallint
);
CREATE TABLE ems_tb_student_class (
	student_id int,
	student_group_id int,
	academic_id smallint,
	active smallint
);
CREATE TABLE ems_tb_student (
	id int,
	child_id int,
	other_student_id text,
	active smallint
);
CREATE TABLE ems_tb_student_eval (
	question_id smallint,
	object_id int,
	content_type_id smallint,
	answer_score text,
	answer_grade text
);
CREATE TABLE ems_tb_teacher_class (
	staff_id smallint,
	student_group_id int,
	academic_id smallint,
	active smallint
);
CREATE TABLE ems_tb_teacher (
	id smallint,
	institution_id int,
	first_name text,
	middle_name text,
	last_name text,
	gender text,
	active smallint,
	mt text,
	doj text,
	staff_type text
);
CREATE TABLE ems_tb_teacher_qual (
	staff_id smallint,
	qualification text
);
