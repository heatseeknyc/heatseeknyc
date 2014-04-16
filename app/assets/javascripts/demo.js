$(document).ready(function(){
  $("#demo-lawyer").on("click", function(e){
    $(".hidden-email-field").val("demo-lawyer@heatseeknyc.com");
    $(".hidden-password-field").val("33west26");
    $("form").submit();
  });
  $("#demo-user").on("click", function(e){
    $(".hidden-email-field").val("demo-user@heatseeknyc.com");
    $(".hidden-password-field").val("33west26");
    $("form").submit();
  });
});