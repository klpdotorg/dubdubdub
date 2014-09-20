(function() {
    var t = klp.volunteer_here = {};
    var tplConfirmModal = swig.compile($('#tpl-volunteerHereModal').html());

    t.init = function() {
        $(document).on("click", ".js-volunteerHereBtn", function(e) {
            e.preventDefault();
            var $this = $(this);
            var activityId = $this.attr("data-id");
            klp.auth.requireLogin(function() {
                doConfirm(activityId);
            });
        });
    };

    function doConfirm(activityId) {
        var url = "volunteer_activities/" + activityId + "/users";
        var $xhr = klp.api.authDo(url, {}, "POST");
        $xhr.done(function(data) {
            console.log("volunteer confirm", data);
            showConfirmModal(data);
        });
        $xhr.fail(function(err) {
            //FIXME: check better for errors / duplicate signup
            klp.utils.alertMessage("Failed to confirm volunteering.", "error");
        });
    }

    function showConfirmModal(data) {
        var html = tplConfirmModal(data.activity_details);
        $('.js-volunteerHereModal').remove();
        $('body').append(html);
        $('.js-volunteerHereModal').addClass('show');
        $('.js-volunteerHereModal').find('.step-item').css({
            'visibility': 'visible',
            'opacity': '1'
        });
    }

})();