$(document).ready(function () {
    $(".investor-contact-form").submit(function (e) {
        e.preventDefault();
        var $this = $(this);
        $.ajax({
            type: 'POST',
            url: $this.attr('action'),
            data: $this.serialize(),
            success: function (response) {
                $this.closest('form').find("input[type=text], textarea").val("");
                $this.find('.investor-button').fadeOut("slow", function () {
                    $this.find('.form-wrap').hide();
                    $this.find('.investor-saved').fadeIn("slow");
                });
            }
        });
    });
});