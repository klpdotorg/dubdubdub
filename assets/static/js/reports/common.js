'use strict';
(function() {
    var t = klp.reportCommon = {};
    var upperPrimaryCategories = [2, 3, 4, 5, 6, 7];
    var repType;
    var acadYear;
    var diseType = {
        "mp constituency": "parliament",
        "ward": "ward",
        "mla constituency": "assembly",
    };


    t.getElectedRepType = function(type){
        return diseType[type];
    };

    /*
        Fill the summaryData structure.
    */
    t.getSummaryData = function (diseData, baseData, categoryData, type, year) {
        repType = type;
        acadYear = year;
        var summaryData = {
            "boundary"  : baseData,
            "school_count" : categoryData["schoolcount"],
            "teacher_count" : diseData["properties"]["sum_male_tch"] +
                                        diseData["properties"]["sum_female_tch"],
            "gender" : categoryData["gendercount"],
            "student_total": categoryData["gendercount"]["boys"] +
                                        categoryData["gendercount"]["girls"]
        };
        if( summaryData["teacher_count"] === 0 )
            summaryData['ptr'] = "NA";
        else
            summaryData['ptr'] = Math.round(summaryData["student_total"]/
                                                summaryData["teacher_count"]);
        summaryData['girl_perc'] = Math.round(( summaryData["gender"]["girls"]/
                                            summaryData["student_total"] )*100);
        summaryData['boy_perc'] = 100-summaryData['girl_perc'];

        return summaryData;
    };

    /*
        Gets school count and gender count for schools that are of type lower 
        primary or upper primary only.
    */
    t.getCategoryCount= function (data){
        var categorycount = {"schoolcount": 0,
                             "gendercount":  {"boys": 0, "girls": 0}
                            };
        for(var iter in data["school_categories"])
        {
            var type = data["school_categories"][iter];
            if(type["id"] == 1 || _.contains(upperPrimaryCategories,
                type["id"])){
                categorycount["schoolcount"] += type["sum_schools"]["total"];
                categorycount["gendercount"]["boys"] += type["sum_boys"];
                categorycount["gendercount"]["girls"] += type["sum_girls"];
            }
        }
        return categorycount;
    };
 
    /*
        Render the summary
    */
    t.renderSummary = function (summaryData) {
        var tplTopSummary = swig.compile($('#tpl-topSummary').html());
        var tplReportDate = swig.compile($('#tpl-reportDate').html());
        var now = new Date();
        var today = {'date' : moment(now).format("MMMM D, YYYY")};
        var dateHTML = tplReportDate({"today":today});
        $('#report-date').html(dateHTML);
        var topSummaryHTML = tplTopSummary({"data":summaryData});
        $('#top-summary').html(topSummaryHTML);
    };

    /*
        Get Neighbour Data by calling dise api multiple times by passing 
        different boundary
    */
    t.getNeighbourData = function (klpData, renderNeighbours)
    {
        var loopData;
        var passBoundaryData = {"acadYear": acadYear};
        if( repType == "boundary" )
        {
            var type = klpData["report_info"]["type"];
            if(type == "district")
                loopData = klpData["neighbours"];
            else
                loopData = klpData["report_info"]["parent"];
        }
        else
        {
            loopData = klpData["neighbour_info"];
        }
        t.getMultipleData(loopData, passBoundaryData, t.getMultipleNeighbour,
                          renderNeighbours);
    };

    /*
     * This function is used to call multiple apis before processing a 
     * function (exitFunction).
     * The inputData is used for looping through and has the data that needs 
     * to be passed.
     * The passData is used for passing the data to the function (getData) which 
     * is used for making 
     * the relevant api calls.
     * Once the loop is over the exitFunction is called.
     */
    t.getMultipleData = function(inputData, passData, getData, exitFunction,
                                 iteratorName="iter")
    {
        var numberOfIterations = Object.keys(inputData).length;
        var outputData= [];
        var index = 0,
            done = false,
            shouldExit = false;
        var loop = {
            next:function(){
                if(done){
                    if(shouldExit && exitFunction){
                        return exitFunction(outputData); // Exit if we're done
                    }
                }
                if(index <  numberOfIterations){
                    index++; // Increment our index
                    getData(loop); // Run our process, pass in the loop
                }
                else {
                    done = true; // Make sure we say we're done
                    if(exitFunction)
                        exitFunction(outputData); // Call the callback on exit
                }
            },
            iteration:function(){
                passData[iteratorName] = Object.keys(inputData)[index-1];
                passData["value"] = inputData[passData[iteratorName]];
                return passData; // Return the loop number we're on
            },
            addData:function(diseData){
                outputData[Object.keys(inputData)[index-1]] = diseData;
            },
            break:function(end){
                done = true; // End the loop
                shouldExit = end; // Passing end as true means we still call the exit callback
            }
        };
        loop.next();
        return loop;
    };


    /*
        Call DISE API with information of neighbours
    */
    t.getMultipleNeighbour = function(loop)
    {
        var data = loop.iteration();
        var type;
        if( repType == "boundary" ) //for district/block/cluster
            type = data["value"]["type"];
        else //for electedrep
            type = repType;
        var boundary = {"id": data["value"]["dise"], "type": type};
        klp.dise_api.getBoundaryData(boundary.id, boundary.type, acadYear).done(
            function(diseData) {
            console.log('diseData', diseData);
            loop.addData(diseData);
            loop.next();
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not dise data", "for "+data["dise"]);
        });
    };

    /*
        Get year data by passing different year to the DISE api.
    */
    t.getYearData = function (klpData, renderYearComparison)
    {
        var passYearData;
        var yearData = [];
        var years = acadYear.split("-").map(Number);
        var startyear = years[0];
        var endyear = years[1];
        yearData[(startyear-1).toString()+"-"+(endyear-1).toString()] =
                    "20"+(startyear-1).toString()+"-"+"20"+(endyear-1).toString();
        yearData[(startyear-2).toString()+"-"+(endyear-2).toString()] =
                    "20"+(startyear-2).toString()+"-"+"20"+(endyear-2).toString();
        passYearData = {"name": klpData["report_info"]["name"],
                        "dise": klpData["report_info"]["dise"],
                        "type": klpData["report_info"]["type"]};
        t.getMultipleData(yearData, passYearData, t.getMultipleYear,
                          renderYearComparison, "acadYear");
    };

    /*
        Fill the data structure and pass to DISE api call
    */
    t.getMultipleYear = function(loop)
    {
        var data = loop.iteration();
        var type;
        if( repType == "boundary" ) //for district/block/cluster
            type = data["type"];
        else //for electedrep
            type = repType;
        var boundary = {"id": data["dise"], "type": type};
        klp.dise_api.getBoundaryData(boundary.id, boundary.type,
                                     data["acadYear"]).done(function(diseData) {
            console.log('diseData', diseData);
            loop.addData(diseData);
            loop.next();
        })
        .fail(function(err) {
            klp.utils.alertMessage("Sorry, could not dise data", "for "+data["dise"]);
        });
    };


})();
