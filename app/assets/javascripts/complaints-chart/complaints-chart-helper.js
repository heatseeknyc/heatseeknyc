var ComplaintsChartHelper = {
  normalizeData: function(dataObj){
    for (var borough in dataObj) {
      if( dataObj.hasOwnProperty( borough ) ) {
        dataObj[borough].forEach(function(obj){
          obj.date = new Date(obj.date);
        });
      } 
    }

    return dataObj;
  },

  setMinOrMax: function(minOrMax, dataObj, callBack){
    var arr = [];
    for (var borough in dataObj) {
      if( dataObj.hasOwnProperty( borough ) ) {
        dataObj[borough].forEach(function(obj){
          arr.push( d3[minOrMax](dataObj[borough], callBack) );
        });
      } 
    }
    return d3[minOrMax](arr);
  }
};