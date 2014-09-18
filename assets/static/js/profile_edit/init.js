(function() {
    klp.init = function() {
        var $profileXHR = klp.api.authDo("users/profile");
        $profileXHR.done(function(data) {
            console.log("data", data);
            $('#firstName').val(data.first_name);
            $('#lastName').val(data.last_name);
            $('#email').val(data.email);
            $('#mobileNo').val(data.mobile_no);

            $('#userProfileForm').submit(function(e) {
                if (e) {
                    e.preventDefault();
                }
                var data = {
                    'first_name': $('#firstName').val(),
                    'last_name': $('#lastName').val(),
                    'email': $('#email').val(),
                    'mobile_no': $('#mobileNo').val()
                };
                //FIXME: do validations
                var editXHR = klp.api.authDo("users/profile", data, "PATCH");
                editXHR.done(function(response) {
                    console.log("saved", response);
                    klp.auth.loginUser(response);
                });
                editXHR.fail(function(err) {
                    console.log("error saving", err);
                });
            });

            $('#submitBtn').click(function(e) {
                e.preventDefault();
                $('#userProfileForm').submit();
            });

            $('#changePasswordForm').submit(function(e) {
                if (e) {
                    e.preventDefault();
                }
                var data = {
                    'old_password': $('#oldPassword').val(),
                    'new_password1': $('#newPassword1').val(),
                    'new_password2': $('#newPassword2').val()
                };

                //FIXME: do validations
                var passXHR = klp.api.authDo("password-change/", data, "POST");
                passXHR.done(function(response) {
                    console.log("success", response);
                });
                passXHR.fail(function(err) {
                    console.log("error updating pass", err);
                });
            });

            $('#submitPassword').click(function(e) {
                $('#changePasswordForm').submit();
            });
        });
    };
})();