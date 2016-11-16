echo "RUNNING MARKS PERCENTILE"
export dbname="dubdubdub"
#fix this to read from command line ^
psql -U klp -d $dbname -f ./sql/assessment-aggregation/deletequestions.sql
echo "Finished delete questions"
psql -U klp -d $dbname -f ./sql/assessment-aggregation/assessment-aggregates.sql
echo "Finished assessment-aggregates"
psql -U klp -d $dbname -f ./sql/assessment-aggregation/fillassessmentaggregates.sql
echo "Finished fillassessmentaggregates"
psql -U klp -d $dbname -f ./sql/assessment-aggregation/fillboundaryassessments.sql
echo "Finished fillboundaryassessments"
#psql -U klp -d $dbname -f ./sql/assessment-aggregation/gradeassessment-aggregates.sql
#echo "Finished grade assessment aggregates"
#psql -U klp -d $dbname -f ./sql/assessment-aggregation/fillgradeassessment-aggregates.sql
#echo "Finished fill grade assessments"
psql -U klp -d $dbname -f ./sql/assessment-aggregation/assessmentcorrections.sql
echo "Finished assessment corrections"
psql -U klp -d $dbname -f ./sql/assessment-aggregation/fillassessments2014-2015.sql
echo "Finished 2014-2015"
psql -U klp -d $dbname -f ./sql/assessment-aggregation/percentile.sql
echo "Finished percentile.sql"
psql -U klp -d $dbname -f ./sql/assessment-aggregation/fillmarkpercentile.sql
echo "Finished mark percentile"
psql -U klp -d $dbname -f ./sql/assessment-aggregation/fillassessments_pid60-63.sql
echo "Finished running aggregates for pid 60-63"
