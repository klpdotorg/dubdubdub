(function() {
    var t = klp.auth = {};
    var tokenKey = "klpUserToken";
    var emailKey = "klpUserEmail";
    var firstNameKey = "klpUserFirstName";
    var lastNameKey = "klpUserLastName";
    var idKey = "klpUserId";

    t.loginUser = function(userData) {
        // console.log("user data", userData);
        var token = userData.token;
        var email = userData.email;
        var firstName = userData.first_name;
        var lastName = userData.last_name;
        localStorage.setItem(tokenKey, token);
        localStorage.setItem(emailKey, email);
        localStorage.setItem(firstNameKey, firstName);
        localStorage.setItem(lastNameKey, lastName);
        localStorage.setItem(idKey, userData.id);
        t.events.trigger('login', userData);
    };

    t.getToken = function() {
        return localStorage.getItem(tokenKey);
    };

    t.getId = function() {
        return localStorage.getItem(idKey);
    };

    t.logoutUser = function() {
        localStorage.removeItem(tokenKey);
        localStorage.removeItem(emailKey);
        localStorage.removeItem(firstNameKey);
        localStorage.removeItem(lastNameKey);
        localStorage.removeItem(idKey);
        t.events.trigger('logout');
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
        //console.log("initting auth");
        $(document).on("click", ".profile-options-wrapper .profile-options", function(e){
            //console.log("clicked auth");
            var $user = $('#authUsername');
            var state = $user.data('state');
            //console.log('state', state);
            if (state === 'anonymous') {
                klp.login_modal.open();
            } else {
                e.preventDefault();
                if(!$(".profile-options-wrapper").hasClass("show-drop")) {
                    $(".profile-options-wrapper").addClass("show-drop");
                } else {
                    $(".profile-options-wrapper").removeClass("show-drop");
                }
            }
        });

        $('#logoutUser').click(function(e) {
            e.preventDefault();
            t.logoutUser();
            klp.utils.alertMessage("Logged out successfully", "success");
            $(".profile-options-wrapper").removeClass("show-drop");
        });

        t.events.on('login', function(e, data) {
            var firstName = data.first_name;
            var lastName = data.last_name;
            var name = firstName + " " + lastName;
            var $user = $('#authUsername');
            $user.text(name);
            $user.data('state', 'loggedin');
            var profileURL = "/profile/" + data.id;
            var editProfileURL = profileURL + "/edit";
            $('#userProfileBtn').attr("href", profileURL);
            $('#userEditProfileBtn').attr("href", editProfileURL);
        });

        t.events.on('logout', function(e) {
            var $user = $('#authUsername');
            $user.text("Login");
            $user.data('state', 'anonymous');
        });

        //if user has a token, show logged in state:
        var token = t.getToken();
        if (token) {
            var userData = {
                first_name: localStorage.getItem(firstNameKey),
                last_name: localStorage.getItem(lastNameKey),
                id: localStorage.getItem(idKey),
                email: localStorage.getItem(emailKey)
            };
            t.events.trigger('login', [userData]);
        }
    };

})();
