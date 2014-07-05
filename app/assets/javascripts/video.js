jQuery(document).ready(function ($) {

	function isMobile() {
		if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
			return true;
		}
		else {
			return false;
		}
	}
	
	/* Video */
	
	$('#play-button').on('click', function(e) {
		
		var videoContainer = $('#video-container');
		
		videoContainer.prepend('<iframe src="//player.vimeo.com/video/75709448?title=0&amp;byline=0&amp;portrait=0&amp;color=ffffff&amp;autoplay=1" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>');
		
		resizeToCover();
		
		videoContainer.css({'z-index':'9999','background':'#252729'}).fadeIn(300);
		
		//$('#ditto-mobile').hide();
		$('#video-controls').fadeIn(900);
		$('#center-control').fadeOut(700);
		//$('#down-arrow-container').css('z-index','999');
		e.preventDefault();
	});
	
	function bringCanvas() {
		$('#video-controls').fadeOut(300);
		$('#video-container').fadeOut(400, function() {
			$(this).html('').css({'z-index':-9999,'display':'none','background':'transparent'});
		});
		
		var windowWidth = $(window).width();
		
		//$('#down-arrow-container').css('z-index','99999');
		
		if (windowWidth > 690) {
			//$('#ditto-mobile').hide();
		}
		else {
			//$('#ditto-mobile').fadeIn(200);
		}
	}
	$('#close-video').on('click', function(e) {
		bringCanvas();
		$('#center-control').fadeIn(200);
	});
	
	jQuery(function() { // runs after DOM has loaded
		
		jQuery(window).resize(function () { resizeToCover(); });
		jQuery(window).trigger('resize');
		
		//window.addEventListener("orientationchange", function() {resizeToCover();}, false);
	});

	function resizeToCover() {
		
		// Window Height - Nav
		/*
		if ($('.menu').css('display')!='none') {
			var menuHeight = $('.menu').height();
		}
		else {
			var menuHeight = $('.menu-mobile').height();
		}
		
		var targetHeight = jQuery(window).height() - menuHeight;
		*/
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