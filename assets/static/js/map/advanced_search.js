'use strict';
(function(){
    var t = klp.advanced_search = {};

    var $_form_advanced_search,
        $_input_partner;

    t.init = function(){
        $_form_advanced_search = $('#form_advanced_search');
        $_form_advanced_search.on('submit', search);

        $_input_partner = $('input[name="partner"]:radio');
        $_input_partner.on('change', fill_program);
    };

    var search = function(e) {
        e.preventDefault();

        var formdata = $_form_advanced_search.serializeArray();
        var data = {};
        $(formdata ).each(function(index, obj){
            data[obj.name] = obj.value;
        });
        klp.router.setHash('advanced', data);
    }

    var fill_program = function(e) {
        e.preventDefault();

        console.log(e.target);
    }
})();
