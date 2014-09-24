(function() {
    var t = klp.share_story = {};
    var tplSysForm = swig.compile($('#tpl-share-story-form').html());
    t.init = function(schoolId, originalHTML) {
        //var originalHTML = $container.html();
        $(document).on("click", "#trigger_share_story_form", function(e) {
            e.preventDefault();
            klp.router.setHash(null, {'state': 'form'}, {trigger: false});
            var questionsURL = 'stories/' + schoolId + '/questions';
            var $xhr = klp.api.do(questionsURL);
            $xhr.done(function(data) {
                var html = tplSysForm(data);
                //console.log("oldHtml", oldHtml);
                $('.tab-content[data-tab=share-story]').html(html);
            });
        });
    };
})();