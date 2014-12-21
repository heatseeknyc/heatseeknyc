var someDataObj = JSON.parse("{\"BRONX\":[{\"date\":\"2010-01-01T00:00:00Z\",\"total\":3717},{\"date\":\"2010-02-01T00:00:00Z\",\"total\":2545},{\"date\":\"2010-03-01T00:00:00Z\",\"total\":1953},{\"date\":\"2010-04-01T00:00:00Z\",\"total\":1071},{\"date\":\"2010-05-01T00:00:00Z\",\"total\":802},{\"date\":\"2010-06-01T00:00:00Z\",\"total\":291},{\"date\":\"2010-07-01T00:00:00Z\",\"total\":263},{\"date\":\"2010-08-01T00:00:00Z\",\"total\":316},{\"date\":\"2010-09-01T00:00:00Z\",\"total\":315},{\"date\":\"2010-10-01T00:00:00Z\",\"total\":2103},{\"date\":\"2010-11-01T00:00:00Z\",\"total\":3146},{\"date\":\"2010-12-01T00:00:00Z\",\"total\":3997},{\"date\":\"2011-01-01T00:00:00Z\",\"total\":3487},{\"date\":\"2011-02-01T00:00:00Z\",\"total\":2469},{\"date\":\"2011-03-01T00:00:00Z\",\"total\":2103},{\"date\":\"2011-04-01T00:00:00Z\",\"total\":1246},{\"date\":\"2011-05-01T00:00:00Z\",\"total\":543},{\"date\":\"2011-06-01T00:00:00Z\",\"total\":275},{\"date\":\"2011-07-01T00:00:00Z\",\"total\":307},{\"date\":\"2011-08-01T00:00:00Z\",\"total\":259},{\"date\":\"2011-09-01T00:00:00Z\",\"total\":333},{\"date\":\"2011-10-01T00:00:00Z\",\"total\":2360},{\"date\":\"2011-11-01T00:00:00Z\",\"total\":2479},{\"date\":\"2011-12-01T00:00:00Z\",\"total\":2986},{\"date\":\"2012-01-01T00:00:00Z\",\"total\":3358},{\"date\":\"2012-02-01T00:00:00Z\",\"total\":2106},{\"date\":\"2012-03-01T00:00:00Z\",\"total\":1600},{\"date\":\"2012-04-01T00:00:00Z\",\"total\":1166},{\"date\":\"2012-05-01T00:00:00Z\",\"total\":519},{\"date\":\"2012-06-01T00:00:00Z\",\"total\":316},{\"date\":\"2012-07-01T00:00:00Z\",\"total\":318},{\"date\":\"2012-08-01T00:00:00Z\",\"total\":312},{\"date\":\"2012-09-01T00:00:00Z\",\"total\":295},{\"date\":\"2012-10-01T00:00:00Z\",\"total\":1523},{\"date\":\"2012-11-01T00:00:00Z\",\"total\":3305},{\"date\":\"2012-12-01T00:00:00Z\",\"total\":2898},{\"date\":\"2013-01-01T00:00:00Z\",\"total\":3656},{\"date\":\"2013-02-01T00:00:00Z\",\"total\":2182},{\"date\":\"2013-03-01T00:00:00Z\",\"total\":2016},{\"date\":\"2013-04-01T00:00:00Z\",\"total\":1215},{\"date\":\"2013-05-01T00:00:00Z\",\"total\":632},{\"date\":\"2013-06-01T00:00:00Z\",\"total\":363},{\"date\":\"2013-07-01T00:00:00Z\",\"total\":320},{\"date\":\"2013-08-01T00:00:00Z\",\"total\":305},{\"date\":\"2013-09-01T00:00:00Z\",\"total\":351},{\"date\":\"2013-10-01T00:00:00Z\",\"total\":1791},{\"date\":\"2013-11-01T00:00:00Z\",\"total\":3375},{\"date\":\"2013-12-01T00:00:00Z\",\"total\":3206},{\"date\":\"2014-01-01T00:00:00Z\",\"total\":4491},{\"date\":\"2014-02-01T00:00:00Z\",\"total\":2787},{\"date\":\"2014-03-01T00:00:00Z\",\"total\":1246}],\"BROOKLYN\":[{\"date\":\"2010-01-01T00:00:00Z\",\"total\":4800},{\"date\":\"2010-02-01T00:00:00Z\",\"total\":3464},{\"date\":\"2010-03-01T00:00:00Z\",\"total\":2474},{\"date\":\"2010-04-01T00:00:00Z\",\"total\":1443},{\"date\":\"2010-05-01T00:00:00Z\",\"total\":1030},{\"date\":\"2010-06-01T00:00:00Z\",\"total\":373},{\"date\":\"2010-07-01T00:00:00Z\",\"total\":333},{\"date\":\"2010-08-01T00:00:00Z\",\"total\":350},{\"date\":\"2010-09-01T00:00:00Z\",\"total\":401},{\"date\":\"2010-10-01T00:00:00Z\",\"total\":2952},{\"date\":\"2010-11-01T00:00:00Z\",\"total\":4603},{\"date\":\"2010-12-01T00:00:00Z\",\"total\":5681},{\"date\":\"2011-01-01T00:00:00Z\",\"total\":4378},{\"date\":\"2011-02-01T00:00:00Z\",\"total\":3055},{\"date\":\"2011-03-01T00:00:00Z\",\"total\":2597},{\"date\":\"2011-04-01T00:00:00Z\",\"total\":1660},{\"date\":\"2011-05-01T00:00:00Z\",\"total\":793},{\"date\":\"2011-06-01T00:00:00Z\",\"total\":379},{\"date\":\"2011-07-01T00:00:00Z\",\"total\":380},{\"date\":\"2011-08-01T00:00:00Z\",\"total\":398},{\"date\":\"2011-09-01T00:00:00Z\",\"total\":430},{\"date\":\"2011-10-01T00:00:00Z\",\"total\":3356},{\"date\":\"2011-11-01T00:00:00Z\",\"total\":3353},{\"date\":\"2011-12-01T00:00:00Z\",\"total\":3800},{\"date\":\"2012-01-01T00:00:00Z\",\"total\":4257},{\"date\":\"2012-02-01T00:00:00Z\",\"total\":2501},{\"date\":\"2012-03-01T00:00:00Z\",\"total\":1912},{\"date\":\"2012-04-01T00:00:00Z\",\"total\":1468},{\"date\":\"2012-05-01T00:00:00Z\",\"total\":675},{\"date\":\"2012-06-01T00:00:00Z\",\"total\":388},{\"date\":\"2012-07-01T00:00:00Z\",\"total\":363},{\"date\":\"2012-08-01T00:00:00Z\",\"total\":391},{\"date\":\"2012-09-01T00:00:00Z\",\"total\":426},{\"date\":\"2012-10-01T00:00:00Z\",\"total\":2083},{\"date\":\"2012-11-01T00:00:00Z\",\"total\":4813},{\"date\":\"2012-12-01T00:00:00Z\",\"total\":3622},{\"date\":\"2013-01-01T00:00:00Z\",\"total\":4699},{\"date\":\"2013-02-01T00:00:00Z\",\"total\":2512},{\"date\":\"2013-03-01T00:00:00Z\",\"total\":2351},{\"date\":\"2013-04-01T00:00:00Z\",\"total\":1504},{\"date\":\"2013-05-01T00:00:00Z\",\"total\":811},{\"date\":\"2013-06-01T00:00:00Z\",\"total\":364},{\"date\":\"2013-07-01T00:00:00Z\",\"total\":349},{\"date\":\"2013-08-01T00:00:00Z\",\"total\":358},{\"date\":\"2013-09-01T00:00:00Z\",\"total\":410},{\"date\":\"2013-10-01T00:00:00Z\",\"total\":2397},{\"date\":\"2013-11-01T00:00:00Z\",\"total\":4138},{\"date\":\"2013-12-01T00:00:00Z\",\"total\":3620},{\"date\":\"2014-01-01T00:00:00Z\",\"total\":5908},{\"date\":\"2014-02-01T00:00:00Z\",\"total\":3248},{\"date\":\"2014-03-01T00:00:00Z\",\"total\":1295}],\"MANHATTAN\":[{\"date\":\"2010-01-01T00:00:00Z\",\"total\":2588},{\"date\":\"2010-02-01T00:00:00Z\",\"total\":1715},{\"date\":\"2010-03-01T00:00:00Z\",\"total\":1375},{\"date\":\"2010-04-01T00:00:00Z\",\"total\":950},{\"date\":\"2010-05-01T00:00:00Z\",\"total\":718},{\"date\":\"2010-06-01T00:00:00Z\",\"total\":211},{\"date\":\"2010-07-01T00:00:00Z\",\"total\":147},{\"date\":\"2010-08-01T00:00:00Z\",\"total\":184},{\"date\":\"2010-09-01T00:00:00Z\",\"total\":193},{\"date\":\"2010-10-01T00:00:00Z\",\"total\":1772},{\"date\":\"2010-11-01T00:00:00Z\",\"total\":2303},{\"date\":\"2010-12-01T00:00:00Z\",\"total\":2880},{\"date\":\"2011-01-01T00:00:00Z\",\"total\":2545},{\"date\":\"2011-02-01T00:00:00Z\",\"total\":1694},{\"date\":\"2011-03-01T00:00:00Z\",\"total\":1483},{\"date\":\"2011-04-01T00:00:00Z\",\"total\":1026},{\"date\":\"2011-05-01T00:00:00Z\",\"total\":451},{\"date\":\"2011-06-01T00:00:00Z\",\"total\":225},{\"date\":\"2011-07-01T00:00:00Z\",\"total\":160},{\"date\":\"2011-08-01T00:00:00Z\",\"total\":209},{\"date\":\"2011-09-01T00:00:00Z\",\"total\":218},{\"date\":\"2011-10-01T00:00:00Z\",\"total\":2062},{\"date\":\"2011-11-01T00:00:00Z\",\"total\":1801},{\"date\":\"2011-12-01T00:00:00Z\",\"total\":2122},{\"date\":\"2012-01-01T00:00:00Z\",\"total\":2326},{\"date\":\"2012-02-01T00:00:00Z\",\"total\":1490},{\"date\":\"2012-03-01T00:00:00Z\",\"total\":1202},{\"date\":\"2012-04-01T00:00:00Z\",\"total\":970},{\"date\":\"2012-05-01T00:00:00Z\",\"total\":392},{\"date\":\"2012-06-01T00:00:00Z\",\"total\":219},{\"date\":\"2012-07-01T00:00:00Z\",\"total\":194},{\"date\":\"2012-08-01T00:00:00Z\",\"total\":194},{\"date\":\"2012-09-01T00:00:00Z\",\"total\":249},{\"date\":\"2012-10-01T00:00:00Z\",\"total\":1465},{\"date\":\"2012-11-01T00:00:00Z\",\"total\":2648},{\"date\":\"2012-12-01T00:00:00Z\",\"total\":2046},{\"date\":\"2013-01-01T00:00:00Z\",\"total\":2903},{\"date\":\"2013-02-01T00:00:00Z\",\"total\":1507},{\"date\":\"2013-03-01T00:00:00Z\",\"total\":1463},{\"date\":\"2013-04-01T00:00:00Z\",\"total\":1048},{\"date\":\"2013-05-01T00:00:00Z\",\"total\":675},{\"date\":\"2013-06-01T00:00:00Z\",\"total\":256},{\"date\":\"2013-07-01T00:00:00Z\",\"total\":235},{\"date\":\"2013-08-01T00:00:00Z\",\"total\":199},{\"date\":\"2013-09-01T00:00:00Z\",\"total\":274},{\"date\":\"2013-10-01T00:00:00Z\",\"total\":1579},{\"date\":\"2013-11-01T00:00:00Z\",\"total\":2454},{\"date\":\"2013-12-01T00:00:00Z\",\"total\":2322},{\"date\":\"2014-01-01T00:00:00Z\",\"total\":3664},{\"date\":\"2014-02-01T00:00:00Z\",\"total\":2019},{\"date\":\"2014-03-01T00:00:00Z\",\"total\":863}],\"QUEENS\":[{\"date\":\"2010-01-01T00:00:00Z\",\"total\":2318},{\"date\":\"2010-02-01T00:00:00Z\",\"total\":1494},{\"date\":\"2010-03-01T00:00:00Z\",\"total\":1132},{\"date\":\"2010-04-01T00:00:00Z\",\"total\":673},{\"date\":\"2010-05-01T00:00:00Z\",\"total\":506},{\"date\":\"2010-06-01T00:00:00Z\",\"total\":185},{\"date\":\"2010-07-01T00:00:00Z\",\"total\":137},{\"date\":\"2010-08-01T00:00:00Z\",\"total\":153},{\"date\":\"2010-09-01T00:00:00Z\",\"total\":180},{\"date\":\"2010-10-01T00:00:00Z\",\"total\":1410},{\"date\":\"2010-11-01T00:00:00Z\",\"total\":2225},{\"date\":\"2010-12-01T00:00:00Z\",\"total\":2801},{\"date\":\"2011-01-01T00:00:00Z\",\"total\":2226},{\"date\":\"2011-02-01T00:00:00Z\",\"total\":1463},{\"date\":\"2011-03-01T00:00:00Z\",\"total\":1287},{\"date\":\"2011-04-01T00:00:00Z\",\"total\":750},{\"date\":\"2011-05-01T00:00:00Z\",\"total\":349},{\"date\":\"2011-06-01T00:00:00Z\",\"total\":161},{\"date\":\"2011-07-01T00:00:00Z\",\"total\":136},{\"date\":\"2011-08-01T00:00:00Z\",\"total\":170},{\"date\":\"2011-09-01T00:00:00Z\",\"total\":172},{\"date\":\"2011-10-01T00:00:00Z\",\"total\":1550},{\"date\":\"2011-11-01T00:00:00Z\",\"total\":1632},{\"date\":\"2011-12-01T00:00:00Z\",\"total\":1904},{\"date\":\"2012-01-01T00:00:00Z\",\"total\":2028},{\"date\":\"2012-02-01T00:00:00Z\",\"total\":1202},{\"date\":\"2012-03-01T00:00:00Z\",\"total\":926},{\"date\":\"2012-04-01T00:00:00Z\",\"total\":710},{\"date\":\"2012-05-01T00:00:00Z\",\"total\":291},{\"date\":\"2012-06-01T00:00:00Z\",\"total\":186},{\"date\":\"2012-07-01T00:00:00Z\",\"total\":122},{\"date\":\"2012-08-01T00:00:00Z\",\"total\":148},{\"date\":\"2012-09-01T00:00:00Z\",\"total\":146},{\"date\":\"2012-10-01T00:00:00Z\",\"total\":925},{\"date\":\"2012-11-01T00:00:00Z\",\"total\":2403},{\"date\":\"2012-12-01T00:00:00Z\",\"total\":1874},{\"date\":\"2013-01-01T00:00:00Z\",\"total\":2257},{\"date\":\"2013-02-01T00:00:00Z\",\"total\":1168},{\"date\":\"2013-03-01T00:00:00Z\",\"total\":1096},{\"date\":\"2013-04-01T00:00:00Z\",\"total\":725},{\"date\":\"2013-05-01T00:00:00Z\",\"total\":399},{\"date\":\"2013-06-01T00:00:00Z\",\"total\":163},{\"date\":\"2013-07-01T00:00:00Z\",\"total\":137},{\"date\":\"2013-08-01T00:00:00Z\",\"total\":145},{\"date\":\"2013-09-01T00:00:00Z\",\"total\":151},{\"date\":\"2013-10-01T00:00:00Z\",\"total\":1085},{\"date\":\"2013-11-01T00:00:00Z\",\"total\":2031},{\"date\":\"2013-12-01T00:00:00Z\",\"total\":1731},{\"date\":\"2014-01-01T00:00:00Z\",\"total\":2794},{\"date\":\"2014-02-01T00:00:00Z\",\"total\":1415},{\"date\":\"2014-03-01T00:00:00Z\",\"total\":587}],\"STATEN ISLAND\":[{\"date\":\"2010-01-01T00:00:00Z\",\"total\":226},{\"date\":\"2010-02-01T00:00:00Z\",\"total\":166},{\"date\":\"2010-03-01T00:00:00Z\",\"total\":130},{\"date\":\"2010-04-01T00:00:00Z\",\"total\":70},{\"date\":\"2010-05-01T00:00:00Z\",\"total\":69},{\"date\":\"2010-06-01T00:00:00Z\",\"total\":31},{\"date\":\"2010-07-01T00:00:00Z\",\"total\":31},{\"date\":\"2010-08-01T00:00:00Z\",\"total\":35},{\"date\":\"2010-09-01T00:00:00Z\",\"total\":48},{\"date\":\"2010-10-01T00:00:00Z\",\"total\":151},{\"date\":\"2010-11-01T00:00:00Z\",\"total\":225},{\"date\":\"2010-12-01T00:00:00Z\",\"total\":288},{\"date\":\"2011-01-01T00:00:00Z\",\"total\":217},{\"date\":\"2011-02-01T00:00:00Z\",\"total\":146},{\"date\":\"2011-03-01T00:00:00Z\",\"total\":117},{\"date\":\"2011-04-01T00:00:00Z\",\"total\":72},{\"date\":\"2011-05-01T00:00:00Z\",\"total\":38},{\"date\":\"2011-06-01T00:00:00Z\",\"total\":40},{\"date\":\"2011-07-01T00:00:00Z\",\"total\":27},{\"date\":\"2011-08-01T00:00:00Z\",\"total\":33},{\"date\":\"2011-09-01T00:00:00Z\",\"total\":44},{\"date\":\"2011-10-01T00:00:00Z\",\"total\":174},{\"date\":\"2011-11-01T00:00:00Z\",\"total\":154},{\"date\":\"2011-12-01T00:00:00Z\",\"total\":166},{\"date\":\"2012-01-01T00:00:00Z\",\"total\":165},{\"date\":\"2012-02-01T00:00:00Z\",\"total\":105},{\"date\":\"2012-03-01T00:00:00Z\",\"total\":82},{\"date\":\"2012-04-01T00:00:00Z\",\"total\":89},{\"date\":\"2012-05-01T00:00:00Z\",\"total\":38},{\"date\":\"2012-06-01T00:00:00Z\",\"total\":30},{\"date\":\"2012-07-01T00:00:00Z\",\"total\":21},{\"date\":\"2012-08-01T00:00:00Z\",\"total\":26},{\"date\":\"2012-09-01T00:00:00Z\",\"total\":28},{\"date\":\"2012-10-01T00:00:00Z\",\"total\":90},{\"date\":\"2012-11-01T00:00:00Z\",\"total\":251},{\"date\":\"2012-12-01T00:00:00Z\",\"total\":180},{\"date\":\"2013-01-01T00:00:00Z\",\"total\":190},{\"date\":\"2013-02-01T00:00:00Z\",\"total\":101},{\"date\":\"2013-03-01T00:00:00Z\",\"total\":105},{\"date\":\"2013-04-01T00:00:00Z\",\"total\":64},{\"date\":\"2013-05-01T00:00:00Z\",\"total\":42},{\"date\":\"2013-06-01T00:00:00Z\",\"total\":21},{\"date\":\"2013-07-01T00:00:00Z\",\"total\":22},{\"date\":\"2013-08-01T00:00:00Z\",\"total\":21},{\"date\":\"2013-09-01T00:00:00Z\",\"total\":18},{\"date\":\"2013-10-01T00:00:00Z\",\"total\":121},{\"date\":\"2013-11-01T00:00:00Z\",\"total\":155},{\"date\":\"2013-12-01T00:00:00Z\",\"total\":151},{\"date\":\"2014-01-01T00:00:00Z\",\"total\":256},{\"date\":\"2014-02-01T00:00:00Z\",\"total\":132},{\"date\":\"2014-03-01T00:00:00Z\",\"total\":60}]}");

