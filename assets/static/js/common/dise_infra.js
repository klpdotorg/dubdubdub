(function() {

    var yesNoMap = {
        'Not Applicable': null,
        'Yes': true,
        'No': false,
        'Yes but not functional': false,
        'Unknown': null    
    };

    var infraData = {
        'status_of_mdm': {
            'text': 'Has Mid-day Meal facility',
            'section': 'Nutrition and Hygiene',
            'answer_map': {
                'Not applicable': null,
                'Not provided': false,
                'Provided & prepared in school premises': true,
                'Provided but not prepared in school premises': true,
                'Unknown': null
            }
        },
        'drinking_water': {
            'text': 'Has Drinking Water Facilities',
            'section': 'Nutrition and Hygiene',
            'answer_map': yesNoMap
        },
        'medical_checkup': {
            'text': 'Had a medical camp in the previous year',
            'section': 'Nutrition and Hygiene',
            'answer_map': yesNoMap
        },
        'building_status': {
            'text': 'Is in a Rent-free Pucca Building',
            'section': 'Basic Infrastructure',
            'answer_map': {
                'Private': false,
                'Rented': false,
                'Government': true,
                'Government school in a rent free building': true,
                'No Building': false,
                'Dilapidated': false,
                'Under Construction': false,
                'Unknown': null
            }
        },
        'ramps': {
            'text': 'Has a ramp for disabled children',
            'section': 'Basic Infrastructure',
            'answer_map': yesNoMap
        },
        'playground': {
            'text': 'Has a Playground',
            'section': 'Basic Infrastructure',
            'answer_map': yesNoMap
        },

        'boundary_wall': {
            'text': 'Has Secure Boundary walls',
            'section': 'Basic Infrastructure',
            'answer_map': {
                'Not Applicable': null,
                'Pucca': true,
                'Pucca but broken': false,
                'Barbed wire fencing': false,
                'Hedges': false,
                'No boundary wall': false,
                'Others': null,
                'Partial': false,
                'Under Construction': false,
                'Unknown': null 
            }
        },

        'separate_room_for_headmaster': {
            'text': 'Has a Separate Room for the Head Master',
            'section': 'Basic Infrastructure',
            'answer_map': yesNoMap
        },

        'classrooms_require_major_repair': {
            'text': 'Has Classrooms That Need No Repairs',
            'section': 'Basic Infrastructure',
            'answer_map': function(data) {
                var major = data.classrooms_require_major_repair;
                var minor = data.classrooms_require_minor_repair;
                if (major === 0 && minor === 0) {
                    return true;
                } else if (major > 0 || minor > 0) {
                    return false;
                } else {
                    return null;
                }
            }
        },

        'electricity': {
            'text': 'Has Electricity Supply',
            'section': 'Basic Infrastructure',
            'answer_map': yesNoMap
        },

        'blackboard': {
            'text': 'Has Blackboards for all Classrooms',
            'section': 'Learning Environment',
            'answer_map': function(data) {
                var classrooms = data.tot_clrooms;
                var blackboards = data.blackboard;
                return blackboards >= classrooms;            
            }
        },

        'library_yn': {
            'text': 'Has a Library with Books',
            'section': 'Learning Environment',
            'answer_map': function(data) {
                var hasLibrary = yesNoMap[data.library_yn];
                if (hasLibrary === null) {
                    return null;
                }
                if (hasLibrary && data.books_in_library > 0) {
                    return true;
                }
                return false;
            }
        },

        'computer_aided_learnin_lab': {
            'text': 'Has a Computer Lab',
            'section': 'Learning Environment',
            'answer_map': yesNoMap
        },

        'toilet_common': {
            'text': 'Has Common Toilets',
            'section': 'Toilet Facilities',
            'answer_map': function(data) {
                if (data.toilet_common === null) {
                    return null;
                }
                return data.toilet_common > 0;
            }
        },

        'toilet_girls': {
            'text': 'Has Separate Toilets for Girls',
            'section': 'Toilet Facilities',
            'answer_map': function(data) {
                if (data.toilet_girls === null) {
                    return null;
                }
                return data.toilet_girls > 0;
            }
        }
    };

    var getFacilitiesData = function(diseData) {
        if (_.isEmpty(diseData)) {
            return {};
        }
        var facilities = {
            'Nutrition and Hygiene': {},
            'Basic Infrastructure': {},
            'Learning Environment': {},
            'Toilet Facilities': {}
        };
        var keys = _.keys(infraData);
        _.each(keys, function(key) {
            var obj = infraData[key];
            var text = obj.text;
            var section = obj.section;
            if (_.isFunction(obj.answer_map)) {
                var value = obj.answer_map(diseData);
            } else {
                var diseValue = diseData[key];
                var value = obj.answer_map[diseValue];
            }
            facilities[obj.section][text] = value;

        });
        return facilities;
    };

    var getBasicFacilities = function(diseData) {
        return {
            'playground': infraData.playground.answer_map[diseData.playground],
            'library': infraData.library_yn.answer_map(diseData),
            'computer_lab': infraData.computer_aided_learnin_lab.answer_map[diseData.computer_aided_learnin_lab] 
        };
    };

    klp.dise_infra = {
        'getFacilitiesData': getFacilitiesData,
        'getBasicFacilities': getBasicFacilities
    };

})();