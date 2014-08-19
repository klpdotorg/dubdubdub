(function() {
    var base = "/api/v1/";
    klp.api = {
        do: function(endpoint, data, method) {
            if (typeof(method) === 'undefined') {
                method = 'GET';
            }
            var $xhr = $.ajax({
                url: base + endpoint,
                data: data,
                type: method,
                dataType: 'json'
            });
            return $xhr;
        }
    }
})();