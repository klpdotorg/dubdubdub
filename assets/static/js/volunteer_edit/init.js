(function() {
    klp.init = function() {
        var $infoXHR = klp.api.authDo("volunteer_activities/" + VOLUNTEER_ACTIVITY_ID);
        var tplActivityDetails = swig.compile($('#tpl-activityDetails').html());
        $infoXHR.done(function(data) {
            var detailsHTML = tplActivityDetails(data);
            $('#activityDetails').html(detailsHTML);
            console.log("data", data);
            $('#activityType').val(data.type);
            $('#school').val(data.school);
            $('#organization').val(data.organization);
            $('#date').val(data.date);
            $('#text').val(data.text);
            klp.utils.schoolSelect2($('#school'));
            
            var formID = 'activityForm';

            $('#' + formID).submit(function(e) { 
                if (e) {
                    e.preventDefault();
                }
                var fields = {
                    'type': $('#activityType'),
                    'organization': $('#organization'),
                    'school': $('#school'),
                    'date': $('#date'),
                    'text': $('#text')
                };

                var data = klp.utils.getFormData(fields);

                var url = 'volunteer_activities/' + VOLUNTEER_ACTIVITY_ID;

                var $editXHR = klp.api.authDo(url, data, "PUT");

                $editXHR.done(function(response) {
                    klp.utils.alertMessage("Changes saved", "success");
                    var html = tplActivityDetails(response);
                    $('#activityDetails').html(html);
                });

                $editXHR.fail(function(err) {
                    var errors = JSON.parse(err.responseText);
                    klp.utils.invalidateErrors(fields, errors);
                });

            });
        });

    };

})();