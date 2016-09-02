(function() {
    var base = "/api/v1/";
    var cache = {};
    klp.api = {

        /*
        Call klp.api.do for unauthenticated requests.
        Maintains a cache to avoid repeated calls to server.
          Returns a Deferred object
            eg: 
            var deferred = klp.api.do("schools", {'type': 'primaryschools'});
            deferred.done(function(data) {
              ...
              });
        */
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
        },

        /*
            Make authenticated request. Called the same as 'do'.
            Will use token if present, else raise an error
            Code should ensure user is signed in before calling this.
            See common/auth.js for auth functions
         */
        'authDo': function(endpoint, data, method) {
            var token = klp.auth.getToken();
            if (!token) {
                alert("error: attempted to make authenticated request without token.");
                return;               
            }
            if (!data) {
                data = {};
            }
            if (!method) {
                method = 'GET';
            }
            var url = base + endpoint;
            var $xhr = $.ajax({
                url: url,
                data: data,
                type: method,
                dataType: 'json',
                beforeSend: function(xhr) {
                    xhr.setRequestHeader("Authorization", 'Token ' + token);
                }
            });
            return $xhr;
        },

        /*
            Signup API call
         */
        'signup': function(data) {
            var url = base + 'users';
            var $xhr = $.ajax({
                url: url,
                data: data,
                type: 'POST',
                dataType: 'json'
            });
            return $xhr;
        },

        /*
            Login
         */
        'login': function(data) {
            var url = base + 'users/login';
            var $xhr = $.ajax({
                url: url,
                data: data,
                type: 'POST',
                dataType: 'json'
            });
            return $xhr;
        }
    };

})();