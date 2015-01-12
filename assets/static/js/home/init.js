(function() {
    klp.init = function() {
        //handle getting blog feeds
        //var feedURL = "http://blog.klp.org.in/feeds/posts/default?alt=json-in-script&callback=?";
        var feedURL = '/blog-feed';
        $.getJSON(feedURL, null, function(data) {
            processRequest(data.feed);
        });

        //get and show SYS info
        var url = "stories/info/";
        var sysCountsXHR = klp.api.do(url);
        var tplSysCounts = swig.compile($('#tpl-sysCounts').html());
        sysCountsXHR.done(function(data) {
            var html = tplSysCounts(data);
            $('#sysCounts').html(html);
        });

        //get and show recent stories
        var url = "stories/";
        var params = {
            per_page: 6,
            verified: 'yes'
        };
        var sysXHR = klp.api.do(url, params);
        var tplSys = swig.compile($('#tpl-sysInfo').html());
        sysXHR.done(function(data) {
            var context = {
                'stories': data.features
            };
            var html = tplSys(context);
            $('#sysInfo').html(html);
        });

    };

    var months = new Array("Nothing","Jan","Feb","March","April","May","June","July","Aug","Sept","Oct","Nov","Dec");

    function processRequest(feed) {
        var entries = feed.entry || [];
        var html = ['<div>'];

        for (var i = 0; i < 2; ++i) {
            var entry = entries[i];
            var title = entry.title.$t;
            var content = entry.content.$t;
            var re=/<\S[^>]*>/g;
            content=content.replace(re,"");
            content = content.substring(0,100);
            year = entry.published.$t.substring(0,4);
            month = entry.published.$t.substring(5,7);
            if( month.charAt(0) == "0")
            {
                month=month.charAt(1)
            }
            month = parseInt(month)
            date = entry.published.$t.substring(8,10);
            for(var num=0;num<entry.link.length;num++){
                if(entry.link[num].rel=='alternate') {
                    link=entry.link[num].href;
                    break;
                }
            }
            html.push('<div>', months[month],' ', date,',',year,'</div><div><strong><a href="',link,'">',title,'</a></strong></div>','<p>',content,'...','</p>');
        }
      html.push('</div>');
      document.getElementById("js-blog").innerHTML = html.join("");
    }

})();
