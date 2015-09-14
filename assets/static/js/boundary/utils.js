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
    };
    t.getPrimarySchoolSummary = function(klpData, diseData, academicYear) {
        var modified = {
            'klp': {
                'schools': klpData.properties.num_schools,
                'students': klpData.properties.num_boys + klpData.properties.num_girls,
                'acadyear': academicYear
            },
            'dise': {
                'schools': diseData.properties.sum_schools,
                'students': diseData.properties.sum_boys + diseData.properties.sum_girls,
                'ptr': Math.round((diseData.properties.sum_boys + diseData.properties.sum_girls) / (diseData.properties.sum_male_tch + diseData.properties.sum_female_tch)),
                "acadyear": academicYear
            }
        };

        return modified;
    }

    t.getGenderData = function(klpData, diseData) {
        var klpGenderData;
        var diseGenderData;        
        var klpGenderPercents = klp.utils.getBoyGirlPercents(klpData.num_boys, klpData.num_girls);
        var diseGenderPercents = klp.utils.getBoyGirlPercents(diseData.sum_boys, diseData.sum_girls);
        if (!klpData.num_girls && !klpData.num_boys) {
            klpGenderData = null;
        } else {
            klpGenderData = {
                'girl_count': klpData.num_girls,
                'girl_perc': klpGenderPercents.percent_girls,
                'boy_count': klpData.num_boys,
                'boy_perc': klpGenderPercents.percent_boys,            
            };
        }
        if (diseData) {
            diseGenderData = {
                'girl_count': diseData.sum_girls,
                'girl_perc': diseGenderPercents.percent_girls,
                'boy_count': diseData.sum_boys,
                'boy_perc': diseGenderPercents.percent_boys,
                'align': 'right'                
            }
            return {
                'klp': klpGenderData,
                'dise': diseGenderData
            };
        };

        return {
            klp: klpGenderData
        }
    };
    t.getPreSchoolCategories = function(data) {
        var total = data.properties.num_schools;
        var modified = {}
        data.properties.cat.forEach(function(category, index, arr) {
            modified[category.cat] = {
                'type_name': category.cat,
                'klp_perc': getPercentage(category.num, total),
                'klp_count': category.num
            }
        })
        return modified;
    };
    t.getSchoolsByLanguage = function(data) {
        if (data.properties.moi.length === 0) {
            return null;
        }
        var total = data.properties.num_schools;
        var modified = {}
        data.properties.moi.forEach(function(moi, index, arr) {
            modified[moi.moi] = {
                'typename': moi.moi,
                'count': moi.num,
                'perc': getPercentage(moi.num, total)
            }
        });
        return modified;
    };
    
    t.getSchoolPrograms = function(progData, boundaryID, adminLevel) {
        var groupByPartner = _.groupBy(progData.features, 'partner')
        var modified = _.mapObject(groupByPartner, function(programs) {
            return programs.map(function(program) {
                return {
                    'pname': program.name + ' (' + program.academicyear_name + ')',
                    'url': '/programme/' + program.id + '#?' + adminLevel + '=' + boundaryID
                }
            });
        });
        return modified;
    };


    function getPercentage(value, total) {
        return +(value / total * 100).toFixed(2);
    }

})();