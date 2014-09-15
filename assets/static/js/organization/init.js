(function() {
    klp.init = function() {
        var $orgXHR = klp.api.do("organizations/" + ORGANIZATION_ID);
        $orgXHR.done(function(data) {
            console.log("data", data);
        });
    };
})();