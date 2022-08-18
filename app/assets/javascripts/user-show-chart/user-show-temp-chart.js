function UserShowTempChartDrawer(chartOptions){
  console.log(chartOptions);
  this.chartOptions = chartOptions;
  this.violations = 0;
  this.url = this.setUrl();
  this.response = null;
  this.chart = null;
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


//TODO: Mark Here
UserShowTempChartDrawer.prototype.selectDataBasedOnScreenSize = function(){
  if (window.innerWidth < 450 && this.response.length > 45) {
    return this.response.slice(this.response.length - 46);
  }else if(window.innerWidth < 720 && this.response.length > 90){
    return this.response.slice(this.response.length - 91);
  }else if(window.innerWidth < 1080 && this.response.length > 135){
    return this.response.slice(this.response.length - 136);
  } else {
    return this.response;
  }
};

UserShowTempChartDrawer.prototype.createAndDrawChartSvg = function(){
  this.chart = new UserShowTempChartSvg(
    this.selectDataBasedOnScreenSize(), this.violations, this.chartOptions
  );
  this.chart.addChartElements();
};

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
  console.log(this.url)
  $.getJSON(this.url + ".json", function(response){
    self.response = self.fixData(response);
    self.drawChartOnWindowResize();
    self.updateTempForLiveUpdate(response);
    self.addViolationCountToLegend();
  });
};
