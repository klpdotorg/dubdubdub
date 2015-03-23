(function() {
    klp.init = function() {
        klp.basic_tabs.init();
        var $infoXHR = klp.api.authDo("volunteer_activities/" + VOLUNTEER_ACTIVITY_ID);
        var tplActivityDetails = swig.compile($('#tpl-activityDetails').html());
        var tplVolunteerDetails = swig.compile($('#tpl-volunteerDetails').html());
        $infoXHR.done(function(data) {
            var detailsHTML = tplActivityDetails(data);
            $('#activityDetails').html(detailsHTML);
            // console.log("data", data);

            var userCount = data.users.length;

            if (userCount > 0) {
                _(data.users).each(function(user) {
                    var userHTML = tplVolunteerDetails(user);
                    $('#jsVolunteerTable').append(userHTML);
                });
            }

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

        $(document).on("click", ".js-volunteerVerify", function(e) {
            e.preventDefault();
            var $this = $(this);
            var $parent = $this.parents('.js-volunteerTR');
            var currentStatus = $this.attr("data-status");
            var newStatus = currentStatus === "1" ? 0 : 1;
            var userID = $parent.attr("data-id");
            //console.log("user id", userID);
            var url = "volunteer_activities/" + VOLUNTEER_ACTIVITY_ID + "/users/" + userID;
            var data = {
                'status': newStatus
            };
            var $statusXHR = klp.api.authDo(url, data, "PATCH");
            $statusXHR.done(function(response) {
                var html = tplVolunteerDetails(response);
                $parent.replaceWith(html);
                klp.utils.alertMessage("Saved change", "success");
            });
            $statusXHR.fail(function(err) {
                klp.utils.alertMessage("An error occurred", "error");
                //console.log("fail", err);
            });
        });

    };

})();
