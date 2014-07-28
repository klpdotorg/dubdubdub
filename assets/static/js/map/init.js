(function() {
    var klp = window.klp;
    klp.init = function() {
        console.log("initting");
        console.log(klp.router);
        klp.router.init();
    };    

})();