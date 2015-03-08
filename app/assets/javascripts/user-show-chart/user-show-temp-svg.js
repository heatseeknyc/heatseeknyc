function UserShowTempChartSvg(dataObj, violationCount, optionsObj) {
  this.data = dataObj;
  this.width = window.innerWidth;
  this.height = optionsObj.height;
  this.margin = optionsObj.margin;
  this.optionsObj = optionsObj;
  this.violations = violationCount;
  this.max = this.setMax();
  this.min = this.setMin();
  this.x = this.setX();
  this.y = this.setY();
  this.svg = this.setSvg();
}

UserShowTempChartSvg.prototype.setX = function(){
  return d3.time.scale()
    .range([0, this.width - this.margin * 2])
    .domain([
      this.data[0].date, 
      this.data[this.data.length - 1].date
    ]);
};

UserShowTempChartSvg.prototype.setY = function(){
  return d3.scale.linear()
    .range([this.height - this.margin * 2, 0])
    .domain([this.min, this.max]);
};

UserShowTempChartSvg.prototype.setMax = function(){
  return d3.max(
    this.data, 
    function(d) { 
      return Math.max( d.temp, d.outdoor_temp )
    }) + 1;
};

UserShowTempChartSvg.prototype.setMin = function() {
  if ( d3.min(this.data, function(d) { return d.outdoor_temp }) ){
    return d3.min(
      this.data, 
      function(d) { 
        return Math.min( d.temp )
      }) - 5;
  } else {
    return d3.min(
      this.data,
      function(d) { 
        return Math.min( d.temp, d.outdoor_temp ) 
      }) - 10;
  }
};

UserShowTempChartSvg.prototype.setSvg = function(){
  return d3.select('#d3-chart')
    .append('svg:svg')
    .attr('width', this.width)
    .attr('height', this.height)
    .attr('class', 'viz')
    .append('svg:g')
    .attr('transform', 'translate(' + this.margin + ',' + this.margin + ')');
};

UserShowTempChartSvg.prototype.addChartElements = function(){
  // area is placed first behind all other elements
  var groupArea = new UserShowTempChartAreaGroup(this, this.optionsObj);
    groupArea.addToChart();
  // x ticks and labels gets placed first
  var xGroup = new UserShowTempChartXAxisGroup(this, this.optionsObj);
    xGroup.addToChart();
  // y ticks and labels gets placed second
  var yGroup = new UserShowTempChartYAxisGroup(this, this.optionsObj);
    yGroup.addToChart();
  // lines and labels gets placed third
  var dataLinesGroup = new UserShowTempChartLine(this, this.optionsObj);
    dataLinesGroup.addToChart();
  // circles and labels are placed fourth
  var circles = new UserShowTempChartCircles(this, this.optionsObj);
    circles.addToChart();
};