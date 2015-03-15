(function($) {
    $.fn.maxChars = function(options) {
        console.log("init maxChars");
        var opts = $.extend({
            'max': 2000,
            'charsLeftString': 'Characters remaining: ',
            'validClass': 'valid-chars',
            'invalidClass': 'invalid-chars'
        }, options);
        var $this = $(this);
        var $container = $('<div />').addClass('validate-chars');
        var $charsLeftString = $('<span>')
                                .text(opts.charsLeftString)
                                .appendTo($container);
        var $charsLeft = $('<span />')
                          .addClass('chars-left-num')
                          .appendTo($container);
        //console.log($container);
        //GLOB = $container;
        $this.after($container);
        $this.on('change keyup', function() {
            var charCount = $this.val().length;
            var charsLeft = opts.max - charCount;
            $charsLeft.text(_.string.numberFormat(charsLeft));
            if (charCount <= opts.max) {
                if (!$container.hasClass(opts.validClass)) {
                    $container.removeClass(opts.invalidClass).addClass(opts.validClass);
                }
            } else {
                if (!$container.hasClass(opts.invalidClass)) {
                    $container.removeClass(opts.validClass).addClass(opts.invalidClass);
                }
            }
        });
        $this.change();
    };

})(jQuery);