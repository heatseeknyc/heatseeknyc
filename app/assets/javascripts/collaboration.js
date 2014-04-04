$(document).ready(function() {
  $(".add-user-link").on("click", function(e){
    e.preventDefault();
    e.stopPropagation();
    $.ajax({
      url: $(this)[0].href,
      dataType: "script",
      success: $(this).parent().hide(),
    });
  });
});


$.getScript( "ajax/test.js", function( data, textStatus, jqxhr ) {
  console.log( data ); // Data returned
  console.log( textStatus ); // Success
  console.log( jqxhr.status ); // 200
  console.log( "Load was performed." );
});


$(".add-user-link").on("click", function(e){
    e.preventDefault();
    e.stopPropagation();

  $.getScript( $(this)[0].href )
    .done(function( script ) {
      console.log( textStatus );
    })
    .fail(function() {
    $( "div.log" ).text( "Triggered ajaxError handler." );
  });

});