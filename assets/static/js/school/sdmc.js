'use strict';
var boundaries = {"districts" : {}, "pre_districts": {},
                  "blocks" : {}, "projects": {},
                  "clusters": {}, "circles": {} };
(function() {

    klp.init = function() {
        klp.router = new KLPRouter();
        klp.router.init();
        klp.router.start();
        initEduSearch("preschool");
        var dataURL = "schools/list/?meetingreport=yes;"//&per_page=20";
        loadData(dataURL);      
    }

    $(document).on('click',".next",function () {        
        var url = $(this).data('id');
        var rest_url = url.split('api/v1/')[1];
        console.log(rest_url);
        loadData(rest_url);
    });

    $(document).on('click',".prev",function () {        
        var url = $(this).data('id');
        var rest_url = url.split('api/v1/')[1];
        console.log(rest_url);
        loadData(rest_url);
    });

    function loadData(dataURL) {
        var params = {};
        var $dataXHR = klp.api.do(dataURL, params);
        $dataXHR.done(function(data) {
            var $countXHR = klp.api.do("schools/meeting-reports/", params);
            $countXHR.done(function(mr) {
                data['report_count'] = mr.count;
                 renderSummary(data);
            });
           
        });
    }

    function transformData(schools) {
        var schoolMap = {};
        for (var i in schools) {
            var school = schools[i]
            schoolMap[school.id.toString()] = {
                "pdfs":{}, 
                "name": school.name,
                "id": school.id, //data.name,
                "admin3": school.admin3,
                "admin2": school.admin2,
                "admin1": school.admin1,
                "school_type" : school.type.name
            };
            for (var each in school.meeting_reports) {
                var report = school.meeting_reports[each];
                schoolMap[school.id.toString()]["pdfs"][report.pdf] = {
                    "path":report.pdf, 
                    "lang":report.language, 
                    "is_archived": (report.generated_at == null)? true : false,
                    "year": (report.generated_at != null)? moment(report.generated_at, "YYYY-MM-DD").format("YYYY") : null,
                    "month": (report.generated_at != null)? moment(report.generated_at, "YYYY-MM-DD").format("MMMM") : null
                };
            }
        }
        console.log(schoolMap);
        return schoolMap;
    }

    function renderSummary(data) {
        var transformed = transformData(data['features'])
        //console.log(transformed);
        var tplButtons = swig.compile($('#tpl-buttons').html());
        var buttonHTML =  tplButtons({'next':data.next,'previous': data.previous });
        $('#buttons').html(buttonHTML)
        var tplCountSummary = swig.compile($('#tpl-countSummary').html());
        var countHTML =  tplCountSummary({'school_count':data.count,'report_count':data.report_count});
        $('#count_summary').html(countHTML)
        var tplResponseTable = swig.compile($('#tpl-responseTable').html());
        var tableHTML = tplResponseTable({'data':transformed});
        $('#response_summary').html(tableHTML);
    }   

    function makeLookupArrays(){
        var districtXHR = klp.api.do('boundary/admin1s?meetingreport=yes&per_page=0',{});
        districtXHR.done(function (data) {
            for(var i in data["features"]) {
                var boundary = data["features"][i];
                if (boundary.school_type == "preschool")
                    boundaries ["pre_districts"][boundary.id.toString()] = boundary;
                else
                    boundaries ["districts"][boundary.id.toString()] = boundary;
            }
            var blockXHR = klp.api.do('boundary/admin2s?meetingreport=yes&per_page=0',{});
            blockXHR.done(function (data) {
                for(var i in data["features"]) {
                    var boundary = data["features"][i];
                    if (boundary.school_type == "preschool")
                        boundaries ["projects"][boundary.id.toString()] = boundary;
                    else
                        boundaries ["blocks"][boundary.id.toString()] = boundary;
                }
                var clusterXHR = klp.api.do('boundary/admin3s?meetingreport=yes&per_page=0',{});
                clusterXHR.done(function (data) {
                    for(var i in data["features"]) {
                        var boundary = data["features"][i];
                        if (boundary.school_type == "preschool")
                            boundaries ["circles"][boundary.id.toString()] = boundary;
                        else
                            boundaries ["clusters"][boundary.id.toString()] = boundary;
                    }
                });
            });
        });
        //console.log(boundaries);
        
    }



    function format(item) {
        if (item.properties != undefined)
            return _.str.titleize(item.properties.name);
        else
            return _.str.titleize(item.name);
    }

    function populateSelect(container,data) {
        // data.forEach(function(d) {
        //     if(d.properties !=undefined)
        //         d.id = d.properties.id;
        // });
        container.select2({
            sortResults: function(results) {
                return _.sortBy(results, function(result) {
                    return result.name;
                });
            },
            data: {
                results: data,
                text: function(item) {
                    return item.name;
                }
            },
            formatSelection: format,
            formatResult: format,
        });
    }

    function getSubset(type,parent) {
        var subset = {}
        for(var i in boundaries[type]) {
            if(boundaries[type][i].parent.id == parent) {
                subset[boundaries[type][i].id] = boundaries[type][i]
            }
        }
        return subset;
    }

    function initEduSearch(school_type) {
        makeLookupArrays();
        console.log(boundaries);
        var $select_type = $("#select-type");
        var $select_district = $("#select-district");
        var $select_block = $("#select-block");
        var $select_cluster = $("#select-cluster");
        $select_type.select2("val","");
        $select_district.select2("val","");
        $select_block.select2("val","");
        $select_cluster.select2("val","");

        populateSelect($select_type, {
            "primaryschool":{"id":1,"name":"Primary School"},
            "preschool":{"id":2,"name":"Preschool"},
        })

        $select_type.on("change", function(selected) {
            var selection ="districts"
            if(selected.val == 2) {
                selection = "pre_districts"
            }
            populateSelect($select_district, boundaries[selection]);
        });
        
        $select_district.on("change", function(selected) {
            populateSelect($select_block, getSubset(selected.added.school_type=="preschool"?"projects":"blocks",selected.val));
            var dataURL = "schools/list/?admin1=" + selected.val + "&meetingreport=yes&per_page=20";
            loadData(dataURL);
        });

        $select_block.on("change", function(selected) {
            populateSelect($select_cluster, getSubset(selected.added.school_type=="preschool"?"circles":"clusters",selected.val));
            var dataURL = "schools/list/?admin2=" + selected.val + "&meetingreport=yes&per_page=20";
            loadData(dataURL);
        });

        $select_cluster.on("change", function(selected) {
            var dataURL = "schools/list/?admin3=" + selected.val + "&meetingreport=yes&per_page=20";
            loadData(dataURL);
        });
    }

})();

