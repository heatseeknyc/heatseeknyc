$(document).ready(function () {

  var addUserFunction = function () {
    if ($(".add-user-link").length >= 1) {
      console.log("if statement");
      $(".add-user-link").on("click", function(e){
        e.preventDefault();
        e.stopPropagation();
        $.post( $(this)[0].href, function() {
          })
          .done(function( script ) {
            console.log("success function triggered");
          })
          .fail(function() {
            console.log("fail function triggered");
          });
      });
    } else {
      console.log("else statement");
      setTimeout(addUserFunction, 1000);
    }
  }

  addUserFunction();
});
