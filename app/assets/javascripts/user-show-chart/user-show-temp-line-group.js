function UserShowTempChartLine(svgObj, optionsObj) {
  this.data = svgObj.data;
  this.svg = svgObj.svg;
  this.x = svgObj.x;
  this.y = svgObj.y;
  // this code is repeated to create a
  // clean element for the charts
  this.dataLineGroup = this.svg.append('svg:g');
  this.dataLine = this.setDataLine();
  this.transitionDuration = optionsObj.transitionDuration || 1000;
  this.hasTransitions = optionsObj.hasTransitions || false;
  this.lineDrawer = this.setLineDrawer();
}

UserShowTempChartLine.prototype.setDataLine = function(){
  return this.dataLineGroup
    .selectAll('.data-line').data([this.data]);
};

UserShowTempChartLine.prototype.setLineDrawer = function(){
  var self = this;
  return d3.svg.line().x(function(d,i) {
    return self.x(d.date);
  }).y(function(d) {
    return self.y(d.temp);
  }).interpolate('linear');
};

UserShowTempChartLine.prototype.drawDataLineWithoutTransitions = function() {
  this.dataLine.enter().append('path')
    .attr('class', 'data-line')
    .attr('d', this.lineDrawer(this.data));
};

UserShowTempChartLine.prototype.drawDataLineWithTransitions = function() {
  this.data.forEach(function(currentDataPoint, i) {
    if(i < this.data.length - 1) {
      var nextDataPoint = this.data[i + 1];
      var line = this.dataLine.enter().append('path')
        .attr('class', 'data-line')
        .style('opacity', 0.3)
        .attr('d', this.lineDrawer([currentDataPoint, nextDataPoint]))
        .transition()
        .delay(this.transitionDuration / 2)
        .duration(this.transitionDuration)
        .style('opacity', 1);
      if (nextDataPoint.date - currentDataPoint.date > 3600000) {
        line.style('stroke', 'gray');
      }
    }
  }.bind(this));
};

UserShowTempChartLine.prototype.addToChart = function(){
  if ( this.hasTransitions ) {
    this.drawDataLineWithTransitions();
  } else {
    this.drawDataLineWithoutTransitions();
  }
};
