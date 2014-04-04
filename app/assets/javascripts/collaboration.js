$(document).ready(function() {
  $(".add-user-link").on("click", function(e){
      e.preventDefault();
      e.stopPropagation();

    $.post( $(this)[0].href )
      .done(function( script ) {
        console.log( textStatus );
      })
      .fail(function() {
      $( "div.log" ).text( "Triggered ajaxError handler." );
    });

  });
});


