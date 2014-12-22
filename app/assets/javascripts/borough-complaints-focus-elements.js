// rectangle for mouse over effects
function ComplaintsChartMouseOverRectangle(svgObj){
  this.svg = svgObj.svg;
  this.height = svgObj.height;
  this.width = svgObj.width;
  this.margin = svgObj.margin;
  this.data = svgObj.data;
  this.xScale = svgObj.xScale;
  this.yScale = svgObj.yScale;
}

ComplaintsChartMouseOverRectangle.prototype.addFocusElements = function(){  
  this.drawFocusLine();
  this.drawFocusCircle();
};

ComplaintsChartMouseOverRectangle.prototype.addToChart = function(){
  var self = this;
  this.addFocusElements();
  this.svg.append('svg:rect')
    .attr('id', 'mouse-effects')
    .attr('width', (this.width - this.margin.left))
    .attr('height', (this.height - this.margin.top))
    .attr('transform', 'translate(' + this.margin.left + ',' + this.margin.top + ')')
    .style('pointer-events', 'all')
    .on('mouseover', function(){ d3.select('line#focus, circle.y').style('display', 'inherit'); })
    .on('mouseout', function(){ d3.select('line#focus, circle.y').style('display', 'none'); })
    .on('mousemove', function(){
      self.mouseMove(this);
    });
};

ComplaintsChartByBorough.prototype.mouseMove = function(el){
  var x0 = this.xScale.invert(d3.mouse(el)[0]),
    i = this._bisectDate(this.data['BRONX'], x0, 1),
    d0 = this.data['BRONX'][i - 1],
    d1 = this.data['BRONX'][i],
    d = x0 - d0.date > d1.date - x0 ? d1 : d0;

  d3.select('line#focus')
    .attr('transform',
      'translate(' + (this.xScale(d.date) + this.margin.left) + ', 0)');
      
  d3.select('circle.y')
    .attr('transform',
      'translate(' + (this.xScale(d.date) + this.margin.left) + ',' + this.yScale(d.total) + ')');
};

// focus elements
ComplaintsChartByBorough.prototype.drawFocusLine = function(){
  return this.svg.append('g')
    .append('line')
    .attr('id', 'focus')
    .attr('y2', (this.height - this.margin.top))
    .attr('x2', 0)
};

function ComplaintsChartFocusCirlce(rectObj){
  this.svg = rectObj.svg;
  this.xScale = rectObj.xScale;
  this.yScale = rectObj.yScale;
}

ComplaintsChartFocusCirlce.prototype.drawFocusCircle = function(borough){
  return this.svg.append('circle')
    .attr('class', borough)
    .attr('r', 4)
};

// private methods
ComplaintsChartMouseOverRectangle.prototype._bisectDate = d3.bisector(
  function(d) { return d.date; }
).left;