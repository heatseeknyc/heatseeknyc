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

// Donation Button on index page
var donatePop = function() {
  $('.donate-pop').toggleClass('hidden');
}

$(document).ready(function() {
  $('#mc_embed_signup form input.paypal-btn').mouseover(function(){
    $('.pp-submit-btn').css("background-color","#CCC");
  });

  $('#mc_embed_signup form input.paypal-btn').mouseout(function(){
    $('.pp-submit-btn').css("background-color","#F2F2F2");
  });

  // open donate modal
  $('a.donate-btn').click(function() {
    donatePop();
  });

  // close donate modal
  $('p.donate-dismiss').click(function() {
    donatePop();
  });
});