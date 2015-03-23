(function() {
    klp.init = function() {
        klp.basic_tabs.init();
        var apiURL = "organizations/" + ORGANIZATION_ID;
        var $orgXHR = klp.api.authDo(apiURL);
        $orgXHR.done(function(data) {
            var fields = {
                'name': $('#orgName'),
                'url': $('#orgURL'),
                'email': $('#orgEmail'),
                'contact_name': $('#orgContactName'),
                'about': $('#orgAbout'),
                'twitter_handle': $('#orgTwitter'),
                'fb_url': $('#orgFacebook'),
                'blog_url': $('#orgBlog'),
                'photos_url': $('#orgPhotos'),
                'youtube_url': $('#orgYoutube'),
                'logo': $('#logo')
            };
            klp.utils.populateForm(fields, data);
            $('#logo').imagePreview();
            var formID = 'orgForm';
            $('#' + formID).submit(function(e) {
                if (e) {
                    e.preventDefault();
                }
                klp.utils.clearValidationErrors(formID);

                if (klp.utils.validateRequired(formID)) {
                    var data = klp.utils.getFormData(fields);
                    var orgXHR = klp.api.authDo(apiURL, data, "PUT");
                    orgXHR.done(function(response) {
                        $('#displayOrgName').text(response.name);
                        klp.utils.alertMessage("Changes saved", "success")
                    });

                    orgXHR.fail(function(err) {
                        var errors = JSON.parse(err.responseText);
                        console.log("errors", errors);
                        klp.utils.alertMessage("Please correct errors and re-submit", "error");
                        klp.utils.invalidateErrors(fields, errors);
                        //console.log("error saving", err);
                    });
                } else {
                    klp.utils.alertMessage("Please correct errors and re-submit", "error");
                }

            });

            $('#submitBtn').click(function(e) {
                e.preventDefault();
                $('#' + formID).submit();
            });

            var tplVolunteerOpportunity = swig.compile($('#tpl-volunteerOpportunity').html());
            _(data.volunteer_activities).each(function(v) {
                var html = tplVolunteerOpportunity(v);
                $('#jsVolunteerTable').append(html);
            });

            var tplDonationRequirement = swig.compile($('#tpl-donationRequirement').html());
            var donationsURL = "donation_requirements/";
            var params = {
                'organization': ORGANIZATION_ID
            };
            var $donationsXHR = klp.api.authDo(donationsURL, params);
            $donationsXHR.done(function(data) {
                var requirements = data.results;
                _(requirements).each(function(r) {
                    var html = tplDonationRequirement(r);
                    $('#donationTable').append(html);
                });
            });

            klp.auth.events.on("logout", function() {
                location.href = "/organisation/" + data.id;
            });
        });
    };
})();
