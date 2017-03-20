function UserShowTempChartToolTips(callingObj){}

UserShowTempChartToolTips.prototype.DAYS = [ 'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday' ];
UserShowTempChartToolTips.prototype.MONTHS = [ "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE",
  "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER" ];

UserShowTempChartToolTips.prototype._legalMinimumFor = function(reading){
  if(reading.isDay === true){
    return '68';
  } else {
    return '55';
  }
};

UserShowTempChartToolTips.prototype._getCivilianTime = function(reading){
  if (reading.getHours() > 12){
    return (reading.getHours() - 12) + ":"
      + (reading.getMinutes() >= 10 ?
        reading.getMinutes() : "0" + reading.getMinutes())
      + " PM";
  } else {
    return reading.getHours() + ":"
      + (reading.getMinutes() >= 10 ?
        reading.getMinutes() : "0" + reading.getMinutes())
      + " AM";
  }
};

UserShowTempChartToolTips.prototype.addToChart = function(){
  var self = this;
  $('svg circle.violation').tipsy({
    gravity: 's',
    html: true,
    topOffset: 2.8,
    leftOffset: 0.3,
    opacity: 1,
    title: function() {
      var circleDatum = this.__data__,
        circleDate = circleDatum.date;
      return circleDate.getDate() + ' '
        + self.MONTHS[circleDate.getMonth()] + ' '
        + circleDate.getFullYear() + '<br>'
        + self.DAYS[ circleDate.getDay() ] + ' at '
        + self._getCivilianTime(circleDate) + '<br>'
        + '<i>Temperature in Violation</i><br>'
        + '<br>Temperature in Apt: ' + circleDatum.temp + '°'
        + '<br>Temperature Outside: ' + circleDatum.outdoor_temp + '°'
        + '<br>Legal minimum: ' + self._legalMinimumFor(circleDatum) + '°';
    }
  });
};
