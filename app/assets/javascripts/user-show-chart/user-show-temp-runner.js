$(document).ready(function(){
  function drawLiveUpdateChart () {
    var chart = new UserShowTempChartDrawer({
      height: 450,
      margin: 40,
      circleRadius: 4,
      transitionDuration: 1000,
      hasTransitions: false,
      hasToolTips: false
    });
    chart.drawChart();
  }
  if($("#d3-chart").length > 0){
    if ( /live_update/.test(document.URL) ) {
      setInterval(drawLiveUpdateChart, 1000);
    } else {
      var chart = new UserShowTempChartDrawer({
        height: 450,
        margin: 40,
        circleRadius: 4,
        transitionDuration: 1000,
        hasTransitions: true,
        hasToolTips: true
      });
      chart.drawChart();
    }
  }
});