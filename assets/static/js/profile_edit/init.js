(function() {
    klp.init = function() {
        var $profileXHR = klp.api.authDo("users/profile");
        $profileXHR.done(function(data) {
            console.log("data", data);
            $('#firstName').val(data.first_name);
            $('#lastName').val(data.last_name);
            $('#email').val(data.email);
            $('#mobileNo').val(data.mobile_no);

            var profileFormID = 'userProfileForm';
            $('#' + profileFormID).submit(function(e) {
                if (e) {
                    e.preventDefault();
                }
                klp.utils.clearValidationErrors(profileFormID);

                var fields = {
                    'first_name': $('#firstName'),
                    'last_name': $('#lastName'),
                    'email': $('#email'),
                    'mobile_no': $('#mobileNo')
                };

                var data = klp.utils.getFormData(fields);

                if (klp.utils.validateRequired(profileFormID)) {
                    var editXHR = klp.api.authDo("users/profile", data, "PATCH");
                    editXHR.done(function(response) {
                        //console.log("saved", response);
                        //klp.utils.clearValidationErrors(profileFormID);
                        klp.utils.alertMessage("Changes saved succesfully", "success");
                        klp.auth.loginUser(response);
                    });
                    editXHR.fail(function(err) {
                        //console.log("error saving", err);
                        var errors = JSON.parse(err.responseText);
                        klp.utils.invalidateErrors(fields, errors);
                    });
                }
            });

            $('#submitBtn').click(function(e) {
                e.preventDefault();
                $('#userProfileForm').submit();
            });

            var passwordFormID = 'changePasswordForm';
            $('#' + passwordFormID).submit(function(e) {
                if (e) {
                    e.preventDefault();
                }
                klp.utils.clearValidationErrors(passwordFormID);
                var fields = {
                    'old_password': $('#oldPassword'),
                    'new_password1': $('#newPassword1'),
                    'new_password2': $('#newPassword2')
                };

                var data = klp.utils.getFormData(fields);
                if (klp.utils.validateRequired(passwordFormID)) {                
                    var passXHR = klp.api.authDo("password-change/", data, "POST");
                    passXHR.done(function(response) {
                        console.log("success", response);
                        klp.utils.alertMessage("Changed password", "success");
                        klp.utils.clearValidationErrors(passwordFormID);
                    });
                    passXHR.fail(function(err) {
                        var errorsJSON = JSON.parse(err.responseText);
                        var errors = errorsJSON.detail.split(",");
                        console.log("password errors", errors);
                        if (errors.indexOf("old_password") !== -1) {
                            klp.utils.invalidateField(fields.old_password, "Incorrect password");
                        }
                        if (errors.indexOf("new_password2") !== -1) {
                            klp.utils.invalidateField(fields.new_password2, "Password 1 and 2 do not match");
                        }
                        
                    });
                }
            });

            $('#submitPassword').click(function(e) {
                $('#changePasswordForm').submit();
            });
        });
    };
})();