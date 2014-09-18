(function() {
    klp.init = function() {
        var $profileXHR = klp.api.do("users/" + USER_ID);
        var tplVolunteerActivity = swig.compile($('#tpl-userVolunteerActivity').html());
        $profileXHR.done(function(data) {
            console.log("data", data);
            var loggedInId = parseInt(klp.auth.getId());
            if (loggedInId === data.id) {
                $('#editProfileBtn').show();
            }
            var volunteerCount = data.volunteer_activities.length;
            $('#userVolunteerCount').text(volunteerCount);
            if (volunteerCount > 0) {
                _(data.volunteer_activities).each(function(d) {
                    console.log("d", d);
                    var html = tplVolunteerActivity(d);
                    $('#userVolunteeringActivities').append(html);
                });
            } else {
                var html = $('#tpl-emptyUserVolunteerActivity').html();
                $('#userVolunteeringActivities').append(html);
            }
        });
    };

})();