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
			'key' :'sum_has_toilet' 
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
			icon:  ['fa fa-laptop'],
			key: 'sum_has_computer'
		},
		'Mid-day Meal': {
			icon: ['fa fa-spoon'],
      key: 'sum_has_mdm'        
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

	t.getPrimarySchoolCategories = function(klpData, diseData) {
		var schoolCategories = {};
		var upperPrimaryCategories = [2,3,4,5,6,7];
		var diseLowerPrimarySchools = 0;
		var diseUpperPrimarySchools = 0;
		diseData.school_categories.forEach(function(category){
			if (category.id == 1) {
				diseLowerPrimarySchools = category.sum_schools;
			}
			else if (_.contains(upperPrimaryCategories, category.id)){
				diseUpperPrimarySchools += category.sum_schools;
			}
		})
		 
		schoolCategories["upper primary"] = {
			"type_name":"upper primary",
			"klp_perc": getPercentage(klpData.cat[0]['num'],klpData['num_schools']),
			"dise_perc": getPercentage(diseUpperPrimarySchools, diseData['sum_schools']),
			"klp_count": klpData.cat[0]['num'],
			"dise_count": diseUpperPrimarySchools
		},
		schoolCategories["lower primary"] = {
			"type_name":"lower primary",
			"klp_perc": getPercentage(klpData.cat[1]['num'],klpData['num_schools']),
			"dise_perc": getPercentage(diseLowerPrimarySchools, diseData['sum_schools']),
			"klp_count": klpData.cat[1]['num'],
			"dise_count": diseLowerPrimarySchools
		}

		return schoolCategories;
	}

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
	};


	function getPercentage(value, total) {
		return +(value / total * 100).toFixed(2);
	}

})();
