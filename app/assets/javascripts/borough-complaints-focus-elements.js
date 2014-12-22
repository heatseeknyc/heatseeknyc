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
  this.BOROUGHS = ['BRONX', 'BROOKLYN', 'MANHATTAN', 'QUEENS', 'STATEN ISLAND'];
}

ComplaintsChartMouseOverRectangle.prototype.addToChart = function(){
  this._addFocusElements();
  this.drawRect();
};

ComplaintsChartMouseOverRectangle.prototype.drawRect = function(){
  var self = this;
  this.svg.append('svg:rect')
    .attr('id', 'mouse-effects')
    .attr('width', (this.width - this.margin.left))
    .attr('height', (this.height - this.margin.top))
    .attr('transform', 'translate(' + this.margin.left + ',' + this.margin.top + ')')
    .style('pointer-events', 'all')
    .on('mouseover', function(){ d3.select('line#focus').style('display', 'inherit'); })
    .on('mouseout', function(){ d3.select('line#focus').style('display', 'none'); })
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

  return xPosition - leftDatum.date > rightDaturm.date - xPosition ? rightIndex : leftIndex;
};

ComplaintsChartMouseOverRectangle.prototype._updateCircles = function(index){
  this.circles.forEach(function(circle){
    circle.update(index);
  });
};

ComplaintsChartMouseOverRectangle.prototype._bisectDate = d3.bisector(
  function(d) { return d.date; }
).left;

////////// new constructor ////////////

// Line focus element

function ComplaintsChartFocusLine(rectObj){
  this.svg = rectObj.svg;
  this.margin = rectObj.margin;
  this.height = rectObj.height;
  this.xScale = rectObj.xScale;
  this.data = rectObj.data['BRONX'];
  this.el = this.drawFocusLine();
}

ComplaintsChartFocusLine.prototype.drawFocusLine = function(){
  return this.svg.append('g')
    .append('line')
    .attr('id', 'focus')
    .attr('y2', (this.height - this.margin.top))
    .attr('x2', 0);
};

ComplaintsChartFocusLine.prototype.update = function(index){
  this.el.attr('transform',
      'translate(' + this._calcLeftNum(index) + ', 0)');
};

// private methods
ComplaintsChartFocusLine.prototype._calcLeftNum = function(index){
  return this.xScale(this.data[index].date) + this.margin.left;
};

////////// new constructor ////////////

// Circle focus elements
function ComplaintsChartFocusCircle(rectObj, borough){
  this.svg = rectObj.svg;
  this.margin = rectObj.margin;
  this.xScale = rectObj.xScale;
  this.yScale = rectObj.yScale;
  this.borough = borough.toLocaleLowerCase().replace(' ', '-');
  this.data = rectObj.data[borough];
  this.el = this.drawFocusCircle();
}

ComplaintsChartFocusCircle.prototype.drawFocusCircle = function(){
  return this.svg.append('circle')
    .attr('class', this.borough)
    .attr('r', 4);
};

ComplaintsChartFocusCircle.prototype.update = function(index){
  var leftNum = this._calcLeftNum(index),
        upNum = this._calcUpNum(index);

  this.el.attr('transform',
      'translate(' + leftNum + ',' + upNum + ')');
};

// private methods
ComplaintsChartFocusCircle.prototype._calcLeftNum = function(index){
  return this.xScale(this.data[index].date) + this.margin.left;
};

ComplaintsChartFocusCircle.prototype._calcUpNum = function(index){
  return this.yScale(this.data[index].total);
};