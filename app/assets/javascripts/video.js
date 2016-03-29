jQuery(document).ready(function ($) {

  function isMobile() {
    return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
  }

  /* Video */

  $('#play-button').on('click', function(e) {
    var videoContainer = $('#video-container');
    videoContainer.prepend('<iframe src="//player.vimeo.com/video/108858343?title=0&amp;byline=0&amp;portrait=0&amp;color=ffffff&amp;autoplay=1" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>');
    resizeToCover();
    videoContainer.css({'z-index':'9999','background':'#252729'}).fadeIn(300);
    $('#video-controls').fadeIn(900);
    $('#center-control').fadeOut(700);
    e.preventDefault();
  });

  function bringCanvas() {
    $('#video-controls').fadeOut(300);
    $('#video-container').fadeOut(400, function() {
      $(this).html('').css({'z-index':-9999,'display':'none','background':'transparent'});
    });

    var windowWidth = $(window).width();
  }
  $('#close-video').on('click', function(e) {
    bringCanvas();
    $('#center-control').fadeIn(200);
  });

  jQuery(function() { // runs after DOM has loaded
    jQuery(window).resize(function () { resizeToCover(); });
    jQuery(window).trigger('resize');
  });

  function resizeToCover() {
    var targetHeight = jQuery(window).height();
    // set the video viewport to the window size
    jQuery('#video-container').width(jQuery(window).width());
    jQuery('#video-container').height(jQuery(window).height());

    var videoContainer = $('#video-container');
    var videoEmbed = videoContainer.find('iframe');

    if (videoEmbed.length>0) {
      videoEmbed.width(videoContainer.width())
      videoEmbed.height(videoContainer.height());
    }
  }

});
