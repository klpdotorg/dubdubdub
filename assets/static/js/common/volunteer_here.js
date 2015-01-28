/*
    Handles displaying of confirm modal for volunteer activities
 */

(function() {
    var t = klp.volunteer_here = {};
    var tplConfirmModal = swig.compile($('#tpl-volunteerHereModal').html());

    t.init = function() {
        $(document).on("click", ".js-volunteerHereBtn", function(e) {
            e.preventDefault();
            var $this = $(this);
            var activityId = $this.attr("data-id");
            klp.auth.requireLogin(function() {
                var $xhr = klp.api.authDo('volunteer_activities/' + activityId);
                $xhr.done(function(data) {
                    showConfirmModal(data);
                });
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
            // console.log("volunteer confirm", data);
            klp.utils.alertMessage("Confirmed. Thanks for volunteering!", "success");
            t.close();
            //showConfirmModal(data);
        });
        $xhr.fail(function(err) {
            //FIXME: check better for errors / duplicate signup
            klp.utils.alertMessage("Failed to confirm volunteering.", "error");
        });
    }

    t.close =function() {
        $('.js-volunteerHereModal').hide().remove();
        $('.closeLightBox').click();
    };

    function showConfirmModal(data) {
        var userId = klp.auth.getId();
        for (var i=0; i<data.users.length;i++) {
            if (parseInt(userId) === data.users[i].user_details.id) {
                klp.utils.alertMessage("Already signed up for this activity.", "warning");
                return;
            }
        }
        var html = tplConfirmModal(data);
        $('.js-volunteerHereModal').remove();
        //$('body').append(html);
        var activityId = data.id;
        klp.utils.openModal(html);

        $('.jsConfirmVolunteerBtn').click(function(e) {
            e.preventDefault();
            doConfirm(activityId);
        });

        $('.btn-modal-close').click(function() {
            t.close();
        });
    }

})();
