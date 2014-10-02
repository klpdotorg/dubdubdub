(function() {
    var t = klp.login_modal = {};
    var postLoginCallback = null;
    t.open = function(callback) {
        postLoginCallback = callback;
        klp.openModal = t;
        $('.js-login-modal').addClass('show');
        showSignup();
    };

    t.close = function() {
        //showSignup();
        console.log("login modal close called");
        $('.js-login-modal').removeClass('show');
        klp.utils.clearForm('signupForm');
        klp.utils.clearForm('loginForm');
        klp.utils.clearForm('forgotPasswordForm');
        postLoginCallback = null;
    };

    t.init = function() {
        $('#signupForm').submit(submitSignup);
        $('#signupFormSubmit').click(function(e) {
            e.preventDefault();
            $('#signupForm').submit();
        });
        $('#loginForm').submit(submitLogin);
        $('#loginFormSubmit').click(function(e) {
            e.preventDefault();
            $('#loginForm').submit();
        });

        $('.js-showLogin').click(showLogin);
        $('.js-showSignup').click(showSignup);

        $('#forgotPasswordForm').submit(submitForgotPassword);
        $('#forgotPasswordFormSubmit').click(function(e) {
            e.preventDefault();
            $('#forgotPasswordForm').submit();
        });
        $('.js-showForgotPassword').click(showForgotPassword);
    };

    function showSignup(e) {
        if (e) {
            e.preventDefault();
        }
        $('#loginContainer').hide();
        $('#forgotPasswordContainer').hide();
        $('#signupContainer').show();

    }

    function showForgotPassword(e) {
        if (e) {
            e.preventDefault();
        }
        $('#loginContainer').hide();
        $('#signupContainer').hide();
        $('#forgotPasswordContainer').show();
    }

    function showLogin(e) {
        e.preventDefault();
        $('#signupContainer').hide();
        $('#loginContainer').show();
    }

    function submitSignup(e) {
        if (e) {
            e.preventDefault();
        }
        var formID = 'signupForm';
        klp.utils.clearValidationErrors(formID);
        var isValid = klp.utils.validateRequired(formID);
        if (isValid) {
            var fields = {
                'first_name': $('#signupFirstName'),
                'last_name': $('#signupLastName'),
                'mobile_no': $('#signupPhone'),
                'email': $('#signupEmail'),
                'password': $('#signupPassword')                
            };

            var data = klp.utils.getFormData(fields);
            
            klp.utils.startSubmit(formID);
            var signupXHR = klp.api.signup(data);
            
            signupXHR.done(function(userData) {
                klp.utils.stopSubmit(formID);           
                klp.auth.loginUser(userData);
                klp.utils.alertMessage("Thanks for signing up!", "success");
                if (postLoginCallback) {
                    postLoginCallback();
                }
                t.close();
            });

            signupXHR.fail(function(err) {
                //FIXME: deal with errors
                console.log("signup error", err);
                klp.utils.stopSubmit(formID);
                var errors = JSON.parse(err.responseText);
                if ('detail' in errors && errors.detail === 'duplicate email') {
                    var $field = fields.email;
                    klp.utils.invalidateField($field, "This email address already exists.");
                } else {
                    klp.utils.invalidateErrors(fields, errors);
                }
                //alert("error signing up");
            });
        }
    }

    function submitLogin(e) {
        if (e) {
            e.preventDefault();
        }
        var formID = 'loginForm';
        klp.utils.clearValidationErrors(formID);
        var isValid = klp.utils.validateRequired('loginForm');
        if (isValid) {
            var data = {
                'email': $('#loginEmail').val(),
                'password': $('#loginPassword').val()
            };
            var loginXHR = klp.api.login(data);
            klp.utils.startSubmit(formID);
            loginXHR.done(function(userData) {
                klp.utils.stopSubmit(formID);
                userData.email = data.email;
                klp.auth.loginUser(userData);
                klp.utils.alertMessage("Logged in successfully!", "success");
                if (postLoginCallback) {
                    postLoginCallback();
                }
                t.close();
                //console.log("login done", postLoginCallback);

            });

            loginXHR.fail(function(err) {
                console.log("login error", err);
                klp.utils.stopSubmit(formID);
                var errors = JSON.parse(err.responseText);
                var $field = $('#loginPassword');
                if (errors.detail) {
                    klp.utils.invalidateField($field, errors.detail);
                }
            });
        }
    }

    function submitForgotPassword(e) {
        if (e) {
            e.preventDefault();
        }
        var formID = 'forgotPasswordForm';

        klp.utils.clearValidationErrors(formID);
        var isValid = klp.utils.validateRequired(formID);
        if (isValid) {
            var data = {
                'email': $('#forgotPasswordEmail').val()
            };
            var url = 'password-reset/request';
            var $xhr = klp.api.do(url, data, 'POST');
            klp.utils.startSubmit(formID);
            $xhr.done(function() {  
                klp.utils.stopSubmit(formID);
                klp.utils.alertMessage("Please check your email for password reset instructions", "success");
                t.close();
            });
            $xhr.fail(function(err) {
                klp.utils.stopSubmit(formID);
                var errorJSON = JSON.parse(err.responseText);
                if (errorJSON.detail) {
                    klp.utils.invalidateField($('#forgotPasswordEmail'), errorJSON.detail);

                }
                //klp.utils.alertMessage("Invalid email address", "error");
            });
        }
    }


})();