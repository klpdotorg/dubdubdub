(function() {
    var base = 'https://dise.klp.org.in/api/';
    var DEFAULT_ACADEMIC_YEAR = '13-14';
    klp.dise_api = {
        'fetchSchoolInfra': function(diseCode, academicYear) {
            if (typeof(academicYear) === 'undefined') {
                academicYear = DEFAULT_ACADEMIC_YEAR;
            }
            if (!diseCode) {
                var $deferred = $.Deferred();
                //FIXME: Return a proper error, dont resolve with empty object
                setTimeout(function() {
                    $deferred.resolve({});
                }, 0);
                return $deferred;
            }
            var url = base + academicYear + '/school/' + diseCode + '/infrastructure/';
            var params = {
                'format': 'json'
            };
            var $xhr = $.get(url, params);
            return $xhr;
        },

        'queryBoundaryName': function(boundaryName,boundaryType, academicYear) {
            var url = base + academicYear + '/search/';
            var params = {
                'query': boundaryName,
                'type': boundaryType
            };
            var $xhr = $.get(url, params);
            return $xhr;
        },

        'getBoundaryData': function(boundaryID, boundaryType, academicYear) {
            var url = base + academicYear + '/' + boundaryType + '/' + boundaryID + '/';
            var $xhr = $.get(url);
            return $xhr;
        },

        'getMultipleBoundaryData': function(parentBoundaryName, parentBoundaryType, boundaryType, academicYear){
            var url;
            if (parentBoundaryName == null)
                url = base + academicYear + '/' + boundaryType;
            else
                url = base + academicYear + '/' + parentBoundaryType + '/' +parentBoundaryName + '/' +boundaryType+'s/?basic=no';
            var $xhr = $.get(url);
            return $xhr;
        },

        'getElectedRepData': function(electedrepID, electedrepType, academicYear) {
            var url = base + academicYear + '/' + electedrepType + '/' + electedrepID + '/';
            var $xhr = $.get(url);
            return $xhr;
        }


    };

})();