function ComplaintsChartByBorough(data){
  var $chart = $('#borough-complaints');
  this.margin = {top: 20, right: 20, bottom: 30, left: 30};
  this.height = $chart.height();
  this.width = $chart.width();
  this.data = this.normalizeData(data); 
  this.maxDate = this.setMinOrMax('max', this.data, function(d){ return d.date; });
  this.minDate = this.setMinOrMax('min', this.data, function(d){ return d.date; });
  this.maxTotal = this.setMinOrMax('max', this.data, function(d){ return d.total + 10; });
  this.minTotal = this.setMinOrMax('min', this.data, function(d){ return d.total - 10; });
  this.svg = this.setSvg();
  this.xScale = this.setXScale();
  this.yScale = this.setYScale();
  this.yAxis = this.setYAxis();
  this.xAxis = this.setXAxis();
  this.lineDrawer = this.setLineDrawer();
}

ComplaintsChartByBorough.prototype.normalizeData = function(dataObj){
  for (var borough in dataObj) {
    if( dataObj.hasOwnProperty( borough ) ) {
      dataObj[borough].forEach(function(obj){
        obj.date = new Date(obj.date);
      });
    } 
  }

  return dataObj;
};

ComplaintsChartByBorough.prototype.setMinOrMax = function(minOrMax, dataObj, callBack){
  var arr = [];
  for (var borough in dataObj) {
    if( dataObj.hasOwnProperty( borough ) ) {
      dataObj[borough].forEach(function(obj){
        arr.push( d3[minOrMax](dataObj[borough], callBack) );
      });
    } 
  }
  return d3[minOrMax](arr);
};

