var addUserFunction = function () {
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
}