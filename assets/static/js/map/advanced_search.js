'use strict';
(function(){
    var t = klp.advanced_search = {};

    var $_form_advanced_search,
        $_input_partner,
        $_input_programme;

    t.init = function(){
        $_form_advanced_search = $('#form_advanced_search');
        $_form_advanced_search.on('submit', do_search);

        $_input_partner = $('input[name="partner_id"]:radio');
        $_input_partner.on('change', fill_program);

        $_input_programme = $('#multi_programmes');

        // this one handles the earch url
        klp.router.routes['advanced'] = search_route;
    };

    var search_route = function() {
        var formdata = klp.router.getHash();
        console.log(formdata);

        var thisEntityXHR = klp.api.do('search/', formdata);
        thisEntityXHR.done(function(data) {
            console.log(data);
        });
    }

    var do_search = function(e) {
        e.preventDefault();
        var data = get_form_data();
        klp.router.setHash('advanced', data);
    }

    var get_form_data = function() {
        var formdata = $_form_advanced_search.serializeArray();
        console.log(formdata);
        var data = {};
        $(formdata ).each(function(index, obj){
            if (data.indexOf(obj.name) >= 0) {

            } else {
                data[obj.name] = obj.value;
            }
        });
        return data;
    }


    var fill_program = function(e) {
        e.preventDefault();
        var formdata = get_form_data();

        var thisEntityXHR = klp.api.do('programme/', formdata);
        thisEntityXHR.done(function(data) {
            $_input_programme.select2('destroy');
            $_input_programme.append( $.map(data.features, function(v, i){
                return $('<option>', { val: v.id, text: v.name });
            }) );
        });
    }
})();
