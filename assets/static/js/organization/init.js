(function() {
    klp.init = function() {
        klp.volunteer_here.init();
        klp.basic_tabs.init();
        var $orgXHR = klp.api.do("organizations/" + ORGANIZATION_ID);
        var tplVolunteer = swig.compile($('#tpl-volunteerActivity').html());
        var tplDonation = swig.compile($('#tpl-donationRequirement').html());
        $orgXHR.done(function(data) {
            // console.log("data", data);
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
            var donationsURL = "donation_requirements/";
            var params = {
                'organization': ORGANIZATION_ID
            };
            var $donationsXHR = klp.api.authDo(donationsURL, params);

            $donationsXHR.done(function(data) {
                var requirements = data.results;
                $('#donationCount').text(requirements.length);
                _(requirements).each(function(r) {
                    var html = tplDonation(r);
                    $('#donationRequirementsList').append(html);
                });
            });

            klp.auth.events.on("login", function() {
                if (hasEditPermissions(data.users)) {
                    $('#editOrganizationBtn').show();
                }
                klp.volunteer_here.checkSelf(data.volunteer_activities);
            });
            klp.auth.events.on("logout", function() {
                $('#editOrganizationBtn').hide();
            });
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
