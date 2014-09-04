var live_update = function(){
  var live_update = $('#live-update');
  var update_fragment = document.createDocumentFragment();
  $.get( "live_update.js", function( data ) {
    console.log(data);
    $("#live-update-contents").html(
    eval(data);
  });
};

$(function () {
  if ($('#live-update')[0] != undefined) {
    setInterval(live_update, 1000);
  };
});