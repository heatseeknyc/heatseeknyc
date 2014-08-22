function UserTempChart(){
  width: 900,
  height: 450,
  maxDataPointsForDots: 500,
  transitionDuration: 1000,
  svg: setSvg(),
  yAxisGroup: null,
  xAxisGroup: null,
  dataCirclesGroup: null,
  dataLinesGroup: null,
  data: this.createDataFrom(response),
  margin: 40,
  max: this.setChartMax(),
  min: this.setChartMin(),
  pointRadius: 4,
  x: setXValue(),
  y: setYValue(),
  xAxis: setXAxisValues(),
  yAxis: setYAxisValues(),
  t: null,
  circles: null,
  dataCirclesGroup: null,
  garea: null
}

UserTempChart.prototype.setChartMax = function() {
  return d3.max(this.data, function(d) { return d.temp }) + 10;
};

UserTempChart.prototype.setChartMin = function() {
  return d3.min(this.data, function(d) { return d.temp }) - 10;
};

UserTempChart.prototype.setXValue = function() {
  return d3.time.scale().range([0, this.width - this.margin * 2])
    .domain([this.data[0].date, this.data[this.data.length - 1].date]);
};

UserTempChart.prototype.setYValue = function() {
  return d3.scale.linear().range([this.height - this.margin * 2, 0])
    .domain([this.min, this.max]);
};

UserTempChart.prototype.setXAxisValues = function() {
  return d3.svg.axis().scale(this.x).tickSize(this.h - this.margin * 2)
    .tickPadding(0).ticks(this.data.length);
};

UserTempChart.prototype.setYAxisValues = function() {
  return d3.svg.axis().scale(this.y).orient('left')
    .tickSize(-this.w + this.margin * 2).tickPadding(10);
};

UserTempChart.prototype.createDataFrom = function(ajaxResponse) {
  ajaxResponse.forEach(function(obj){
    obj.date = new Date(obj.created_at);
    obj.isDay = obj.date.getHours() >= 6 && obj.date.getHours() <= 22;
  });
  return ajaxResponse;
};

UserTempChart.prototype.setSvg = function() {
  return d3.select('#d3-chart').select('svg').select('g');
};

UserTempChart.prototype.addStylingToSvg = function() {
  if (this.svg.empty()) {
    this.svg = d3.select('#d3-chart')
      .append('svg:svg')
      .attr('width', w)
      .attr('height', h)
      .attr('class', 'viz')
      .append('svg:g')
      .attr('transform', 'translate(' + this.margin + ',' + this.margin + ')');
  }
};

UserTempChart.prototype.setT = function() {
  return svg.transition().duration(this.transitionDuration);
};
// We don't actually use this method for the graph but we might need it later
UserTempChart.prototype.setYTicksAndLabels = function() {
  if (!this.yAxisGroup) {
    this.yAxisGroup = this.svg.append('svg:g')
      .attr('class', 'yTick')
      .call(this.yAxis);
  }
  else {
    this.t.select('.yTick').call(this.yAxis);
  }
};
// This method needs to be altered to so that the stroke-width is dynamic
UserTempChart.prototype.addVerticalLineStlying = function() {
  var $lines = $(".tick line"),
      length = data.length;

  for(var i = 0; i < length; i++){
    if(data[i].isDay === true){
      $($lines[i]).attr({'stroke': '#83A2AA', 'stroke-width': 4.5});
      if(i === 0){$($lines[i]).attr({'stroke-width': 12});}
    }else{
      $($lines[i]).attr({'stroke': '#535F62', 'stroke-width': 4.5});
      if(i === 0){$($lines[i]).attr({'stroke-width': 12});}
    }
  }
};

UserTempChart.prototype.setXTicksAndLabels = function() {
  if (!this.xAxisGroup) {
    this.xAxisGroup = svg.append('svg:g')
      .attr('class', 'xTick')
      .call(this.xAxis);
    this.addVerticalLineStlying();
  }
  else {
    this.t.select('.xTick').call(this.xAxis);
  }
};

UserTempChart.prototype.setDataLinesGroup = function() {
  if (!this.dataLinesGroup) {
    this.dataLinesGroup = svg.append('svg:g');
  }
};

UserTempChart.prototype.setDataLines = function() {
  this.dataLines = dataLinesGroup.selectAll('.data-line').data([data]);
};

