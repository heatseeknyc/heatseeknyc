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
    .attr('width', (this.width - this.margin.left))
    .attr('height', (this.height - this.margin.top))
    .attr('transform', 'translate(' + this.margin.left + ',0)')
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

////////// new constructor ////////////

// Line focus element

function ComplaintsChartFocusLine(rectObj){
  this.svg = rectObj.svg;
  this.margin = rectObj.margin;
  this.height = rectObj.height;
  this.xScale = rectObj.xScale;
  this.data = rectObj.data['BRONX'];
  // private properties
  this._el = this.drawFocusLine();
  this._$date = $('span#complaint-date');
}

ComplaintsChartFocusLine.prototype.ABBREVIATED_MONTHS = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];

ComplaintsChartFocusLine.prototype.style = function(prop, value){
  this._el.style(prop, value);
};

ComplaintsChartFocusLine.prototype.drawFocusLine = function(){
  return this.svg
    .append('line')
    .attr('id', 'focus')
    .attr('y2', (this.height - this.margin.top))
    .attr('x2', 0);
};

ComplaintsChartFocusLine.prototype.update = function(index){
  this._$date.text( this._findDate(index) );
  this._el.attr('transform', 'translate('
    + this._calcLeftNum(index)
    + ', ' + this.margin.bottom + ')'
  );
};

// private methods
ComplaintsChartFocusLine.prototype._calcLeftNum = function(index){
  return this.xScale(this.data[index].date) + this.margin.left;
};

ComplaintsChartFocusLine.prototype._findDate = function(index){
  var date = this.data[index].date;
  return this.ABBREVIATED_MONTHS[date.getMonth()] 
    + ' ' + date.getFullYear();
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
  // private properties
  this._el = this.drawFocusCircle();
  this._$total = $('span.' + this.borough + ' .total');
}

ComplaintsChartFocusCircle.prototype.style = function(prop, value){
  this._el.style(prop, value);
};

ComplaintsChartFocusCircle.prototype.drawFocusCircle = function(){
  return this.svg.append('circle')
    .attr('class', this.borough)
    .attr('r', 4);
};

ComplaintsChartFocusCircle.prototype.update = function(index){
  var leftNum = this._calcLeftNum(index),
        upNum = this._calcUpNum(index);

  this._$total.text( this.data[index].total );
  this._el.attr('transform',
      'translate(' + leftNum + ',' + upNum + ')');
};

// private methods
ComplaintsChartFocusCircle.prototype._calcLeftNum = function(index){
  return this.xScale(this.data[index].date) + this.margin.left;
};

ComplaintsChartFocusCircle.prototype._calcUpNum = function(index){
  return this.yScale(this.data[index].total) + this.margin.bottom;
};