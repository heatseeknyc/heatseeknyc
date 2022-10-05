function UserShowTempChartDrawer(chartOptions){
  this.chartOptions = chartOptions;
  this.violations = 0;
  this.url = this.setUrl();
  this.response = null;
  this.chart = null;
  this.setForwardBackButtons();
}

UserShowTempChartDrawer.prototype.setUrl = function(){
  if( /collaborations/.test(document.URL) ){
    return /\/users\/\d+\/collaborations\/\d+/.exec(document.URL)[0];
    // returns '/user/13/collaborations/35'
  } else if ( /live_update/.test(document.URL) ){
    return /\/users\/\d+\/live_update/.exec(document.URL)[0];
    // returns '/user/13/live_update'
  } else {
    return /\/users\/\d+/.exec(document.URL)[0];
    // returns '/user/13'
  }
};

UserShowTempChartDrawer.prototype.fixData = function(dataArrWithObjs) {
  var self = this;
  dataArrWithObjs.forEach(function(obj){
    obj.date = new Date(obj.created_at);
    obj.isDay = obj.date.getHours() >= 6 && obj.date.getHours() <= 21;
    if(/live_update/.test(document.URL)){
      obj.violation = true;
    }
    if( obj.violation ){ self.violations++; }
  });
  return dataArrWithObjs;
};

UserShowTempChartDrawer.prototype.addViolationCountToLegend = function() {
  $("#violations span").text($("#violations span")
    .text().replace(/\d+/, this.violations));
};


UserShowTempChartDrawer.prototype.selectDataBasedOnScreenSize = function(){
  if (window.innerWidth < 450 && this.response.length > 45) {
    this.chartOptions.length_days = 1
  }else if(window.innerWidth < 720 && this.response.length > 90){
    this.chartOptions.length_days = 3
  }else if(window.innerWidth < 1080 && this.response.length > 135){
    this.chartOptions.length_days = 5
  }
  return this.response;
};

UserShowTempChartDrawer.prototype.createAndDrawChartSvg = function(){
  this.chart = new UserShowTempChartSvg(
    this.selectDataBasedOnScreenSize(), this.violations, this.chartOptions
  );
  this.chart.addChartElements();
};

UserShowTempChartDrawer.prototype.setForwardBackButtons = function(){
  let that = this
  $('#d3-back-button').on('click', function() {
    that.chartOptions.end_days_ago = that.chartOptions.end_days_ago + that.chartOptions.length_days;
    that.violations = 0;
    that.drawChart();
  });
  $('#d3-forward-button').on('click', function() {
    let diff = that.chartOptions.end_days_ago - that.chartOptions.length_days;
    that.chartOptions.end_days_ago = diff > 0 ? diff : 0
    that.violations = 0;
    that.drawChart();
  });
}

UserShowTempChartDrawer.prototype.drawChartOnWindowResize = function(){
  var resizeTimer = 0,
      self = this;
  $('#d3-chart').html('');
  this.createAndDrawChartSvg();
  window.onresize = function(){
    if (resizeTimer){
      clearTimeout(resizeTimer);
    }
    resizeTimer = setTimeout(function(){
      self.createAndDrawChartSvg();
      self.drawChartOnWindowResize();
    }, 50);
  };
};

UserShowTempChartDrawer.prototype.updateTempForLiveUpdate = function(response){
  if ( $('#live-update').length > 0 ) {
    $('.temp-num').html(response[response.length - 1].temp + '°')
  }
};

UserShowTempChartDrawer.prototype.drawChart = function() {
  var self = this;
  e = this.chartOptions.end_days_ago
  l = this.chartOptions.length_days
  $.getJSON(this.url + ".json?end_days_ago="+e+"&length_days="+l, function(response){
    self.response = self.fixData(response);
    self.drawChartOnWindowResize();
    self.updateTempForLiveUpdate(response);
    self.addViolationCountToLegend();
  });
};
