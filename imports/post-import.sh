# TODO: accept -d param and use that instead of hard coding db name
sudo -u postgres psql -d dubdubdub -f sql/refresh_materialized_views.sql
./sql/assessment-aggregation/run_markpercentile.sh -d dubdubdub
./sql/assessment-aggregation/run_gradepercentile.sh -d dubdubdub