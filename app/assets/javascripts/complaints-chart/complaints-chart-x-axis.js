function ComplaintsChartXAxis(svgObj){
  this.data = svgObj.data;
  this.height = svgObj.height;
  this.margin = svgObj.margin;
  this.svg = svgObj.svg;
  this.xScale = svgObj.xScale;
  this.xAxis = this._setXAxis();
};

ComplaintsChartXAxis.prototype.addToChart = function(){
  this.svg.append('g')
    .attr('class', 'x-ticks')
    .call(this.xAxis)
    .attr('transform', 
      'translate(' 
      + this.margin.left + ',' 
      + (this.height - this.margin.top + this.margin.bottom) + ')'
    );
};

// private methods
ComplaintsChartXAxis.prototype._setXAxis = function(){
  return d3.svg.axis()
    .scale(this.xScale)
    .ticks(d3.time.years)
    .tickSize(6, 0)
    .orient('bottom');
};