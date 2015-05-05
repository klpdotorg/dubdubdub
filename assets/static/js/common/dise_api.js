(function() {
    var base = 'http://disedev.klp.org.in/api/drf/';
    var DEFAULT_ACADEMIC_YEAR = '13-14';
    klp.dise_api = {
        'fetchSchoolInfra': function(diseCode, academicYear) {
            if (typeof(academicYear) === 'undefined') {
                academicYear = DEFAULT_ACADEMIC_YEAR;
            }
            var url = base + academicYear + '/school/' + diseCode + '/infrastructure/';
            var params = {
                'format': 'json'
            };
            var $xhr = $.get(url, params);
            return $xhr;
        }
    };

})();