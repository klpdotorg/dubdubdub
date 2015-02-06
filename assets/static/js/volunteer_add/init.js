(function() {
    klp.init = function() {
        klp.basic_tabs.init();
        $('#organization').val(ORGANIZATION_ID);
        var formID = 'activityForm';
        var $school = $('#school');
        klp.utils.schoolSelect2($school);
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
            //console.log("data", data);
            var url = "volunteer_activities";

            var $xhr = klp.api.authDo(url, data, 'POST');

            $xhr.done(function(response) {
                // console.log("saved", response);
                alert("saved");
                location.reload();
                //location.href = "/organisation/" + ORGANIZATION_ID;
            });

            $xhr.fail(function(err) {
                var errors = JSON.parse(err.responseText);
                klp.utils.invalidateErrors(errors);
                // console.log("error", err);
            });

        });


    };

})();
