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
    }   

})();