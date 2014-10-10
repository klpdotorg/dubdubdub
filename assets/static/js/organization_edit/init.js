(function() {
    klp.init = function() {
        var apiURL = "organizations/" + ORGANIZATION_ID;
        var $orgXHR = klp.api.authDo(apiURL);
        $orgXHR.done(function(data) {
            console.log("data", data);
            $('#orgName').val(data.name);
            $('#orgURL').val(data.url);
            $('#orgEmail').val(data.email);
            $('#orgContactName').val(data.contact_name);
            var formID = 'orgForm';
            $('#' + formID).submit(function(e) {
                if (e) {
                    e.preventDefault();
                }
                klp.utils.clearValidationErrors(formID);
                var fields = {
                    'name': $('#orgName'),
                    'url': $('#orgURL'),
                    'email': $('#orgEmail'),
                    'contact_name': $('#orgContactName')
                };

                if (klp.utils.validateRequired(formID)) {
                    var data = klp.utils.getFormData(fields);
                    var orgXHR = klp.api.authDo(apiURL, data, "PUT");
                    orgXHR.done(function(response) {
                        $('#displayOrgName').text(response.name);
                        klp.utils.alertMessage("Changes saved", "success")
                    });

                    orgXHR.fail(function(err) {
                        var errors = JSON.parse(err.responseText);
                        klp.utils.invalidateErrors(fields, errors);
                        //console.log("error saving", err);
                    });
                }

            });

            $('#submitBtn').click(function(e) {
                e.preventDefault();
                $('#' + formID).submit();
            });

            var tplVolunteerOpportunity = swig.compile($('#tpl-volunteerOpportunity').html());
            _(data.volunteer_activities).each(function(v) {
                var html = tplVolunteerOpportunity(v);
                $('#volunteerTable').append(html);
            });
            
            klp.auth.events.on("logout", function() {
                location.href = "/organisation/" + data.id;
            });
        });
    };
})();