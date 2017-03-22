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

UserShowTempChartToolTips.prototype._formatDate = function(date) {
  var momentDate = moment(date);

  if (momentDate.minutes <= 10) {
    momentDate.startOf('hour');
  }

  return momentDate.format("D MMMM YYYY").toUpperCase() + '<br>'
    + momentDate.format("dddd") + ' at ' + momentDate.format("h:mm A") + '<br>';
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
      return self._formatDate(circleDate) + ' '
        + '<i>Temperature in Violation</i><br>'
        + '<br>Temperature in Apt: ' + circleDatum.temp + '°'
        + '<br>Temperature Outside: ' + circleDatum.outdoor_temp + '°'
        + '<br>Legal minimum: ' + self._legalMinimumFor(circleDatum) + '°';
    }
  });
};
