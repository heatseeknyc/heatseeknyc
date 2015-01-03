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
  var margin = this.margin;
  this.svg.append('g')
    .attr('class', 'x-ticks')
    .call(this.xAxis)
    .attr('transform', 
      'translate(' 
      + (margin.left + this._leftOffSet() + this.margin.right) + ',' 
      + (this.height - margin.top - margin.bottom + margin.heightFix) + ')'
    );

  // text label for the x axis
  this.svg.append('text')
    .attr('x', (this.width / 2) +  margin.right)
    .attr('y', this.height - margin.bottom + margin.top)
    .text('Date (by months)')
    .attr('class', 'labels');
};

// private methods
ComplaintsChartXAxis.prototype._setXAxis = function(){
  return d3.svg.axis()
    .scale(this.xScale)
    .ticks(d3.time.years)
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