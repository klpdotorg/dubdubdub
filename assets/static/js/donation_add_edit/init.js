(function() {
    klp.init = function() {
        console.log("init called");
        //initialize form
        klp.donation_form.init();

        //some random click handlers for the settings menu to the right of items
        $(document).on("click", ".action-dropdown .dropdown-trigger", function(e){
            if($(document).width() < 768){
                return true;
            }

            e.preventDefault();

            var $trigger = $(this).closest(".action-dropdown");

            if(!$trigger.hasClass("show-drop")) {
                $trigger.addClass("show-drop");
            } else {
                $trigger.removeClass("show-drop");
            }
        });
    }

})();