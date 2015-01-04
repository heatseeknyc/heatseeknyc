function ComplaintsChartXAxis(svgObj){
  this.data = svgObj.data;
  this.height = svgObj.height;
  this.width = svgObj.width;
  this.margin = svgObj.margin;
  this.svg = svgObj.svg;
  this.xScale = svgObj.xScale;
  this.xAxis = this._setXAxis();
};

ComplaintsChartXAxis.prototype.addToChart = function(){
  this._drawXAxis();
  this._rotateTicks();
  this._drawLabel();
};

// private methods
ComplaintsChartXAxis.prototype._setXAxis = function(){
  return d3.svg.axis()
    .scale(this.xScale)
    .ticks(d3.time.months)
    .tickSize(6, 0)
    .orient('bottom');
};

ComplaintsChartXAxis.prototype._leftOffSet = function(){
  var complaints = this.data["BRONX"],
    length = complaints.length,
    firstDatePosition = this.xScale(complaints[0].date),
    lastDatePosition = this.xScale(complaints[length - 1].date);
  return (firstDatePosition + lastDatePosition) / length;
};

ComplaintsChartXAxis.prototype._rotateTicks = function(){
  d3.selectAll('.x-ticks text').attr('transform', 'rotate(45)');
};

ComplaintsChartXAxis.prototype._drawLabel = function(){
  var margin = this.margin;
  this.svg.append('text')
    .attr('x', (this.width / 2) +  margin.right)
    .attr('y', this.height - 10 + margin.top)
    .text('Date')
    .attr('class', 'labels');
};

ComplaintsChartXAxis.prototype._drawXAxis = function(){
  var margin = this.margin;
  this.svg.append('g')
    .attr('class', 'x-ticks')
    .call(this.xAxis)
    .attr('transform', 
      'translate(' 
      + (margin.left + this._leftOffSet() + this.margin.right) + ',' 
      + (this.height - margin.top - margin.bottom + margin.heightFix) + ')'
    );
};