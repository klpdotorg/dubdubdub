(function() {
    var t = klp.auth = {};
    var tokenKey = "klpUserToken";
    var emailKey = "klpUserEmail";

    t.loginUser = function(userData) {
        var token = userData.token;
        var email = userData.email;
        localStorage.setItem(tokenKey, token);
        localStorage.setItem(emailKey, email);
        t.events.trigger('login', userData);
    };

    t.getToken = function() {
        return localStorage.getItem(tokenKey);
    };

    t.logoutUser = function() {
        localStorage.removeItem(tokenKey);
        localStorage.removeItem(emailKey);
    };

    t.requireLogin = function(callback) {
        var token = t.getToken();
        if (token) {
            callback();
        } else {
            klp.login_modal.open(callback);
        }
    };

    t.init = function() {
        t.events = $('<div />');
        console.log("initting auth");
        $(document).on("click", ".profile-options-wrapper .profile-options", function(e){
            console.log("clicked auth");
            var $user = $('#authUsername');
            var state = $user.data('state');
            console.log('state', state);
            if (state === 'anonymous') {
                klp.login_modal.open();
            } else {
                if($(document).width() < 768){
                    return true;
                }

                e.preventDefault();

                if(!$(".profile-options-wrapper").hasClass("show-drop")) {
                    $(".profile-options-wrapper").addClass("show-drop");
                } else {
                    $(".profile-options-wrapper").removeClass("show-drop");
                }
            }
        });

        t.events.on('login', function(e, data) {
            var firstName = data.first_name;
            var lastName = data.last_name;
            var name = firstName + " " + lastName;
            var $user = $('#authUsername');
            $user.text(name);
            $user.data('state', 'loggedin')
        });
    };

})();