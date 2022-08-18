function UserShowTempChartSvg(dataObj, violationCount, optionsObj) {
  this.data = dataObj;
  this.width = window.innerWidth;
  this.height = optionsObj.height;
  this.margin = optionsObj.margin;
  //How many days we want graph to span
  this.length_days = optionsObj.length_days;
  //How many days ago the end day was
  this.end_days_ago = optionsObj.end_days_ago;
  this.optionsObj = optionsObj;
  this.violations = violationCount;
  //TODO: input/outpyt
  this.x = this.setX();
  this.y = this.setY();
  this.svg = this.setSvg();
}

//TODO: input/outpyt
UserShowTempChartSvg.prototype.setX = function(){
  this.endDate = moment().startOf('hour')//.subtract(this.end_days_ago, 'day');
  this.startDate = moment(this.endDate).subtract(1, 'week');
  //this.startDate = moment(this.endDate).subtract(this.length_days, 'day');

  return d3.time.scale()
    .range([0, this.width - this.margin * 2])
    .domain([
      this.startDate.toDate(),
      this.endDate.toDate()
    ]);
};

UserShowTempChartSvg.prototype.setY = function(){
  var startDate = this.startDate
  var filteredData = this.data.filter(function(d) {
    return moment(d.created_at).isAfter(startDate)
  })
  var hasHighTemp = filteredData.some(function(d) { return d.temp >= 80 })
  var hasLowTemp = filteredData.some(function(d) { return d.temp <= 0 })
  var max = hasHighTemp ? 100 : 80;
  var min = hasLowTemp ? -20 : 0;

  return d3.scale.linear()
    .range([this.height - this.margin * 2, 0])
    .domain([min, max]);
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
