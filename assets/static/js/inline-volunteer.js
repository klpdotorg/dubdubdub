function resizeVolunteerHeader() {
    if ($(window).width() >= 980) {
        // Its a desktop device
        if ($(window).height() < 685) {
            // Resize only if height less than 685px (600px banner + 85px navigation)
            var header_height = $(window).height() - (85);
            $(".volunteer-header").css({
                'height': header_height + 'px',
            });
            $(".volunteer-header .content").css({
                'padding-top': 50 + 'px',
            });
            var headline_text_height = 130;
            var headline_text_mar_btm = 50;
            if (header_height < 500) {
                headline_text_height = 110;
                headline_text_mar_btm = 30;
            }
            $(".volunteer-header .content .headline_text").css({
                'height': headline_text_height + 'px',
                'background-size': 'auto ' + headline_text_height +
                    'px',
                'margin-bottom': headline_text_mar_btm + 'px'
            });
        }
    }
}
$(document).ready(function() {
    $('input').iCheck({
        checkboxClass: 'icheckbox_minimal',
        radioClass: 'iradio_minimal',
        increaseArea: '20%' // optional
    });

    resizeVolunteerHeader();
    $(window).resize(function() {
        resizeVolunteerHeader();
    });
});
