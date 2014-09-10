(function() {
    var t = klp.login_modal = {};
    var postLoginCallback = null;
    t.open = function(callback) {
        postLoginCallback = callback;
        $('.login-modal').addClass('show');
    };

    t.close = function() {
        $('.login-modal').removeClass('show');
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
    };

    function showLogin(e) {
        e.preventDefault();
        $('#signupContainer').hide();
        $('#loginContainer').show();
    }

    function submitSignup(e) {
        if (e) {
            e.preventDefault();
        }
        var data = {
            'first_name': $('#signupFirstName').val(),
            'last_name': $('#signupLastName').val(),
            'mobile_no': $('#signupPhone').val(),
            'email': $('#signupEmail').val(),
            'password': $('#signupPassword').val()
        };
        
        //FIXME: do front-end validations
        var signupXHR = klp.api.signup(data);
        
        signupXHR.done(function(userData) {            
            klp.auth.loginUser(userData);
            if (postLoginCallback) {
                postLoginCallback();
            }
            t.close();
        });

        signupXHR.fail(function(err) {
            //FIXME: deal with errors
            console.log("signup error", err);
            alert("error signing up");
        });
    }

    function submitLogin(e) {
        if (e) {
            e.preventDefault();
        }
        var data = {
            'email': $('#loginEmail').val(),
            'password': $('#loginPassword').val()
        };
        var loginXHR = klp.api.login(data);
        loginXHR.done(function(userData) {
            userData.email = data.email;
            klp.auth.loginUser(userData);
            if (postLoginCallback) {
                postLoginCallback();
            }
            t.close();
            //console.log("login done", postLoginCallback);

        });

        loginXHR.fail(function(err) {
            console.log("login error", err);
            alert("error logging in");
        });
    }

})();