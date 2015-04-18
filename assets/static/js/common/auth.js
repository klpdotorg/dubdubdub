(function() {
    var t = klp.auth = {};

    //define keys to use in localStorage to store data
    var tokenKey = "klpUserToken";
    var emailKey = "klpUserEmail";
    var firstNameKey = "klpUserFirstName";
    var lastNameKey = "klpUserLastName";
    var idKey = "klpUserId";

    /*
        Called after userData has been received from API after
        successful login. Saves user data in localStorage.
     */
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

    /*
        Returns user token taken from localStorage
     */
    t.getToken = function() {
        return localStorage.getItem(tokenKey);
    };

    /*
        Gets user ID, taken from localStorage
     */
    t.getId = function() {
        return localStorage.getItem(idKey);
    };

    /*
        Deletes all user data from localStorage,
        thereby 'logging out' user.
        Fires a 'logout' event on klp.auth.events
        so that UI can react to user logout
     */
    t.logoutUser = function() {
        localStorage.removeItem(tokenKey);
        localStorage.removeItem(emailKey);
        localStorage.removeItem(firstNameKey);
        localStorage.removeItem(lastNameKey);
        localStorage.removeItem(idKey);
        t.events.trigger('logout');
    };

    /*
        Any functions that require user to be logged in to execute
        should be wrapped in a klp.auth.requireLogin function.
        It will ensure the user is logged in and then call the specified callback
        eg:
          klp.auth.requireLogin(function() {
            alert("you are now logged in");
          });
     */
    t.requireLogin = function(callback) {
        var token = t.getToken();
        if (token) {
            callback();
        } else {
            klp.login_modal.open(callback);
        }
    };


    /*
        Initialize the auth module, setup events on profile menu, etc.
     */
    t.init = function() {

        //createa a dummy div to fire events on
        t.events = $('<div />');

        //profile options menu wrapper
        var $profile_options_wrapper = $('.profile-options-wrapper');

        // //hide menu on clicking window
        // $(window).on('click', function(e) {
        //     if ($profile_options_wrapper.hasClass('show-drop')) {
        //         $profile_options_wrapper.removeClass('show-drop');
        //     }
        // });

        $('.js-login-trigger').click(function(e){
            //console.log("clicked auth");
            //console.log("hello");
            e.stopPropagation();
            e.preventDefault();
            //get user login state (stored in DOM data)
            var $user = $('#authUsername');
            var state = $user.data('state');
            console.log("state", state);
            //if user is not logged in, open login modal
            if (state === 'anonymous') {
                klp.login_modal.open();
            } else {
                //else show profile drop-down
                // if(!$(".profile-options-wrapper").hasClass("show-drop")) {
                //     $(".profile-options-wrapper").addClass("show-drop");
                // } else {
                //     $(".profile-options-wrapper").removeClass("show-drop");
                // }
            }
        });

        // //show profile menu on clicking button
        // $(document).on("click", ".js-login-trigger", function(e){
        //     //console.log("clicked auth");
        //     console.log("hello");
        //     e.stopPropagation();

        //     //get user login state (stored in DOM data)
        //     var $user = $('#authUsername');
        //     var state = $user.data('state');
        //     console.log("state", state);
        //     //if user is not logged in, open login modal
        //     if (state === 'anonymous') {
        //         klp.login_modal.open();
        //     } else {
        //         //else show profile drop-down
        //         e.preventDefault();
        //         // if(!$(".profile-options-wrapper").hasClass("show-drop")) {
        //         //     $(".profile-options-wrapper").addClass("show-drop");
        //         // } else {
        //         //     $(".profile-options-wrapper").removeClass("show-drop");
        //         // }
        //     }
        // });

        //handle logout
        $('#logoutUser').click(function(e) {
            e.preventDefault();
            t.logoutUser();
            klp.utils.alertMessage("Logged out successfully", "success");
            $(".profile-options-wrapper").removeClass("show-drop");
        });

        //handle UI state change on login event
        t.events.on('login', function(e, data) {
            var firstName = data.first_name;
            var lastName = data.last_name;
            var name = firstName + " " + lastName;
            var $user = $('#authUsername');
            //$user.text('');
            $user.data('state', 'loggedin');
            //$user.addClass("profile-logged-in");
            $('#preloginContainer').hide();
            $('#postloginContainer').show();
            var profileURL = "/profile/" + data.id;
            var editProfileURL = profileURL + "/edit";
            $('#userProfileBtn').attr("href", profileURL);
            $('#userEditProfileBtn').attr("href", editProfileURL);
        });

        //handle UI state change on logout event
        t.events.on('logout', function(e) {
            var $user = $('#authUsername');
            //$user.text("Login");
            $user.data('state', 'anonymous');
            $('#preloginContainer').show();
            $('#postloginContainer').hide();
            //$user.removeClass("profile-logged-in");
        });

        //on initialization, check if user has a token
        //if user has token, show logged in state and fire login event.
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
