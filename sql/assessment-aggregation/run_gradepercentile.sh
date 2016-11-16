psql -U klp -d dubdubdub -f gradeassessment-aggregates.sql
echo "Finished grade assessment aggregates"
psql -U klp -d dubdubdub -f createnewassessments_pid53-56.sql
echo "Finished creating new grade assessments"
psql -U klp -d dubdubdub -f fillgradeassessment-aggregates.sql
echo "Finished fill grade assessments"
psql -U klp -d dubdubdub -f fillgradepercentile.sql
echo "Finished grade percentile"
psql -U klp -d dubdubdub -f assessment-aggregation_pid53-56.sql
echo "Finished creating functions for pid 53-56"
psql -U klp -d dubdubdub -f fillassessments_pid53-56.sql
echo "Finished grade percentile for newly created assessments"
