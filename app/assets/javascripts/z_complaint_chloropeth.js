function ColdMap (geoJsonArr) {
  var self = this;

  this.complaintGeoJson = L.geoJson((geoJsonArr || geoJsonZipCode), {
    style: _style,
    onEachFeature: _onEachFeature
  }).addTo(map);

  // private instance methods
  function _style(feature) {
    return {
      fillColor: self._getColor(feature.properties.density),
      weight: 1,
      opacity: 1,
      color: 'white',
      dashArray: '3',
      fillOpacity: 0.7
    };
  };

  function _resetHighlight(e) {
    self.complaintGeoJson.resetStyle(e.target);
    ColdMap.prototype.info._hoverActions();
  };

  function _onEachFeature(feature, layer) {
    layer.on({
      click: self._zoomToFeature,
      mouseover: self._highlightFeature,
      mouseout: _resetHighlight
    });
  };

}

//public instance methods and properties
ColdMap.prototype.info = L.control();

ColdMap.prototype.legend = L.control({position: 'bottomright'});

ColdMap.prototype.addInfoToMap = function(){
  ColdMap.prototype.info.addTo(map);
};

ColdMap.prototype.addLegendToMap = function(){
  this.legend.addTo(map);
};

ColdMap.prototype.addAttributionToMap = function(){
  map.attributionControl._container.innerHTML = 
    "<a href='http://leafletjs.com' title='A JS library for interactive maps'>Leaflet</a> | "
    +  "Map Data © <a href='http://www.openstreetmap.org/about'>OpenStreetMap</a> "
    +  "contributors, <a href='http://creativecommons.org/licenses/by-sa/2.0/'>CC-BY-SA</a>, "
    +  "Tile Set © <a href='https://www.mapbox.com/about/'>Mapbox</a>, "
    +  "Complaint Data © <a href='https://nycopendata.socrata.com/'>NYC Open Data</a>";
};

ColdMap.prototype.drawColdMap = function(){
  this.addInfoToMap();
  this.addLegendToMap();
  this.addAttributionToMap();
};

// protected instance methods
ColdMap.prototype._getColor = function(density) {
  return density > 25000 ? '#081d58' :
         density > 20000 ? '#08306b' :
         density > 15000 ? '#08519c' :
         density > 10000 ? '#2171b5' :
         density > 5000  ? '#4292c6' :
         density > 1000  ? '#6baed6' :
         density > 500   ? '#9ecae1' :
         density > 100   ? '#c6dbef' :
         density > 50    ? '#deebf7' :
                           '#f7fbff' ;
};

ColdMap.prototype._highlightFeature = function(e) {
  var layer = e.target;

  layer.setStyle({
    weight: 5,
    color: '#666',
    dashArray: '',
    fillOpacity: 0.7
  });

  if (!L.Browser.ie && !L.Browser.opera) {
    layer.bringToFront();
  }
  ColdMap.prototype.info._hoverActions(layer.feature.properties);
};

ColdMap.prototype._zoomToFeature = function(e) {
  map.fitBounds(e.target.getBounds());
};

// protected instance methods for info property
ColdMap.prototype.info._hoverActions = function(props) {
  // adds text to the div that appears on hover
  this._div.innerHTML = '<h4>Heating Complaints by Zip Code</h4>'
    + (props ? '<b> Zip Code: ' + props.postalCode + '</b><br />Complaints: '
    + props.density : 'Hover over a Zip Code');
};

ColdMap.prototype.info.onAdd = function(map) {
  // create a div with a class "info"
  this._div = L.DomUtil.create('div', 'info');
  ColdMap.prototype.info._hoverActions();
  return this._div;
};

// protected instance methods for legend property
ColdMap.prototype.legend.onAdd = function(map) {
  var div = L.DomUtil.create('div', 'info legend'),
      grades = [0, 50, 100, 500, 1000, 5000, 10000, 15000, 20000, 25000],
      labels = ['#f7fbff', '#deebf7', '#c6dbef', '#9ecae1', '#6baed6', '#4292c6', '#2171b5', '#08519c', '#08306b', '#081d58'];

  // loop through our density intervals and generate a label with a colored square for each interval
  for (var i = 0; i < grades.length; i++) {
    div.innerHTML += '<i style="background:' + ColdMap.prototype._getColor(grades[i] + 1)
     + '"></i> ' + grades[i] + (grades[i + 1] ? '&ndash;' + grades[i + 1] + '<br>' : '+');
  }

  return div;
};

$(document).ready(function(){
  // only draw map if the div exists
  if($("#coldmap").length > 0){
    newColdMap = new ColdMap();
    newColdMap.drawColdMap();
  }
});