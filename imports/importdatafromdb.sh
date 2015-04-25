echo "##################################"
echo "START_LOG"
date
echo "##################################"

dbname="dubdubdub_bak"

while getopts d: opt
do
    case "$opt" in
        d)  dbname="$OPTARG";;
        \?)       # unknown flag
            echo >&2
            echo "usage: $0 [-d dbname]"
            echo
            echo "-d dbname   the database name to impoty data to."
      exit 1;;
    esac
done
shift `expr $OPTIND - 1`

sudo -u postgres psql -d $dbname -f imports/sql/import_boundary.sql
python manage.py import_ems # import schools and address
sudo -u postgres psql -d $dbname -f imports/sql/import_child.sql
sudo -u postgres psql -d $dbname -f imports/sql/import_class.sql
sudo -u postgres psql -d $dbname -f imports/sql/import_student.sql
sudo -u postgres psql -d $dbname -f imports/sql/import_student_class.sql
sudo -u postgres psql -d $dbname -f imports/sql/import_teacher.sql
sudo -u postgres psql -d $dbname -f imports/sql/import_teacher_class.sql
sudo -u postgres psql -d $dbname -f imports/sql/import_teacher_qual.sql
sudo -u postgres psql -d $dbname -f imports/sql/import_programme.sql
sudo -u postgres psql -d $dbname -f imports/sql/import_assessment.sql
sudo -u postgres psql -d $dbname -f imports/sql/import_question.sql
sudo -u postgres psql -d $dbname -f imports/sql/import_student_eval.sql
