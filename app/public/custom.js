$(document).ready(function(){
    $('#crystallized').validate({
        rules: {
            company: {
                required: true
            },
            email: {
                required: true,
                email: true
            },
            category_cards_green: {
                required: true
            },
            category_cards_red: {
                required: true
            },
            topaasia_green: {
                required: true
            },
            improvement_green: {
                required: true
            },
            lead_green: {
                required: true
            },
            topaasia_red: {
                required: true
            },
            improvement_red: {
                required: true
            },
            lead_red: {
                required: true
            },
            rating: {
                required: true
            },
            last_used: {
                required: true
            }
        },
        highlight: function (label) {
            $(label).closest('.control-group').removeClass('success').addClass('error');
        },
        success: function (label) {
            label.html('&check;').addClass('valid').closest('.control-group').removeClass('error').addClass('success');
        }
    });
});