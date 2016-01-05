'use strict';
(function(){
    var t = klp.advanced_search = {};

    var $_form_advanced_search;

    t.init = function(){
        $_form_advanced_search = $('#form_advanced_search');
        $_form_advanced_search.on('submit', search);
    };

    var search = function(e) {
        e.preventDefault();

        var data = $_form_advanced_search.serializeArray();
        console.log(data);
    }
})();
