$(document).ready(function(){
  $("#demo").on("click", function(e){
    $("#user_email").val("demo@heatseeknyc.com");
    $("#user_password").val("33west26");
    $("input[value='Sign in']").click();
  });
});