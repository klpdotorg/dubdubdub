(function() {
    klp.data = {};
    klp.openModal = null;
    $(document).ready(function() {
        $(document).on('click', ".btn-modal-close", function(e){
            e.preventDefault();

            var $modal = $(e.target).closest(".modal").removeClass("show");
            $(".modal-overlay").removeClass("show");
            if (klp.openModal) {
                klp.openModal.close();
                klp.openModal = null;
            }
        });
        klp.auth.init();
        klp.login_modal.init();
        if (klp.hasOwnProperty('init')) {
            klp.init();
        }
    });
})();