(function() {
    klp.init = function() {
        var $profileXHR = klp.api.do("users/" + USER_ID);
        $profileXHR.done(function(data) {
            console.log("data", data);
        });
    };

})();