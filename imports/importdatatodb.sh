echo "##################################"
echo "START_LOG"
date
echo "##################################"

recreate_tables=off
dbname="dubdubdub_bak"

while getopts ":t" opt
do
    case "$opt" in
        t)  recreate_tables=on;;
        d)  dbname="$OPTARG";;
        \?)       # unknown flag
            echo >&2
            echo "usage: $0 [-t]"
            echo
            echo "-t   recreates the temp EMS tables and reimports the csvs to them"
      exit 1;;
    esac
done
shift `expr $OPTIND - 1`

if [ $recreate_tables = on ]; then
    echo "Dropping tables"
    psql -U klp $dbname < imports/sql/droptables.sql
    echo "Creating tables"
    psql -U klp $dbname < imports/sql/createtables.sql

    for f in `pwd`/data/ems/*.csv;
    do
        filename=$(basename $f .csv)
        echo "Inserting data to temp table: $filename"
        psql -U klp -d $dbname -c "copy ems_$filename from '$f' CSV HEADER"
    done
fi

# for f in data/ems/*.csv; do csv-to-table $f --sample 0.3 --header --table_name ems_$(basename $f .csv) >> data/ems/create.sql; done

# psql -1 -U klp -d dubdubdub_bak < data/ems/importdata.sql
