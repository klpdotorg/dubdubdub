psql -U klp -d dubdubdub -f deletequestions.sql
echo "Finished delete questions"
psql -U klp -d dubdubdub -f assessment-aggregates.sql
echo "Finished assessment-aggregates"
psql -U klp -d dubdubdub -f fillassessmentaggregates.sql
echo "Finished fillassessmentaggregates"
psql -U klp -d dubdubdub -f fillboundaryassessments.sql
echo "Finished fillboundaryassessments"
#psql -U klp -d dubdubdub -f gradeassessment-aggregates.sql
#echo "Finished grade assessment aggregates"
#psql -U klp -d dubdubdub -f fillgradeassessment-aggregates.sql
#echo "Finished fill grade assessments"
psql -U klp -d dubdubdub -f assessmentcorrections.sql
echo "Finished assessment corrections"
psql -U klp -d dubdubdub -f fillassessments2014-2015.sql
echo "Finished 2014-2015"
psql -U klp -d dubdubdub -f percentile.sql
echo "Finished percentile.sql"
psql -U klp -d dubdubdub -f fillmarkpercentile.sql
echo "Finished mark percentile"
psql -U klp -d dubdubdub -f fillassessments_pid60-63.sql
echo "Finished running aggregates for pid 60-63"
