echo "##################################"
echo "START_LOG"
date
echo "##################################"

recreate_tables=off

while getopts ":t" opt
do
    case "$opt" in
        t)  recreate_tables=on;;
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
    psql -U klp dubdubdub_bak < data/ems/droptables.sql
    echo "Creating tables"
    psql -U klp dubdubdub_bak < data/ems/createtables.sql

    for f in `pwd`/data/ems/*.csv;
    do
        filename=$(basename $f .csv)
        echo "Inserting data to temp table: $filename"
        psql -U klp -d dubdubdub_bak -c "copy ems_$filename from '$f' CSV HEADER"
    done
fi

# for f in data/ems/*.csv; do csv-to-table $f --sample 0.3 --header --table_name ems_$(basename $f .csv) >> data/ems/create.sql; done

psql -1 -U klp -d dubdubdub_bak < data/ems/importdata.sql
