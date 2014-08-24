(function() {
    var base = "/api/v1/";
    var cache = {};
    klp.api = {
        do: function(endpoint, data, method) {
            if (typeof(method) === 'undefined') {
                method = 'GET';
            }
            if (typeof(data) === 'undefined') {
                data = {};
            }
            var $deferred = $.Deferred();
            $deferred.abort = function() {
                if ($xhr && $xhr.state() === 'pending') {
                    $xhr.abort();
                }
            };
            var cacheKey = JSON.stringify({
                'endpoint': endpoint,
                'data': data
            });
            if (cache.hasOwnProperty(cacheKey)) {
                setTimeout(function() {
                    $deferred.resolve(cache[cacheKey]);
                }, 0);
            } else {
                var $xhr = $.ajax({
                    url: base + endpoint,
                    data: data,
                    type: method,
                    dataType: 'json'
                });
                $xhr.done(function(data) {
                    cache[cacheKey] = data;
                    $deferred.resolve(data);
                });
                $xhr.fail(function(err) {
                    $deferred.reject(err);
                });
            }
            return $deferred;
        }
    }
})();