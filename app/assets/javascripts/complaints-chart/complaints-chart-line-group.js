function ComplaintsChartLineGroup(svgObj){
  this.data = svgObj.data;
  this.height = svgObj.height;
  this.width = svgObj.width;
  this.margin = svgObj.margin;
  this.svg = svgObj.svg;
  this.xScale = svgObj.xScale;
  this.yScale = svgObj.yScale;
  this.lineDrawer = this._setLineDrawer();
};

ComplaintsChartLineGroup.prototype._setLineDrawer = function(){
  var self = this;
  return d3.svg.line().x(function(d) {
    return self.xScale(d.date);
  }).y(function(d) {
    return self.yScale(d.total);
  }).interpolate('linear');
};

ComplaintsChartLineGroup.prototype.createDataLineGroup = function(){
  return this.svg.append('g')
    .attr('class', 'data-line-group')
    .attr('transform', 'translate(' 
      + (this.margin.left + this.margin.right) + ', ' + this.margin.heightFix + ')'
    )
    .selectAll('.data-line').data([this.data]);
};

ComplaintsChartLineGroup.prototype.addToChart = function() {
  for (var borough in this.data){
    if( this.data.hasOwnProperty(borough) ) {
      this.createDataLineGroup().enter().append('path')
        .attr('class', 
          'data-line ' + borough.toLocaleLowerCase().replace(' ', '-')
        )
        .attr('d', this.lineDrawer(this.data[borough]));
    }
  }
};