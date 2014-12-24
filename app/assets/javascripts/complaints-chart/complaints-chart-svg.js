function ComplaintsChartSvg(data){
  this.data = data;
  var $chart = $('#borough-complaints');
  this.margin = {top: 20, right: 5, bottom: 5, left: 30};
  this.height = $chart.height();
  this.width = $chart.width();
  this.svg = this._setSvg();
  this.xScale = this._setXScale();
  this.yScale = this._setYScale();
}

ComplaintsChartSvg.prototype.addChartElements = function(){
  var xAxisGroup = new ComplaintsChartXAxis(this);
  xAxisGroup.addToChart();

  var yAxisGroup = new ComplaintsChartYAxis(this);
  yAxisGroup.addToChart();

  var lineGroups = new ComplaintsChartLineGroup(this);
  lineGroups.addToChart();

  var focusGroups = new ComplaintsChartMouseOverRectangle(this);
  focusGroups.addToChart();
};

// private methods
ComplaintsChartSvg.prototype._setSvg = function(){
  return d3.select('#borough-complaints')
    .append('svg')
    .attr('width', this.width + this.margin.right)
    .attr('height', this.height + this.margin.bottom)
    .append('g')
    .attr('class', 'outter-group');
};

ComplaintsChartSvg.prototype._setXScale = function(){
  var maxDate = ComplaintsChartHelper.setMinOrMax('max', this.data, function(d){
      return d.date; 
    }),
    minDate = ComplaintsChartHelper.setMinOrMax('min', this.data, function(d){
        return d.date;
    });

  return d3.time.scale()
    .range([0, (this.width - this.margin.left)])
    .domain(
      [minDate, maxDate]
    );
};

ComplaintsChartSvg.prototype._setYScale = function(){
  var maxTotal = ComplaintsChartHelper.setMinOrMax('max', this.data, function(d){ 
      return d.total + 10; 
    }),
      minTotal = ComplaintsChartHelper.setMinOrMax('min', this.data, function(d){
      return d.total - 10; 
    });
  
  return d3.scale.linear()
    .range([0, (this.height - this.margin.top)])
    .domain(
      [maxTotal, minTotal]
    );
};