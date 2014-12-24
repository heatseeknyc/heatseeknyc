function ComplaintsChartYAxis(svgObj){
  this.data = svgObj.data;
  this.width = svgObj.width;
  this.margin = svgObj.margin;
  this.svg = svgObj.svg;
  this.yScale = svgObj.yScale;
  this.yAxis = this._setYAxis();
};

ComplaintsChartYAxis.prototype.addToChart = function(){
  this.svg.append('g')
    .attr('class', 'y-ticks')
    .call(this.yAxis)
    .call(this._positionYText)
    .attr('transform', 'translate('
      + this.margin.left + ', ' + this.margin.bottom + ')'
    );
};

// private methods
ComplaintsChartYAxis.prototype._setYAxis = function(){
  return d3.svg.axis()
    .scale(this.yScale)
    .orient('left')
    .tickSize(-this.width + this.margin.left)
    .tickPadding(0)
    .ticks(5);
};

ComplaintsChartYAxis.prototype._positionYText = function(g){
  g.selectAll('text').attr('dy', -4).attr('x', -30);
};