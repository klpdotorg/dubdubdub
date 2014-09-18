(function() {
    klp.init = function() {
        var $orgXHR = klp.api.do("organizations/" + ORGANIZATION_ID);
        var tplVolunteer = swig.compile($('#tpl-volunteerActivity').html());
        $orgXHR.done(function(data) {
            console.log("data", data);
            if (hasEditPermissions(data.users)) {
                $('#editOrganizationBtn').show();
            }
            var volunteerCount = data.volunteer_activities.length;
            $('#volunteerCount').text(volunteerCount);
            _(data.volunteer_activities).each(function(v) {
                var html = tplVolunteer(v);
                $('#volunteerActivitiesList').append(html);
            });
        });
    };

    function hasEditPermissions(users) {
        var loggedInId = klp.auth.getId();
        if (!loggedInId) {
            return false;
        }
        _(users).each(function(u) {
            if (u.user_details.id === parseInt(loggedInId)) {
                return true;
            }
        });
        return false;
    }
})();