// main svg
ComplaintsChartByBorough.prototype.setSvg = function(){
  return d3.select('#borough-complaints')
    .append('svg')
    .attr('width', this.width)
    .attr('height', this.height)
    .append('g')
    .attr('class', 'outter-group');
};

// data line
ComplaintsChartByBorough.prototype.setLineDrawer = function(){
  var self = this;
  return d3.svg.line().x(function(d) {
    return self.xScale(d.date);
  }).y(function(d) {
    return self.yScale(d.total);
  }).interpolate('linear');
};

ComplaintsChartByBorough.prototype.createDataLineGroup = function(){
  return this.svg.append('g')
    .attr('class', 'data-line-group')
    .attr('transform', 'translate(' + this.margin.left + ',0)')
    .selectAll('.data-line').data([this.data]);
};

ComplaintsChartByBorough.prototype.drawLine = function() {
  for (var borough in this.data){
    if( this.data.hasOwnProperty(borough) ) {
      this.createDataLineGroup().enter().append('path')
        .attr('class', 
          'data-line ' + borough.toLocaleLowerCase().replace(' ', '-')
        )
        .attr('d', this.lineDrawer(this.data[borough]));
    }
  }
};

// x
ComplaintsChartByBorough.prototype.setXScale = function(){
  return d3.time.scale()
    .range([0, (this.width - this.margin.left)])
    .domain(
      [this.minDate, this.maxDate]
    );
};

