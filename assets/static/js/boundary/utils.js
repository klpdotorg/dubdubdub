'use strict';
(function() {
    var t = klp.boundaryUtils = {};
    t.getPreSchoolSummary = function(data) {
        var modified = {
            "klp": {
                'schools': data.properties.num_schools,
                'students': data.properties.num_boys + data.properties.num_girls,
                "acadyear": "2014-2015"
            }
        };
        return modified;
    }

})();