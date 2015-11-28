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
    'Toilets': {
      'icon': ['fa fa-male', 'fa fa-female'],
      'key': 'sum_has_toilet'
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
    },
    'Computers': {
      icon: ['fa fa-laptop'],
      key: 'sum_has_computer'
    },
    'Mid-day Meal': {
      icon: ['fa fa-spoon'],
      key: 'sum_has_mdm'
    }
  };

  t.triggerDropDown = function() {
    $(".js-dropdown li:has(ul)").click(function(event){
      event.stopPropagation();
      var thisNav = $(this).closest(".js-dropdown").find('ul');
      $(".js-dropdown ul").not(thisNav).slideUp().closest('.js-dropdown').children('li:has(ul)').removeClass('clicked');
      if (this == event.target || this == $(event.target).parent()[0]) {
        $(this).toggleClass('clicked').children('ul').slideToggle(200);
        $(this).find('li:has(ul)').removeClass('clicked').find("ul").slideUp();
        $(this).siblings().removeClass('clicked').find("ul").slideUp();
        return false;
      }
    }).addClass('has_ul');
  }

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
    var total = data.num_schools;
    var modified = {};
    var sortedCategories = _.sortBy(data.cat, "num_schools").reverse();
    sortedCategories.forEach(function(category, index, arr) {
      modified[category.cat] = {
        'type_name': category.cat,
        'klp_perc': getPercentage(category.num_schools, total),
        'klp_count': category.num_schools
      }
    })
    return modified;
  };

  t.getPrimarySchoolCategories = function(klpData, diseData) {
    var schoolCategories = {};
    var upperPrimaryCategories = [2, 3, 4, 5, 6, 7];
    var diseCategories = diseData.school_categories.reduce(function(sumSchools, category) {
      if (category.id == 1) {
        sumSchools.lowerPrimary = category.sum_schools;
      } else if (_.contains(upperPrimaryCategories, category.id)) {
        sumSchools.upperPrimary += category.sum_schools;
      }
      return sumSchools
    }, {
      lowerPrimary: 0,
      upperPrimary: 0
    });

    schoolCategories["upper primary"] = {
      "type_name": "upper primary",
      "klp_perc": getPercentage(klpData.cat[0]['num_schools'], klpData['num_schools']),
      "dise_perc": getPercentage(diseCategories.upperPrimary, diseData['sum_schools']),
      "klp_count": klpData.cat[0]['num_schools'],
      "dise_count": diseCategories.upperPrimary
    },
    schoolCategories["lower primary"] = {
      "type_name": "lower primary",
      "klp_perc": getPercentage(klpData.cat[1]['num_schools'], klpData['num_schools']),
      "dise_perc": getPercentage(diseCategories.lowerPrimary, diseData['sum_schools']),
      "klp_count": klpData.cat[1]['num_schools'],
      "dise_count": diseCategories.lowerPrimary
    }

    return schoolCategories;
  };

  t.getSchoolEnrollment = function(klpData, diseData) {
    var enrollment = {};
    var upperPrimaryCategories = [2, 3, 4, 5, 6, 7];
    var diseEnrollment = diseData.school_categories.reduce(function(accumulator, category) {
      if (category.id == 1) {
        accumulator.lowerPrimary.totalStudents = category.sum_boys + category.sum_girls;
        accumulator.lowerPrimary.totalSchools = category.sum_schools;
      } else if (_.contains(upperPrimaryCategories, category.id)) {
        accumulator.upperPrimary.totalStudents = category.sum_boys + category.sum_girls;
        accumulator.upperPrimary.totalSchools = category.sum_schools;
      }
      return accumulator;
    }, {
      lowerPrimary: {
        totalStudents: 0,
        totalSchools: 0
      },
      upperPrimary: {
        totalStudents: 0,
        totalSchools: 0
      }
    });
    enrollment = {
      "upper primary": {
        "dise_enrol": Math.round(diseEnrollment.upperPrimary.totalStudents / diseEnrollment.upperPrimary.totalSchools),
        "klp_enrol": Math.round(klpData.cat[0].num_boys+klpData.cat[0].num_girls/klpData.cat[0].num_schools)
      },
      "lower primary": {
        "dise_enrol": Math.round(diseEnrollment.lowerPrimary.totalStudents / diseEnrollment.lowerPrimary.totalSchools),
        "klp_enrol": Math.round(klpData.cat[1].num_boys+klpData.cat[1].num_girls/klpData.cat[1].num_schools)
      }
    };
    return enrollment;

  };

  t.getSchoolsByLanguage = function(klp) {
    var totalStudents = klp.num_boys + klp.num_girls;
    var totalSchools = klp.num_schools;
    var languageCategories  = ["kannada", "tamil", "telugu", "urdu"]
    var modified = {"kannada": {moi_count :0,mt_count: 0},"urdu": {moi_count :0,mt_count: 0},"tamil": {moi_count :0,mt_count: 0},"telugu": {moi_count :0,mt_count: 0},"others": {moi_count :0,mt_count: 0}}
    klp.moi.forEach(function(moi){
      if (_.contains(languageCategories, moi.moi)) {
        modified[moi.moi].moi_count = moi.num
      } else {
        modified.others.moi_count += moi.num
      }
    })
    klp.mt.forEach(function(mt){
      if (_.contains(languageCategories, mt.name)) {
        modified[mt.name].mt_count = mt.num_boys + mt.num_girls
      } else {
        modified.others.mt_count += mt.num_boys + mt.num_girls
      }
    })

    modified = _.each(modified, function(lang, category){
      lang.moi_perc = getPercentage(lang.moi_count, totalSchools);
      lang.mt_perc = getPercentage(lang.mt_count, totalStudents);
    })

    var modified = _.keys(modified)
                    .filter(function(lang) {
                        return modified[lang].moi_count !=0 || modified[lang].mt_count !=0
                    })
                    .reduce(function(result, key){
                      result[key] = modified[key];
                      return result;
                    }, {})
    
    return modified;
  };

  t.getMotherTongue = function(data) {
    var modified = {};
    var totalStudents = data.num_boys + data.num_girls
    var sortedLanguages = _.sortBy(data.mt, 'num_students').reverse();
    sortedLanguages.reduce(function(soFar, current, index) {
      if (index < 4) {
        soFar[current.name] = {
          count: current.num_students,
          perc: getPercentage(current.num_students, totalStudents)
        }
        return soFar;
      } else {
        if (!soFar.other) {
          soFar.other = {
            count: 0
          }
        }
        soFar.other.count += current.num_students;
        soFar.other.perc = getPercentage(soFar.other.count, totalStudents);
        return soFar;
      }
    }, modified);
    return modified;
  };

  t.getPreSchoolEnrollment = function(data) {
    var modified = {};
    data.cat.forEach(function(category) {
      modified[category.cat] = {
        klp_enrol: Math.round((category.num_boys + category.num_girls) / category.num_schools)
      }
    })
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
  };


  function getPercentage(value, total) {
    return +(value / total * 100).toFixed(2);
  }

})();
