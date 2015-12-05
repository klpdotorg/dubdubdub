psql -U klp -d testdub -f gradeassessment-aggregates.sql
echo "Finished grade assessment aggregates"
psql -U klp -d testdub -f fillgradeassessment-aggregates.sql
echo "Finished fill grade assessments"
psql -U klp -d testdub -f assessmentcorrections.sql
echo "Finished assessment corrections"
psql -U klp -d testdub -f fillassessments2014-2015.sql
echo "Finished 2014-2015"
psql -U klp -d testdub -f percentile.sql
echo "Finished percentile.sql"
psql -U klp -d testdub -f fillmarkpercentile.sql
echo "Finished mark percentile"
