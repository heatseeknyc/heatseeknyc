  $(document).ready(function(){
    $(".overlay-arrow").click(function(){
     $("body,html").animate({scrollTop:"240px"}, "3000");
    });
    $(window).on('scroll', function() {
      var scroll = $(this).scrollTop();
      var height = window.innerHeight;                   
        $("#overlay").css({
          "-webkit-transform" : "translate(0%,"+ -scroll*.3+"%) matrix(1, 0, 0, 1, 0, 0)",
          "transform" : "translate(0%,"+ -scroll*.3+"%) matrix(1, 0, 0, 1, 0, 0)",
          "-moz-transform" : "translate(0%,"+ -scroll*.3+"%) matrix(1, 0, 0, 1, 0, 0)",
          "-0-transform" : "translate(0%,"+ -scroll*.3+"%) matrix(1, 0, 0, 1, 0, 0)"
        })
     });
    
  });
  