// function transformData(meetingreports) {
//     var schoolMap = {};
//     for (var i in meetingreports) {
//         var report = meetingreports[i]
//         if (_.keys(schoolMap).indexOf(report.school.id.toString())==-1) {
//             schoolMap[report.school.id.toString()] = {
//                             "pdfs":{}, 
//                             "name": report.school.name,
//                             "id": report.school.id //data.name,
//                             // "admin3": data.admin3.name,
//                             // "admin2": data.admin2.name,
//                             // "admin1": data.admin1.name
//                         };
//         }
//         schoolMap[report.school.id.toString()]["pdfs"][report.id.toString()] = {
//             "path":report.pdf, 
//             "lang":report.language, 
//             "is_archived": (report.generated_at == null)? true : false,
//             "year": (report.generated_at != null)? moment(report.generated_at, "YYYY-MM-DD").format("YYYY") : null,
//             "month": (report.generated_at != null)? moment(report.generated_at, "YYYY-MM-DD").format("MMMM") : null
//         };
//     }
//     return schoolMap;
// }


// function searchTable() {
//     // Declare variables 
//     var id, name, year, id_filter, name_filter, yr_filter;
//     // id = document.getElementById("search-id");
//     // if(id.value != null) {
//     //     id_filter = id.value.toUpperCase();
//     //     searchLoop(0,id_filter);    
//     // }
//     name = document.getElementById("search-name");
//     if(name.value != null && name.value != "") {
//         name_filter = name.value.toUpperCase();
//         searchLoop(1,name_filter);    
//     }

//     // year = document.getElementById("search-year");
//     // if(year.value != null) {
//     //    yr_filter = year.value.toUpperCase();
//     //     searchLoop(2,yr_filter);    
//     // } 
// }

//  // Loop through all table rows, and hide those who don't match the search query
   
// function searchLoop(col_num, filter) {
//     var table, tr, td, i;
//     table = document.getElementById("sdmc-table");
//     tr = table.getElementsByTagName("tr");
//     for (i = 0; i < tr.length; i++) {
//         td = tr[i].getElementsByTagName("td")[col_num];
//         if (td) {
//             if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
//                 tr[i].style.display = "";
//                 // console.log("display");
//             } else {
//                 tr[i].style.display = "none";
//                 // console.log("don't display");
//             }
//         } 
//     }
// }