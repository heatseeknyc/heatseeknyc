function UserShowTempChartSvg(dataObj, violationCount, optionsObj) {
  this.data = dataObj;
  this.width = window.innerWidth;
  this.height = optionsObj.height;
  this.margin = optionsObj.margin;
  this.optionsObj = optionsObj;
  this.violations = violationCount;
  this.x = this.setX();
  this.y = this.setY();
  this.svg = this.setSvg();
}

UserShowTempChartSvg.prototype.setX = function(){
  this.endDate = moment().startOf('hour');
  this.startDate = moment(this.endDate).subtract(1, 'week');

  return d3.time.scale()
    .range([0, this.width - this.margin * 2])
    .domain([
      this.startDate.toDate(),
      this.endDate.toDate()
    ]);
};

UserShowTempChartSvg.prototype.setY = function(){
  var startDate = this.startDate
  var hasHighTemp = this.data.filter(function(d) {
    return moment(d.created_at).isAfter(startDate)
  }).some(function(d) {
    return d.temp >= 80
  })
  debugger
  var max = hasHighTemp ? 100 : 80;

  return d3.scale.linear()
    .range([this.height - this.margin * 2, 0])
    .domain([0, max]);
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
