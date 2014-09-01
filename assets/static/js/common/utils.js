(function() {
    klp.utils = {
        compile_templates: function() {
            var $raw_tpls = $(".tpl-raw");
            var _tpl = {};
            if(!$raw_tpls.length){
                return _tpl;
            }
            $raw_tpls.each(function( index ) {
                var name = $(this).data("tpl");
                var content = $(this).html();

                _tpl[name] = swig.compile(content);
            });
            return _tpl;
        },
        
        mapIcon: function (type) {

            // FIXME: May be fix this in the icon name.
            // This is Sanjay's fault.
            type = type.replace(' ', '').toLowerCase();
            if (type === 'primaryschool') {
                type = 'school';
            }
            if (type === 'primaryschool_district') {
                type = 'school_district';
            }
            if (type === 'primaryschool_block') {
                type = 'school_block';
            }
            if (type === 'primaryschool_cluster') {
                type = 'school_cluster';
            }
            return L.icon({
                iconUrl: '/static/images/map/icon_'+type+'.png',
                iconSize: [20, 30],
                iconAnchor: [10, 26],
                popupAnchor: [0, -25]
            });
        },

        alertMessage: function(message, status) {
            // Status - error, success, warning.
            alert(message);
        },

        getRelativeHeight: function (width, height, min_height, container_width){
            var ht = (height/width)*container_width;
            ht = parseInt(ht,10);
            if(ht<min_height){
                return min_height;
            }
            // If number is odd, convert to even
            if(Math.abs(ht) % 2 == 1){
                ht++;
            }
            return ht;
        },

        addSchoolContext: function(data) {
           var total_students = data.num_boys + data.num_girls;
            _(['num_boys', 'num_girls']).each(function(n) {
                if (data[n] === null) {
                    data[n] = 0;
                }
            });
            data.has_num_students = data.num_boys && data.num_girls;
            data.total_students = total_students;
            data.percent_boys = Math.round((data.num_boys / total_students) * 100);
            data.percent_girls = Math.round((data.num_girls / total_students) * 100);
            if (data.hasOwnProperty('mt_profile')) {
                var total_mts = _(_(data.mt_profile).values()).reduce(function(a, b) {
                    return a + b;
                });
                data.mt_profile_percents = {};
                _(_(data.mt_profile).keys()).each(function(mt) {
                    data.mt_profile_percents[mt] = (data.mt_profile[mt] / total_mts) * 100;
                });
            }

            return data;
        }

    };

})();