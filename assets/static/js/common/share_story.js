/*
    FIXME: where is this used? I think we can delete it.
 */
(function(){
    var t = klp.share_story = {}; 
    var $modal_share_story;
    var open = function(e){
        e.preventDefault();
        $modal_share_story.addClass("show");
        $('#modal_overlay').addClass("show");
    };
    t.init = function(){
        $modal_share_story = $('#modal_share_your_story');
        $(document).on('click', "#trigger_share_story_modal", open);
    };

})();
