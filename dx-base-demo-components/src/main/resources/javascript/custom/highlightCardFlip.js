$(document).ready(function() {
    //when the card is clicked, this will add the flip effect using a class.
    $(".flip-container-click").click(function() {
        $(this).toggleClass("flip");
    });
});