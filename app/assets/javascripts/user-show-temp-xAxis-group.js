function UserShowTempChartXAxisGroup(svgObj) {
  this.data = svgObj.data;
  this.svg = svgObj.svg;
  this.margin = svgObj.margin;
  this.h = svgObj.h;
  this.x = svgObj.x;
  this.xAxis = this.setXAxis();
  this.strokeWidth = svgObj.w / this.data.length;
}

UserShowTempChartXAxisGroup.prototype.ABBREVIATED_MONTHS = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];

UserShowTempChartXAxisGroup.prototype.setXAxis = function(){
  return d3.svg.axis().scale(this.x)
    .tickSize(this.h - this.margin * 2)
    .tickPadding(0).ticks(this.data.length);
};

UserShowTempChartXAxisGroup.prototype.addLineStlyingToXTicks = function(){
  var $lines = $(".xTick .tick line"),
      length = this.data.length,
      date,
      newText,
      $textEl;

  for(var i = 0; i < length; i++){
    if(this.data[i].isDay === false){
      $($lines[i]).attr(
        { 'stroke-width': this.strokeWidth, 'stroke': '#90ABB0' }
      );
      if(i === 0){
        $($lines[i]).attr({ 'stroke-width': this.strokeWidth * 1.9 });
      }
    }
    else {
      // add dates to bottom of graph
      if ( this.data[i].date.getHours() === 16 ) {
        date = this.data[i].date;
        newText = this.ABBREVIATED_MONTHS[date.getMonth()] + " "
          + date.getDate() + ", " + (date.getYear() + 1900);
        $textEl = $($(".xTick .tick text")[i]);
        $textEl.text(newText);
        $textEl.show();
        $textEl.attr({"x": -15, "y": 380});
      }
    }
  }
};

UserShowTempChartXAxisGroup.prototype.drawXAxisGroup = function(){
  this.svg.append('svg:g').attr('class', 'xTick').call(this.xAxis);
};

UserShowTempChartXAxisGroup.prototype.addToChart = function() {
  this.drawXAxisGroup();
  this.addLineStlyingToXTicks();
};
