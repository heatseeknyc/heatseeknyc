function UserShowTempChartAreaGroup(svgObj, optionsObj){
  this.svg = svgObj.svg;
  this.x = svgObj.x;
  this.y = svgObj.y;
  this.h = svgObj.h;
  this.margin = svgObj.margin;
  this.data = svgObj.data;
  this.dataAreaGroup = this.svg.append('svg:g');
  this.dataLines = this.setDataLines();
  this.areaDrawer = this.setAreaDrawer();
}

UserShowTempChartAreaGroup.prototype.setDataLines = function(){
  return this.dataAreaGroup
    .selectAll('.data-line').data([this.data]);
};

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
};

UserShowTempChartAreaGroup.prototype.addToChart = function(){
  this.createAreaEl();
  this.drawGroupArea();
};
