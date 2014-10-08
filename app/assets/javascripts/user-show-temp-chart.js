$(document).ready(function(){
  // todos for this file
  // make it OO
  drawChartAjaxCall();
});

function draw(response) {
  function UserShowTempChartSvg(response) {
        this.w = window.innerWidth;
        this.h = 450;
        this.maxDataPointsForDots = 500;
        this.transitionDuration = 1000;
        this.violations = 0;
        this.margin = 40;
        this.pointRadius = 4;
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
        this.dataLinesGroup = this.setDataLinesGroup();
        this.dataLines = this.setDataLines();
        this.line = null;
        this.garea = null;
        this.$fillArea = null;
        this.circles = null;
      }

  // Date constants
  UserShowTempChartSvg.prototype.DAYS = [ 'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday' ];
  UserShowTempChartSvg.prototype.MONTHS = [ "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE",
    "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER" ];

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

  UserShowTempChartSvg.prototype.setDataLinesGroup = function(){
    return this.svg.append('svg:g');
  };

  UserShowTempChartSvg.prototype.setDataLines = function(){
    return this.dataLinesGroup
      .selectAll('.data-line').data([this.data]);
  };
// creates the svg
  var chartProperties = new UserShowTempChartSvg(response);

// x ticks and labels gets placed first
// x ticks and labels
  var testXGroup = new UserShowTempChartXAxisGroup(chartProperties);
  testXGroup.addToChart();

// y ticks and labels gets placed second
// y ticks and labels
  var testYGroup = new UserShowTempChartYAxisGroup(chartProperties);
  testYGroup.addToChart();

// lines and labels gets placed third
// Draw the lines
  var testDataLinesGroup = new UserShowTempChartLine(chartProperties, { hasTransitions: true });
  testDataLinesGroup.addToChart();



  function createAreaClassForGroupArea(){
    chartProperties.dataLines
      .enter()
      .append('svg:path')
      .attr("class", "area");
  }
  createAreaClassForGroupArea();

  function setGroupArea(){
    chartProperties.garea = d3.svg.area()
      .interpolate("linear")
      .x(function(d) { return chartProperties.x(d.date); })
      .y0(chartProperties.h - chartProperties.margin * 2)
      .y1(function(d) { return chartProperties.y(d.outdoor_temp); });
  }
  setGroupArea();

  function addGroupArea(){
    d3.selectAll(".area").attr("d", chartProperties.garea(chartProperties.data));
    // move the area to the back of the graph
    chartProperties.$fillArea = $(".area");
    $("#d3-chart svg > g").prepend(chartProperties.$fillArea)
  }
  addGroupArea();

  function addViolationCountToLegend() {
    $("#violations span").text($("#violations span")
      .text().replace(/\d+/, chartProperties.violations));
  }
  addViolationCountToLegend();

  if (chartProperties.violations) {
  // Draw the circles if there are any violations
    function setDataCirclesGroup() {
      if (!chartProperties.dataCirclesGroup) {
        chartProperties.dataCirclesGroup = chartProperties.svg.append('svg:g');
      }
    }
    setDataCirclesGroup();

    function setCircles() {
      chartProperties.circles = chartProperties.dataCirclesGroup.selectAll('.data-point').data(chartProperties.data);
    }
    setCircles();

    function addCircles(){
      chartProperties.circles.enter()
        .append('svg:circle')
        .attr('class', 'data-point')
        .style('opacity', 1)
        .attr('cx', function(d) { return chartProperties.x(d.date) })
        .attr('cy', function() { return chartProperties.y(0) })
        .attr('r', function(d) {
          return d.violation ? chartProperties.pointRadius : 0;
        })
        .transition()
        .duration(chartProperties.transitionDuration)
        .style('opacity', 1)
        .attr('cx', function(d) { return chartProperties.x(d.date) })
        .attr('cy', function(d) { return chartProperties.y(d.temp) });
    }
    addCircles();

  }

  function legalMinimumFor(reading){
    if(reading.isDay === true){
      return '68';
    }else{
      return '55';
    }
  }

  function getCivilianTime(reading){
    if (reading.getHours() > 12){
      return (reading.getHours() - 12) + ":"
        + (reading.getMinutes() >= 10 ?
          reading.getMinutes() : "0" + reading.getMinutes())
        + " PM";
    }else{
      return reading.getHours() + ":"
        + (reading.getMinutes() >= 10 ?
          reading.getMinutes() : "0" + reading.getMinutes())
        + " AM";
    }
  }

  // only add tooltips if it is not a live demo
  if(!/live_update/.test(document.URL)){
    $('svg circle').tipsy({
      gravity: 's',
      html: true,
      topOffset: 2.8,
      leftOffset: 0.3,
      opacity: 1,
      title: function() {
        var d = this.__data__;
        var pDate = d.date;
        return pDate.getDate() + ' '
          + chartProperties.MONTHS[pDate.getMonth()] + ' '
          + pDate.getFullYear() + '<br>'
          + chartProperties.DAYS[ pDate.getDay() ] + ' at '
          + getCivilianTime(pDate) + '<br>'
          + '<i>Temperature in Violation</i><br>'
          + '<br>Temperature in Apt: ' + d.temp + '°'
          + '<br>Temperature Outside: ' + d.outdoor_temp + '°'
          + '<br>Legal minimum: ' + legalMinimumFor(d) + '°';
      }
    });
  }
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
  }else{
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
