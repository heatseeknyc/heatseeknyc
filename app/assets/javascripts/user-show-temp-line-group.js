function UserShowTempChartLine(svgObj, optionsObj) {
  this.data = svgObj.data;
  this.svg = svgObj.svg;
  this.x = svgObj.x;
  this.y = svgObj.y;
  this.dataLines = svgObj.setDataLines();
  this.lineDrawer = this.setLineDrawer();
  this.transitionDuration = optionsObj.transitionDuration || 1000;
  this.hasTransitions = optionsObj.hasTransitions || false;
}

UserShowTempChartLine.prototype.setLineDrawer = function(){
  var self = this;
  return d3.svg.line().x(function(d,i) {
    return self.x(d.date);
  }).y(function(d) {
    return self.y(d.temp);
  }).interpolate("linear");
};

UserShowTempChartLine.prototype.drawDataLineWithoutTransitions = function() {
  this.dataLines.enter().append('path')
    .attr('class', 'data-line')
    .attr("d", this.lineDrawer(this.data));
};

UserShowTempChartLine.prototype.drawDataLineWithTransitions = function() {
  this.dataLines.enter().append('path')
    .attr('class', 'data-line')
    .style('opacity', 0.3)
    .attr("d", this.lineDrawer(this.data))
    .transition()
    .delay(this.transitionDuration / 2)
    .duration(this.transitionDuration)
    .style('opacity', 1);
};

UserShowTempChartLine.prototype.addToChart = function(){
  if ( this.hasTransitions ) {
    this.drawDataLineWithTransitions();
  } else {
    this.drawDataLineWithoutTransitions();
  }
};
