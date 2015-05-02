CREATE INDEX tb_student_eval_grade_idx ON tb_student_eval(grade);
ANALYZE tb_student_eval;

UPDATE tb_student_eval SET grade=TRIM(grade);

UPDATE tb_student_eval SET grade='0' WHERE grade='000000' OR grade='000' OR grade='00' OR grade='.0' OR grade='0.';

UPDATE tb_student_eval SET grade='1' WHERE grade='01';

UPDATE tb_student_eval SET grade=NULL WHERE grade='';

UPDATE tb_student_eval SET grade=NULL WHERE grade='NA';

UPDATE tb_student_eval SET grade='1' WHERE grade LIKE '1%' AND LENGTH(grade)>1;

