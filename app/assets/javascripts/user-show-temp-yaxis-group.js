function UserShowTempChartYAxisGroup(svgObj, optionsObj) {
  this.svg = svgObj.svg;
  this.width = svgObj.width;
  this.y = svgObj.y;
  this.margin = optionsObj.margin;
  this.yAxis = this.setYAxis();
}

UserShowTempChartYAxisGroup.prototype.addToChart = function(){
  this.svg.append('svg:g').attr('class', 'yTick').call(this.yAxis);
  // fixes x value for text
  $(".yTick .tick text").attr("x", "-5");
};

UserShowTempChartYAxisGroup.prototype.setYAxis = function(){
  return d3.svg.axis().scale(this.y)
    .orient('left').tickSize(-this.width + this.margin * 2)
    .tickPadding(0).ticks(5);
};
