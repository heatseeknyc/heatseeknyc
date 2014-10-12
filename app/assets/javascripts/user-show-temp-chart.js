$(document).ready(function(){
  // todos for this file
  // make it OO
  drawChartAjaxCall();
});

function draw(response) {
  function UserShowTempChartSvg(response) {
        this.w = window.innerWidth;
        this.h = 450;
        // this.maxDataPointsForDots = 500;
        // this.transitionDuration = 1000;
        this.violations = 0;
        this.margin = 40;
        this.circleRadius = 4;
        this.data = this.setData(response);
        this.max = d3.max(this.data, function(d) { return Math.max( d.temp, d.outdoor_temp ) }) + 1;
        this.min = this.setMin();
        this.x = d3.time.scale().range([0, this.w - this.margin * 2]).domain([this.data[0].date, this.data[this.data.length - 1].date]);
        this.y = d3.scale.linear().range([this.h - this.margin * 2, 0]).domain([this.min, this.max]);
        // this.xAxis = d3.svg.axis().scale(this.x).tickSize(this.h - this.margin * 2).tickPadding(0).ticks(this.data.length);
        // this.yAxis = d3.svg.axis().scale(this.y).orient('left').tickSize(-this.w + this.margin * 2).tickPadding(0).ticks(5);
        // this.strokeWidth = this.w / this.data.length;
        this.svg = this.setSvg();
        this.t = this.setT();
        // this.yAxisGroup = null;
        // this.xAxisGroup = null;
        this.dataCirclesGroup = null;
        // this.dataLinesGroup = this.setDataLinesGroup();
        // this.dataLines = this.setDataLines();
        this.line = null;
        // this.garea = null;
        // this.$fillArea = null;
        this.circles = null;
      }

  // // Date constants
  // UserShowTempChartSvg.prototype.DAYS = [ 'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday' ];
  // UserShowTempChartSvg.prototype.MONTHS = [ "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE",
  //   "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER" ];

  UserShowTempChartSvg.prototype.setData = function(dataArrWithObjs) {
    var self = this;
    dataArrWithObjs.forEach(function(obj){
      obj.date = new Date(obj.created_at);
      obj.isDay = obj.date.getHours() >= 6 && obj.date.getHours() <= 22;
      if(/live_update/.test(document.URL)){
        obj.violation = true;
      }
      if( obj.violation ){ self.violations += 1; }
    });
    return dataArrWithObjs;
  };

  UserShowTempChartSvg.prototype.setMin = function() {
    if ( d3.min(this.data, function(d) { return d.outdoor_temp }) ){
      return d3.min(this.data, function(d) { return Math.min( d.temp ) }) - 5;
    } else {
      return d3.min(this.data, function(d) { return Math.min( d.temp, d.outdoor_temp ) }) - 10;
    }
  };

  UserShowTempChartSvg.prototype.setSvg = function(){
    return d3.select('#d3-chart')
      .append('svg:svg')
      .attr('width', this.w)
      .attr('height', this.h)
      .attr('class', 'viz')
      .append('svg:g')
      .attr('transform', 'translate(' + this.margin + ',' + this.margin + ')');
  };

  UserShowTempChartSvg.prototype.setT = function(){
    return this.svg.transition().duration(this.transitionDuration);
  };

// creates the svg
  var chartProperties = new UserShowTempChartSvg(response);

// area is placed first behind all other elements
  var testGroupArea = new UserShowTempChartAreaGroup(chartProperties);
  testGroupArea.addToChart();

// x ticks and labels gets placed first
  var testXGroup = new UserShowTempChartXAxisGroup(chartProperties);
  testXGroup.addToChart();

// y ticks and labels gets placed second
  var testYGroup = new UserShowTempChartYAxisGroup(chartProperties);
  testYGroup.addToChart();

// lines and labels gets placed third
  var testDataLinesGroup = new UserShowTempChartLine(chartProperties, {
    hasTransitions: true, transitionDuration: this.transitionDuration 
  });
  testDataLinesGroup.addToChart();

// circles and labels are placed fourth
  var testCircles = new UserShowTempChartCircles(chartProperties, {
    hasViolations: true,
    circleRadius: 4,
    transitionDuration: 1000,
    hasTransitions: true,
    hasToolTips: true
  });
  testCircles.addToChart();


  function addViolationCountToLegend() {
    $("#violations span").text($("#violations span")
      .text().replace(/\d+/, chartProperties.violations));
  }
  addViolationCountToLegend();




}

function drawChartBasedOnScreenSize(chartData){
  if ( $('#live-update') !== undefined ) {
    $('.temp-num').html(chartData[chartData.length - 1].temp + '°')
  }

  if (window.innerWidth < 450) {
    var quarterReadings = chartData.slice(119, 167);
    $("#d3-chart").html("")
    draw(quarterReadings);
  }else if(window.innerWidth < 720){
    var halfReadings = chartData.slice(71, 167);
    $("#d3-chart").html("")
    draw(halfReadings);
  }else if(window.innerWidth < 1080){
    var threeQuarterReadings = chartData.slice(23, 167);
    $("#d3-chart").html("")
    draw(threeQuarterReadings);
  } else {
    $("#d3-chart").html("")
    draw(chartData);
  }
}

function drawChartAjaxCall(){
  if($("#d3-chart").length > 0){
    if(/collaborations/.test(document.URL)){
      var URL = /\/users\/\d+\/collaborations\/\d+/.exec(document.URL)[0];
      // returns /user/11/collaborations/35
    } else if ( /live_update/.test(document.URL) ){
      var URL = /\/users\/\d+\/live_update/.exec(document.URL)[0];
      //returns /user/13/live_update
    } else {
      var URL = /\/users\/\d+/.exec(document.URL)[0];
    }
    $.ajax({
      url: URL,
      dataType: "JSON",
      success: function(response){
        if( response.length > 0 ){
          drawChartBasedOnScreenSize(response);
          var resizeTimer = 0;
          window.onresize = function(){
            if (resizeTimer){
              clearTimeout(resizeTimer);
            }
            resizeTimer = setTimeout(function(){
              drawChartBasedOnScreenSize(response);
            }, 50);
          };
        }
      },
      error: function(response){
        console.log("error");
        console.log(response);
      }
    });
  }
}