UserTempChart.prototype.setLine = function() {
  this.line = d3.svg.line()
    .x(function(d,i) {
      return this.x(d.date); 
    })
    .y(function(d) {
      return this.y(d.temp); 
    })
    .interpolate("linear");
};

UserTempChart.prototype.setGArea = function() {
  this.garea = d3.svg.area()
    .interpolate("linear")
    .x(function(d) { 
      return this.x(d.date); 
    })
    .y0(this.h - this.margin * 2)
    .y1(function(d) { 
      return this.y(d.temp); 
    });
};

UserTempChart.prototype.addGAreaToDataLines = function() {
  this.dataLines
    .enter()
    .append('svg:path')
    .attr("class", "area")
    .attr("d", this.garea(this.data));
};

UserTempChart.prototype.addStylesAndOpacityToDataLines = function() {
  this.dataLines.enter().append('path')
    .attr('class', 'data-line')
    .style('opacity', 0.3)
    .attr("d", line(data))
    .transition()
    .delay(this.transitionDuration / 2)
    .duration(this.transitionDuration)
    .style('opacity', 1);
    // this adds extra styles we're not using now.
    // .attr('x1', function(d, i) { return (i > 0) ? this.xScale(this.data[i - 1].date) : this.xScale(d.date); })
    // .attr('y1', function(d, i) { return (i > 0) ? this.yScale(this.data[i - 1].temp) : this.yScale(d.temp); })
    // .attr('x2', function(d) { return this.xScale(d.date); })
    // .attr('y2', function(d) { return this.yScale(d.temp); });
};


UserTempChart.prototype.drawChart = function() {
  // this delegates all helpers methods
};

UserTempChart.prototype.addStylingToDataLines = function() {
  this.dataLines.exit()
    .transition()
    .attr("d", line)
    .duration(transitionDuration)
    .attr("transform", function(d) { return "translate(" + x(d.date) + "," + y(0) + ")"; })
    .style('opacity', 1e-6)
    .remove();
};

UserTempChart.prototype.selectArea = function() {
  d3.selectAll(".area").transition()
    .duration(transitionDuration)
    .attr("d", garea(data));
};

UserTempChart.prototype.drawDataCircles = function() {
  if (!this.dataCirclesGroup) {
    this.dataCirclesGroup = svg.append('svg:g');
  }
};

UserTempChart.prototype.circles = function() {
  this.circles = dataCirclesGroup.selectAll('.data-point').data(this.data);
};

UserTempChart.prototype.days = [
  'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'
];

class_name.prototype.monthNames = [ 
  "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE",
  "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"
];

UserTempChart.prototype.placeCirclesOnLine = function() {
  this.circles.enter()
    .append('svg:circle')
    .attr('class', 'data-point')
    .style('opacity', 1)
    .attr('cx', function(d) { return x(d.date) })
    .attr('cy', function() { return y(0) })
    .attr('r', function(d) {
      return d.violation ? pointRadius : 0;
    })
    .transition()
    .duration(transitionDuration)
    .style('opacity', 1)
    .attr('cx', function(d) { 
      return x(d.date) 
    })
    .attr('cy', function(d) { return y(d.temp) });
};

UserTempChart.prototype.exitAndRemoveCircles = function() {
  this.circles
    .exit()
    .transition()
    .duration(transitionDuration)
    .attr('cy', function() { return y(0) })
    .style("opacity", 1e-6)
    .remove();
};

UserTempChart.prototype.legalMinimumFor = function(reading) {
  if(reading.isDay === true){
    return '68';
  }else{
    return '55';
  }
};

UserTempChart.prototype.getCivilianTime = function(reading) {
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
};

UserTempChart.prototype.createTipsyMouseOver = function() {
  $('svg circle').tipsy({ 
    gravity: 's',
    html: true,
    topOffset: 2.8,
    leftOffset: 3.8,
    title: function() {
      var d = this.__data__;
      var pDate = d.date;
      return pDate.getDate() + ' '
        + this.monthNames[pDate.getMonth()] + ' '
        + pDate.getFullYear() + '<br>'
        + this.days[ pDate.getDay() ] + ' at '
        + this.getCivilianTime(pDate) + '<br>'
        + '<i>Temperature in Violation</i><br>'
        + '<br>Temperature in Apt: ' + d.temp + '°'
        + '<br>Temperature Outside: ' + d.outdoor_temp + '°'
        + '<br>Legal minimum: ' + this.legalMinimumFor(d) + '°';
    }
  });
};