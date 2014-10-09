function UserShowTempChartAreaGroup(svgObj, optionsObj){
  this.x = svgObj.x;
  this.y = svgObj.y;
  this.h = svgObj.h;
  this.margin = svgObj.margin;
  this.data = svgObj.data;
  this.dataLines = svgObj.dataLines;
  this.areaDrawer = this.setAreaDrawer();
  // this.$fillArea = $(".area");
}

UserShowTempChartAreaGroup.prototype.createAreaEl = function(){
  this.dataLines
    .enter()
    .append('svg:path')
    .attr("class", "area");
};

UserShowTempChartAreaGroup.prototype.setAreaDrawer = function(){
  var self = this;
  return d3.svg.area()
    .interpolate("linear")
    .x(function(d) { return self.x(d.date); })
    .y0(self.h - self.margin * 2)
    .y1(function(d) { return self.y(d.outdoor_temp); });
};

UserShowTempChartAreaGroup.prototype.drawGroupArea = function(){
  d3.selectAll(".area").attr("d", this.areaDrawer(this.data));
  // move the area to the back of the graph
  // it seems like i dont need this as of right now...
  // $("#d3-chart svg > g").prepend(this.$fillArea);
};

UserShowTempChartAreaGroup.prototype.addToChart = function(){
  this.createAreaEl();
  this.drawGroupArea();
};
