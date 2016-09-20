'use strict';
(function() {
  var t = klp.boundaryUtils = {};
  var preschoolInfraHash = {
    'ang-drinking-water': {
      type: 'Drinking Water',
      icon: ['fa  fa-tint']      
    },
    'ang-toilet-for-use': {
      type:'Toilets', 
      icon: ['fa fa-male', 'fa fa-female']
    },
    'ang-bvs-present': {
      type: 'Functional Bal Vikas Samithis',
      icon: ['fa fa-users']
    },
    'ang-separate-handwash': {
      type: 'Separate Hand-Wash',
      icon: ['fa fa-hand-o-up']
    }, 
    'ang-activities-use-tlm': {
      type: 'Uses Learning Material', 
      icon: ['fa fa-cubes']
    },
    'ang-in-spacious-room': {
      type: 'Spacious Room', 
      icon: ['fa fa-arrows-alt']
    }

  }
  
  var infraHash = {
    'Playground': {
      icon: ['fa fa-futbol-o'],
      key: 'sum_has_playground'
    },
    'Drinking Water': {
      icon: ['fa  fa-tint'],
      key: 'sum_has_drinking_water',       
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

  t.getPreSchoolSummary = function(data, academicYear) {
    var modified = {
      "klp": {
        'schools': data.properties.num_schools,
        'students': data.properties.num_boys + data.properties.num_girls,
        'acadyear': academicYear
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
    var klpSchools = klpData.num_schools
    var diseSchools = diseData.sum_schools
    var schoolCategories = {'upper primary': {}, 'lower primary': {}}
    var upperPrimaryCategories = [2, 3, 4, 5, 6, 7];

    var diseCount = diseData.school_categories.reduce(function(sumSchools, category) {
      if (category.id == 1) {
        sumSchools.lowerPrimary = category.sum_schools.total;
      } else if (_.contains(upperPrimaryCategories, category.id)) {
        sumSchools.upperPrimary += category.sum_schools.total;
      }
      return sumSchools
    }, {
      lowerPrimary: 0,
      upperPrimary: 0
    });

    function klpCategories(klp) {
      var modified = {'lower primary':{}, 'upper primary': {}}
      if (klpData.num_schools) {
        modified = klp.reduce(function(result, current){          
            result[current.cat.toLowerCase()] = {
              klp_count: current.num_schools,
              klp_perc: getPercentage(current.num_schools, klpSchools)
            }
            return result
          }, {})  
      }
      return modified      
    }

    function diseCategories(dise) {
      var modified = {
        'lower primary': {
          dise_count: dise.lowerPrimary,
          dise_perc: getPercentage(dise.lowerPrimary, diseSchools)
        }, 
        'upper primary': {
          dise_count: dise.upperPrimary, 
          dise_perc: getPercentage(dise.upperPrimary, diseSchools)
        }
      }

      return modified
    }
    
   schoolCategories =  _.mapObject(schoolCategories, function(val, category){
      var data = Object.assign({}, klpCategories(klpData.cat)[category], diseCategories(diseCount)[category])      
      return data
    })   

    return schoolCategories;
  };

  t.getSchoolEnrollment = function(klpData, diseData) {
    var enrollment = {};
    var upperPrimaryCategories = [2, 3, 4, 5, 6, 7];
    var diseEnrollment = diseData.school_categories.reduce(function(results, category) {
      if (category.id == 1) {
        results.lowerPrimary.totalStudents = category.sum_boys + category.sum_girls;
        results.lowerPrimary.totalSchools = category.sum_schools.total;
      } else if (_.contains(upperPrimaryCategories, category.id)) {
        results.upperPrimary.totalStudents = category.sum_boys + category.sum_girls;
        results.upperPrimary.totalSchools = category.sum_schools.total;
      }
      return results;
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
    function klpEnrollment(klp) {
      var modified = {'lower primary':{}, 'upper primary': {}}
      if (klp.num_schools) {
        modified = klp.cat.reduce(function(result, current){          
            result[current.cat.toLowerCase()] = {
              klp_enrol: Math.round(current.num_boys + current.num_girls / current.num_schools)
            }
            return result
          }, modified)  
      }
      return modified      
    }

    enrollment = {
      "upper primary": {
        "dise_enrol": Math.round(diseEnrollment.upperPrimary.totalStudents / diseEnrollment.upperPrimary.totalSchools),
        "klp_enrol": klpEnrollment(klpData)['upper primary'].klp_enrol
      },
      "lower primary": {
        "dise_enrol": Math.round(diseEnrollment.lowerPrimary.totalStudents / diseEnrollment.lowerPrimary.totalSchools),
        "klp_enrol": klpEnrollment(klpData)['lower primary'].klp_enrol
      }
    };
    return enrollment;

  };

  t.getSchoolsByLanguage = function(klp) {
    var totalStudents = klp.num_boys + klp.num_girls;
    var totalSchools = klp.num_schools;
    var languageCategories = ["kannada", "tamil", "telugu", "urdu"]
    var modified = {
      "kannada": {
        moi_count: 0,
        mt_count: 0
      },
      "urdu": {
        moi_count: 0,
        mt_count: 0
      },
      "tamil": {
        moi_count: 0,
        mt_count: 0
      },
      "telugu": {
        moi_count: 0,
        mt_count: 0
      },
      "others": {
        moi_count: 0,
        mt_count: 0
      }
    }
    klp.moi.forEach(function(moi) {
      if (_.contains(languageCategories, moi.moi)) {
        modified[moi.moi].moi_count = moi.num
      } else {
        modified.others.moi_count += moi.num
      }
    })
    klp.mt.forEach(function(mt) {
      if (_.contains(languageCategories, mt.name)) {
        modified[mt.name].mt_count = mt.num_boys + mt.num_girls
      } else {
        modified.others.mt_count += mt.num_boys + mt.num_girls
      }
    })

    modified = _.each(modified, function(lang, category) {
      lang.moi_perc = getPercentage(lang.moi_count, totalSchools);
      lang.mt_perc = getPercentage(lang.mt_count, totalStudents);
    })

    var modified = _.keys(modified)
    .filter(function(lang) {
      return modified[lang].moi_count != 0 || modified[lang].mt_count != 0
    })
    .reduce(function(result, key) {
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
    _.without(_.keys(infraHash), 'Functional Bal Vikas Samithis').forEach(function(facility) {
      var obj = {};
      obj.facility = facility;
      obj.icon = infraHash[facility].icon;
      obj.total = data[infraHash[facility].key];
      obj.percent = getPercentage(obj.total, totalSchools);
      modified.push(obj);
    })
    return modified;
  };

  t.getGrants = function(data) {
    var devGrantReceived = data.sum_school_dev_grant_recd;
    var devGrantExpenditure = data.sum_school_dev_grant_expnd;
    var tlmGrantReceived = data.sum_tlm_grant_recd;
    var tlmGrantExpenditure = data.sum_tlm_grant_expnd;
    var totalReceived = devGrantReceived + tlmGrantReceived;
    var totalExpenditure = devGrantExpenditure + tlmGrantExpenditure;
    var modified = {};
    var data = {
      "received": {
        "sg_perc": Math.round(getPercentage(devGrantReceived, totalReceived)),
        "sg_amt": devGrantReceived,
        "tlm_perc": Math.round(getPercentage(tlmGrantReceived, totalReceived)),
        "tlm_amt": tlmGrantReceived
      },
      "expenditure": {
        "sg_perc": Math.round(getPercentage(devGrantExpenditure, totalExpenditure)),
        "sg_amt": devGrantExpenditure,
        "tlm_perc": Math.round(getPercentage(tlmGrantExpenditure, totalExpenditure)),
        "tlm_amt": tlmGrantExpenditure
      },
    };
    return data;
  }

  t.getPreSchoolInfra = function(data) {    
    var sumSchools = data.num_schools    
    var anganwadiInfra = data.infrastructure.reduce(function(results, infra){
      var sumResponses = infra.answers.options.Yes + infra.answers.options.No
      var key = infra.question.key
      var obj = {}
      if (preschoolInfraHash[key]) {
        obj.facility = preschoolInfraHash[key].type
        obj.icon = preschoolInfraHash[key].icon
        obj.total = infra.answers.options.Yes
        obj.percent = getPercentage(obj.total, sumResponses) 
        obj.sumschools = sumSchools
        obj.schooltype = 'Preschool'
        results.push(obj)
      }     
      return results
    }, [])    
    return anganwadiInfra
  }

  function getPercentage(value, total) {
    if (total) {
      return (value / total * 100).toFixed(2);
    }   
  }

})();
