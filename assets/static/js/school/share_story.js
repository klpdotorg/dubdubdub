(function() {
    var t = klp.share_story = {};

    var tplSysForm = swig.compile($('#tpl-share-story-form').html());
    t.init = function(schoolId) {
        $(document).on("click", "#trigger_share_story_form", function(e) {
            e.preventDefault();
            var questionsURL = 'stories/' + schoolId + '/questions';
            var $xhr = klp.api.do(questionsURL);
            $xhr.done(function(data) {
                var html = tplSysForm(data);
                $('.tab-content[data-tab=share-story]').html(html);
            });
        });

    };

})();