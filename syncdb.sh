echo "##################################"
echo "Starting the sync process"
date
echo "##################################"

all_dbs=off
temp_dir_name='temp_dbs'

while getopts d:a opt
do
    case "$opt" in
        a)  all_dbs=on;;
        d)  dbname="$OPTARG";;
        \?)       # unknown flag
            echo >&2
            echo "usage: $0 [-a]"
            echo
            echo "-a   sync all the databases"
      exit 1;;
    esac
done
shift `expr $OPTIND - 1`

if [ $all_dbs = on ];
then
    mkdir -p $temp_dir_name
    for i in "spatial" "gis_master" "klp-coord" "electrep_new" "dise_all" "apmdm" "klpdise_olap" "ang_infra" "libinfra" "library" "pratham_mysore" "dubdubdub"
    do
        echo "Downloading '$i'"
        mkdir -p ./$temp_dir_name/$i/
        latest_dump=`ssh klp.org.in ls /home/vamsee/backups/db/$i | head -n 1`
        rsync -avz -e ssh klp.org.in:"/home/vamsee/backups/db/$i/$latest_dump" ./$temp_dir_name/$i/

        # now restore them using dropdb, createdb and psql
    done
elif [ -n $dbname ]
then
    echo $dbname
fi

rm -rf $temp_dir_name
