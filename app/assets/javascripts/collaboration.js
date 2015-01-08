var addUserFunction = function () {
  $(".add-user-link").on("click", function(e){
    var addUserLi = $(this).parent();
    e.preventDefault();
    e.stopPropagation();
    $.post( $(this)[0].href, function() {
      })
      .done(function( script ) {
        $(addUserLi).remove();
        if ($(".search-results-ul").children().length == 0)
        {
          $(".search-results-ul").parent().remove();
        }
      })
      .fail(function() {
      });
  });
}

$(document).ready(function() {
  $('#mc_embed_signup form input.paypal-btn').hover(function() {
    $('#mc_embed_signup a.donate-btn').toggleClass('black-back');
  });

});