'use strict';
(function() {
    var t = klp.boundaryUtils = {};
    var infraHash = {
      'Playground': {
        icon: ['fa fa-futbol-o'],
        key: 'sum_has_playground'
      },
      'Drinking Water': {
        icon: ['fa  fa-tint'],
        key: 'sum_has_drinking_water'
      },
      'Library': {
        icon: ['fa fa-book'],
        key: 'sum_has_library'
      },
      'Secure Boundary Wall': {
        icon: ['fa fa-circle-o-notch'],
        key: 'sum_has_boundary_wall'
      },
      'Electricity': {
        icon: ['fa fa-plug'],
        key: 'sum_has_electricity'
      }      
    };

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
      if (!klpData.num_girls && !klpData.num_boys) {
        klpGenderData = null;
      } else {
        var klpGenderPercents = klp.utils.getBoyGirlPercents(klpData.num_boys, klpData.num_girls);
        klpGenderData = {
          'girl_count': klpData.num_girls,
          'girl_perc': klpGenderPercents.percent_girls,
          'boy_count': klpData.num_boys,
          'boy_perc': klpGenderPercents.percent_boys,
          'align': 'right'
        };
      }
      if (diseData) {
        var diseGenderPercents = klp.utils.getBoyGirlPercents(diseData.sum_boys, diseData.sum_girls);
        diseGenderData = {
          'girl_count': diseData.sum_girls,
          'girl_perc': diseGenderPercents.percent_girls,
          'boy_count': diseData.sum_boys,
          'boy_perc': diseGenderPercents.percent_boys,
          'align': 'left'
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

    t.getSchoolInfra = function(data) {
        var totalSchools = data.sum_schools;
        var modified = [];
        _.keys(infraHash).forEach(function(facility) {
            var obj = {};
            obj.facility = facility;
            obj.icon = infraHash[facility].icon;
            obj.total = data[infraHash[facility].key];
            obj.percent = getPercentage(obj.total, totalSchools);
            modified.push(obj);
        })
        console.log('modified', modified);
        return modified;
/*
      [{
        'facility': 'All weather pucca building',
        'icon': ['fa fa-university'],
        'percent': 70,
        'total': 10
      }, {
        'facility': 'Playground',
        'icon': ['fa fa-futbol-o'],
        'percent': 50,
        'total': 10
      }, {
        'facility': 'Drinking Water',
        'icon': ['fa  fa-tint'],
        'percent': 30,
        'total': 10
      }, {
        'facility': 'Toilets',
        'icon': ['fa fa-male', 'fa fa-female'],
        'percent': 20,
        'total': 20
      }];
      if (schoolType == "school") {
        facilities = facilities.concat(
          [{
            'facility': 'Library',
            'icon': ['fa fa-book'],
            'percent': 70,
            'total': 10
          }, {
            'facility': 'Secure Boundary Wall',
            'icon': ['fa fa-circle-o-notch'],
            'percent': 80,
            'total': 10
          }, {
            'facility': 'Electricity',
            'icon': ['fa fa-plug'],
            'percent': 10,
            'total': 10
          }, {
            'facility': 'Mid-day Meal',
            'icon': ['fa fa-spoon'],
            'percent': 90,
            'total': 10
          }, {
            'facility': 'Computers',
            'icon': ['fa fa-laptop'],
            'percent': 15,
            'total': 10
          }])*/
      };


      function getPercentage(value, total) {
        return +(value / total * 100).toFixed(2);
      }

    })();
