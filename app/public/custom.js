$(document).ready(function(){
    $('#crystallized').validate();
        $('input, textarea').each(function () {
        $(this).rules('add', {
            required: true
        });
    });
});