ComplaintsChartByBorough.prototype.setXAxis = function(){
  return d3.svg.axis()
    .scale(this.xScale)
    .ticks(d3.time.years)
    .tickSize(6, 0)
    .orient('bottom');
};

ComplaintsChartByBorough.prototype.drawXAxis = function(){
  this.svg.append('g')
    .attr('class', 'x-ticks')
    .call(this.xAxis)
    .attr('transform', 
      'translate(' + this.margin.left + ',' + (this.height - this.margin.top) + ')'
    );
};

// y
ComplaintsChartByBorough.prototype.setYScale = function(){
  return d3.scale.linear()
    .range([0, (this.height - this.margin.top)])
    .domain(
      [this.maxTotal, this.minTotal]
    );
};

ComplaintsChartByBorough.prototype.setYAxis = function(){
  return d3.svg.axis()
    .scale(this.yScale)
    .orient('left')
    .tickSize(-this.width + this.margin.left)
    .tickPadding(0)
    .ticks(5);
};

ComplaintsChartByBorough.prototype.drawYAxis = function(){
  this.svg.append('g')
    .attr('class', 'y-ticks')
    .call(this.yAxis)
    .call(this.positionYText)
    .attr('transform', 'translate('+ this.margin.left + ', 0)');
};

ComplaintsChartByBorough.prototype.positionYText = function(g){
  g.selectAll('text').attr('dy', -4).attr('x', -30);
};