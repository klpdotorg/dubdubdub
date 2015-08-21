'use strict';
(function() {
    var t = klp.boundaryUtils = {};
    t.getPreSchoolSummary = function(data) {
        var modified = {
            "klp": {
                'schools': data.properties.num_schools,
                'students': data.properties.num_boys + data.properties.num_girls,
                'acadyear': "2014-2015"
            }
        };
        return modified;
    },
    t.getKLPGenderData = function(data) {
        var percents = klp.utils.getBoyGirlPercents(data.properties.num_boys, data.properties.num_girls);
        var modified = {
            "klp": {
                'girl_count': data.properties.num_girls,
                'girl_perc': percents.percent_girls,
                'boy_count':data.properties.num_boys,
                'boy_perc': percents.percent_boys
            }
        };
        return modified;
    },
     t.getPreSchoolCategories = function(data) {  
        var total = data.properties.cat.map(function(category){
            return category.num
        }).reduce(function(a,b){
            return a+b;
        });
        var modified = {}
        data.properties.cat.forEach(function(category, index, arr){
            modified[category.cat] = {
                'type_name': category.cat,
                "klp_perc" :getPercentage(category.num, total),
                "klp_count" : category.num
            }
        })   
        return modified;
    }

    function getPercentage(value, total) {
        return Math.round(value/total*100);
    }

})();