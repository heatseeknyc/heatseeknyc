

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

//----for Chrome on Android ----//
    var bg = $("#overlay");
    $(window).resize("resizeBackground");
    function resizeBackground() {
        bg.height(jQuery(window).height());
    }
    resizeBackground();
    if (navigator.appVersion.indexOf("Chrome/") != -1) {
      if(window.screen.height <= 700 && window.screen.width <= 400){
        $("#overlay").css({
          "background": "url('assets/city-background-mobile.jpg') 0% / 100% 500px no-repeat"
        })
      }
    }

    
  });
