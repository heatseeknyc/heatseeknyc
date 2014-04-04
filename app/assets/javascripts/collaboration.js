var addUserFunction = function () {
  $(".add-user-link").on("click", function(e){
    var addUserLi = $(this).parent();
    e.preventDefault();
    e.stopPropagation();
    $.post( $(this)[0].href, function() {
      })
      .done(function( script ) {
        $(addUserLi).remove();
      })
      .fail(function() {
      });
  });
}