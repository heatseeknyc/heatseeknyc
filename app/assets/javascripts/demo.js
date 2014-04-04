$(document).ready(function(){
  $("#demo-lawyer").on("click", function(e){
    $("#user_email").val("demo-lawyer@heatseeknyc.com");
    $("#user_password").val("33west26");
    $("input[value='Sign in']").click();
  });
  $("#demo-user").on("click", function(e){
    $("#user_email").val("demo-user@heatseeknyc.com");
    $("#user_password").val("33west26");
    $("input[value='Sign in']").click();
  });
});