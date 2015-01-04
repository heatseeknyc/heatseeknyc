function ComplaintsChartDrawer(data) {
  this.data = data;
}

ComplaintsChartDrawer.prototype.createAndDrawChartSvg = function(){
  var chartSvg = new ComplaintsChartSvg(this._selectDataBasedOnScreenSize());
  chartSvg.addChartElements();
};

ComplaintsChartDrawer.prototype._selectDataBasedOnScreenSize = function(){
  var length = this.data['BRONX'].length - 1,
    threeQuarters = Math.floor(length * 0.75),
    oneHalf = Math.floor(length * 0.5),
    oneQuarter = Math.floor(length * 0.25);

  if (window.innerWidth < 450) {
    return this._dataSlice(threeQuarters, length);
  }else if(window.innerWidth < 720) {
    return this._dataSlice(oneHalf, length);
  }else if(window.innerWidth < 1080) {
    return this._dataSlice(oneQuarter, length);
  } else {
    return this.data;
  }
};

ComplaintsChartDrawer.prototype._dataSlice = function(firstNum, lastNum){
  var dataObj = {};
  for (var borough in this.data) {
    if( this.data.hasOwnProperty( borough ) ) {
      dataObj[borough] = this.data[borough].slice(firstNum, lastNum);
    } 
  }

  return dataObj;
};

ComplaintsChartDrawer.prototype.drawChartOnWindowResize = function(){
  var resizeTimer = 0,
      self = this;
  $('#main-svg').remove('');
  this.createAndDrawChartSvg();
  window.onresize = function(){
    $('#main-svg').remove('');
    if (resizeTimer){
      clearTimeout(resizeTimer);
    }
    resizeTimer = setTimeout(function(){
      self.createAndDrawChartSvg();
      self.drawChartOnWindowResize();
    }, 50);
  };
};