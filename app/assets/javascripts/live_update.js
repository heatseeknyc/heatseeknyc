$(function () {
  if ($('#live-update')[0] != undefined) {
    setInterval(drawChartAjaxCall, 1000);
  };
});