(function() {
    klp.init = function() {
        //FIXME: how to get only 10 stories?
        var storiesXHR = klp.api.do("stories", {
            'verified': 'yes',
            //FIXEDIT: would this do?
            'limit': 10
        });
        var tplStories = swig.compile($('#tpl-recentStories').html());
        storiesXHR.done(function(data) {
            var context = {
                stories: getTwoStories(data)
            };
            // console.log("context", context);
            var html = tplStories(context);
            // console.log("html", html);
            $('#jsRecentlySharedStories').html(html);
        });
    };

    //gets two recent stories, ensuring both have comments
    //and belong to different schools
    function getTwoStories(data) {
        var stories = [];
        for (var i=0; i<data.features.length; i++) {
            var thisStory = data.features[i];
            if (!thisStory.comments) {
                continue;
            }
            if (stories.length === 1) {
                var thatStory = stories[0];
                if (thisStory.school === thatStory.school) {
                    continue;
                }
                stories[1] = thisStory;
                return stories;
            } else {
                stories[0] = thisStory
            }
        }
    }

})();
