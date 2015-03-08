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
    + ', ' + (this.margin.heightFix - this.margin.bottom) + ')'
  );
};

// private methods
ComplaintsChartFocusLine.prototype._calcLeftNum = function(index){
  return this.xScale(this.data[index].date) 
    + this.margin.left + this.margin.right;
};

ComplaintsChartFocusLine.prototype._findDate = function(index){
  var date = this.data[index].date;
  return this.ABBREVIATED_MONTHS[date.getMonth()] 
    + ' ' + date.getFullYear();
};