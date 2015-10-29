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
        }
    };

})();
