// rectangle for mouse over effects
function ComplaintsChartMouseOverRectangle(svgObj){
  this.svg = svgObj.svg;
  this.height = svgObj.height;
  this.width = svgObj.width;
  this.margin = svgObj.margin;
  this.data = svgObj.data;
  this.xScale = svgObj.xScale;
  this.yScale = svgObj.yScale;
  this.line = null;
  this.circles = [];
  this.BOROUGHS = ['BROOKLYN', 'BRONX', 'MANHATTAN', 'QUEENS', 'STATEN ISLAND'];
}

ComplaintsChartMouseOverRectangle.prototype.addToChart = function(){
  var index = this.data['BRONX'].length - 1;
  this._addFocusElements();
  this.line.update(index);
  this._updateCircles(index);
  this.drawRect();
};

ComplaintsChartMouseOverRectangle.prototype.drawRect = function(){
  var self = this;
  this.svg.append('svg:rect')
    .attr('id', 'mouse-effects')
    .attr('width', (this.width - this.margin.left - this.margin.right))
    .attr('height', (this.height - this.margin.top))
    .attr('transform', 'translate(' + (this.margin.left + this.margin.right)+ ',0)')
    .style('pointer-events', 'all')
    .on('mouseover', function(){ self.line.style('display', 'inherit'); })
    .on('mouseout', function(){ self.line.style('display', 'none'); })
    .on('mousemove', function(){
      self._mouseMove(this);
    });
};

// private methods
ComplaintsChartMouseOverRectangle.prototype._addFocusElements = function(){  
  if( !this.line && !this.circles.length ){    
    this._createFocusLine();
    this._createFocusCircles();
  }
};

ComplaintsChartMouseOverRectangle.prototype._createFocusLine = function(){
  this.line = new ComplaintsChartFocusLine(this);
};

ComplaintsChartMouseOverRectangle.prototype._createFocusCircles = function(){
  var self = this;
  this.BOROUGHS.forEach(function(borough){
    self.circles.push( new ComplaintsChartFocusCircle(self, borough) );
  });
};

ComplaintsChartMouseOverRectangle.prototype._mouseMove = function(el){
  var index = this._findIndex(el);

  this.line.update(index);
  this._updateCircles(index);
};

ComplaintsChartMouseOverRectangle.prototype._findIndex = function(el){
  var xPosition = this.xScale.invert(d3.mouse(el)[0]),
    rightIndex = this._bisectDate(this.data['BRONX'], xPosition, 1),
    leftIndex = rightIndex - 1
    leftDatum = this.data['BRONX'][leftIndex],
    rightDaturm = this.data['BRONX'][rightIndex];

  return xPosition - leftDatum.date 
    > rightDaturm.date - xPosition
    ? rightIndex : leftIndex;
};

ComplaintsChartMouseOverRectangle.prototype._updateCircles = function(index){
  this.circles.forEach(function(circle){
    circle.update(index);
  });
};

ComplaintsChartMouseOverRectangle.prototype._bisectDate = d3.bisector(
  function(d) { return d.date; }
).left;