function UserShowTempChartCircles(svgObj, optionsObj){
  this.data = svgObj.data;
  this.svg = svgObj.svg;
  this.x = svgObj.x;
  this.y = svgObj.y;
  this.violations = svgObj.violations;
  this.circleRadius = optionsObj.circleRadius || 4;
  this.hasTransitions = optionsObj.hasTransitions || false;
  this.transitionDuration = optionsObj.transitionDuration || 1000;
  this.hasToolTips = optionsObj.hasToolTips || false;
  this.dataCirclesGroup = this.setDataCirclesGroup();
  this.dataCircles = this.setDataCircles();
};

UserShowTempChartCircles.prototype.setDataCirclesGroup = function(){
  return this.svg.append('svg:g');
};

UserShowTempChartCircles.prototype.setDataCircles = function(){
  return this.dataCirclesGroup
    .selectAll('.data-point')
    .data(this.data);
};

UserShowTempChartCircles.prototype.addCirclesWithTransitions = function(){
  var self = this;
  self.dataCircles.enter()
    .append('svg:circle')
    .attr('class', 'data-point')
    .style('opacity', 1)
    .attr('cx', function(d) { return self.x(d.date) })
    .attr('cy', function() { return self.y(0) })
    .attr('r', function(d) {
      return d.violation ? self.circleRadius : 0;
    })
    .transition()
    .duration(self.transitionDuration)
    .style('opacity', 1)
    .attr('cx', function(d) { return self.x(d.date) })
    .attr('cy', function(d) { return self.y(d.temp) });
};

UserShowTempChartCircles.prototype.addCirclesWithoutTransitions = function(){
  var self = this;
  self.dataCircles.enter()
    .append('svg:circle')
    .attr('class', 'data-point')
    .attr('cx', function(d) { return self.x(d.date) })
    .attr('cy', function(d) { return self.y(d.temp) })
    .attr('r', function(d) {
      return d.violation ? self.circleRadius : 0;
    });
};

UserShowTempChartCircles.prototype.addToolTips = function(){
  if ( this.hasToolTips ) {
    var toolTips = new UserShowTempChartToolTips;
    toolTips.addToChart();
  }
};

UserShowTempChartCircles.prototype.addToChart = function (){
  if ( this.violations ) {
    if ( this.hasTransitions ) {
      this.addCirclesWithTransitions();
    } else {
      this.addCirclesWithoutTransitions();
    }
    this.addToolTips();
  }
};