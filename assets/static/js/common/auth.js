(function() {
    var t = klp.auth = {};
    var tokenKey = "klpUserToken";
    var emailKey = "klpUserEmail";

    t.loginUser = function(userData) {
        var token = userData.token;
        var email = userData.email;
        localStorage.setItem(tokenKey, token);
        localStorage.setItem(emailKey, email);
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

})();