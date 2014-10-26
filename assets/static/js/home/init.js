(function() {
    klp.init = function() {
        //handle 'responsive' header resize
        resizeHeader();
        $(window).resize(function() {
            resizeHeader();
        });

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
            per_page: 8,
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
        var html = ['<ul>'];

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
            html.push(months[month],' ',date,',',year,'<br>','<b><a href="',link,'">',title,'</a></b>','<br>',content,'...','<br>','<br>');
        }
      html.push('</ul>');
      document.getElementById("blog").innerHTML = html.join("");
    }

    function resizeHeader() {
        if($(window).width() >=980){
            // Its a desktop device
            if($(window).height() <750){
                // Resize only if height less than 750px (700px header + 50px navigation)
                var header_height = $(window).height() - (50+30);   // 50px navigation + 30px padding in content

                $(".home-header .content").css({
                    'min-height': header_height + 'px',
                    'height': header_height + 'px',
                    'background-size': 'auto '+header_height + 'px'
                });

                // Setting headline text height as 130px
                $(".home-header .content .headline-text").css({
                    'height': 130 + 'px',
                    'background-size': 'auto 130px',
                    'margin-top': '30px'
                });

                if(header_height>450){
                    $(".home-header .content .info").css({
                        'margin-top': '30px',
                        'display' : 'block'
                    });
                } else {
                    $(".home-header .content .info").hide();
                }

                console.log(header_height);
            }
        } else {
            // Its a mobile or tablet. Reverting to original css.
            $(".home-header .content").css({
                'height': 'auto',
                'min-height': 'inherit'
            });
        }
    }

})();