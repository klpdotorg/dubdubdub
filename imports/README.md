## How to import

run this command from project root

    ./imports/import-ems.sh

## Order of the files being imported

    tb_boundary.csv
    tb_school.csv
    tb_address.csv
    tb_child.csv
    tb_class.csv
    tb_student.csv
    tb_student_class.csv
    tb_teacher.csv
    tb_teacher_class.csv
    tb_teacher_qual.csv
    tb_programme.csv
    tb_assessment.csv
    tb_question.csv
    tb_student_eval.csv

So, if you want to import schools, you must also export the boundary table from EMS

## Importing status of schools

Export only the columns `id` and `active` from EMS into a CSV file named `school_id_status.csv` and place it in `data/ems`, and run

    python manage.py import_school_status
