# IMPORTANT: Run this from the machine that's running the DB
# e.g. Vagrant box. Or change the HOST variable

# Destination directory where backups should be put
DEST_DIR="."
HOST="localhost"
DBUSER=""

# List of directories to backup
# each directory in a new line
DBS=""

for d in $DBS
do
    echo "Backing up $d"
    # SLUG="$(echo -n "${d}" | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z)"

    # binary backup file
    pg_dump -U $DBUSER -h $HOST -W -F c --file=$DEST_DIR/$d-`date +"%d-%b-%y"`.backup $d

    # plain SQL without owner/role
    pg_dump -Ox -h $HOST -U $DBUSER $d > $DEST_DIR/$d-`date +"%d-%b-%y"`.pgsql
done
