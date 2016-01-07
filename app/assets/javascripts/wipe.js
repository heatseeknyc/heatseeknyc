$(document).ready(function(){
	// init controller
	var controller = new ScrollMagic.Controller();

	// define movement of panels
	var wipeAnimation = new TimelineMax()
	  
	.fromTo("#overlay", 1, {
	    y: "0"
	}, {
	    y: "-100%",
	    ease: Linear.easeNone
	}) 

	// create a scene
	new ScrollMagic.Scene({
	        triggerElement: "#pin-container",
	    	triggerHook: "onLeave",
	    	duration: "110%"
	    })
	    .setPin("#pin-container")
	    .setTween(wipeAnimation)
	    .addTo(controller);

	var heightOfOverlay = "621px";

	$(".overlay-arrow").click(function(){
		$("body").animate({scrollTop:heightOfOverlay}, "3000");
	})

});
