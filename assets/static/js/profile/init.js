(function() {
    klp.init = function() {
        var $profileXHR = klp.api.do("users/" + USER_ID);
        var tplVolunteerActivity = swig.compile($('#tpl-userVolunteerActivity').html());
        var tplOrganization = swig.compile($('#tpl-Organization').html());
        $profileXHR.done(function(data) {
            // console.log("data", data);
            var loggedInId = parseInt(klp.auth.getId());
            if (loggedInId === data.id) {
                $('#editProfileBtn').show();
            }
            var volunteerCount = data.volunteer_activities.length;
            $('#userVolunteerCount').text(volunteerCount);
            if (volunteerCount > 0) {
                _(data.volunteer_activities).each(function(d) {
                    // console.log("d", d);
                    var html = tplVolunteerActivity(d);
                    $('#jsUserVolunteeringActivities').append(html);
                });
            } else {
                var html = $('#tpl-emptyUserVolunteerActivity').html();
                $('#jsUserVolunteeringActivities').append(html);
            }

            var orgs = data.organizations;
            if (orgs.length > 0) {
                _(data.organizations).each(function(o) {
                    var html = tplOrganization(o.organization_details);
                    $('#userOrganizations').append(html);
                });
            } else {
                var html = $('#tpl-emptyOrganizations').html();
                $('#userOrganizations').append(html);
            }

            klp.auth.events.on("login", function() {
                var loggedInId = parseInt(klp.auth.getId());
                if (loggedInId === data.id) {
                    $('#editProfileBtn').show();
                }
            });

            klp.auth.events.on("logout", function() {
                $('#editProfileBtn').hide();
            });
        });
    };

})();
