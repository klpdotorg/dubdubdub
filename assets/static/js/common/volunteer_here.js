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

    //Loops through all volunteer here buttons, checks if user is already registered,
    //deals with it appropriately. 
    t.checkSelf = function(activities) {
        var userId = klp.auth.getId();
        if (!userId) {
            return;
        }
        _(activities).each(function(a, index) {
            _(a.users).each(function(user) {
                if (parseInt(user.user_details.id) === parseInt(userId)) {
                    var btn = $('.js-volunteerHereBtn').eq(index);
                    btn.attr("data-self", "true");
                    btn.hide(); //FIXME: display something instead of hiding
                }
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