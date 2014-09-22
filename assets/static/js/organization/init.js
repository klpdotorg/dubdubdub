(function() {
    klp.init = function() {
        klp.volunteer_here.init();
        var $orgXHR = klp.api.do("organizations/" + ORGANIZATION_ID);
        var tplVolunteer = swig.compile($('#tpl-volunteerActivity').html());
        $orgXHR.done(function(data) {
            console.log("data", data);
            if (hasEditPermissions(data.users)) {
                $('#editOrganizationBtn').show();
            }
            var volunteerCount = data.volunteer_activities.length;
            $('#volunteerCount').text(volunteerCount);
            if (volunteerCount > 0) {
                _(data.volunteer_activities).each(function(v) {
                    var html = tplVolunteer(v);
                    $('#volunteerActivitiesList').append(html);
                });
                klp.volunteer_here.checkSelf(data.volunteer_activities);
            } else {
                var html = $('#tpl-emptyVolunteerActivities').html();
                $('#volunteerActivitiesList').append(html);
            }
        });
    };

    function hasEditPermissions(users) {
        var loggedInId = klp.auth.getId();
        if (!loggedInId) {
            return false;
        }
        var isAdmin = false;
        _(users).each(function(u) {
            if (u.user_details.id === parseInt(loggedInId)) {
                isAdmin = true;
            }
        });
        return isAdmin;
    }
})();