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