$(document).ready(function(){
  function drawLiveUpdateChart () {
    var chart = new UserShowTempChartDrawer({
      height: 450,
      margin: 40,
      circleRadius: 4,
      length_days: 7,
      end_days_ago: 0,
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
        length_days: 7,
        end_days_ago: 0,
        transitionDuration: 1000,
        hasTransitions: true,
        hasToolTips: true
      });
      chart.drawChart();
    }
  }
});
