(function() {

    klp.option_items = {

        init: function() {
            $('.option_item .item_values ul').slimScroll({
                height: '200px',
                size: '6px',
                color: '#8d8d8d',
                railVisible: true,
                railColor: '#f6f6f6',
                railOpacity: 1
            });
        },

        toggleList: function(obj) {
            var state_open = false;
            if ($(obj).parent().find('.item_values').hasClass('open')) {
                state_open = true;
            }
            $('.item_values').removeClass('open');
            if (state_open) {
                $(obj).parent().find('.item_values').removeClass('open');
            } else {
                $(obj).parent().find('.item_values').addClass('open');
            }
            //$(obj).parent().find('.item_values').toggleClass('open');
            //event.stopPropagation();
        },

        select: function(obj) {
            return false;
            window.location = "{{ site_url }}status_3.php";
            // var parent_option_item = $(obj).parent().parent().parent().parent().parent();
            // $(parent_option_item).find('.item_values').toggleClass('open');
            // $(parent_option_item).find('.value').text($(obj).text());
            //return false;
        }
    } 

})();