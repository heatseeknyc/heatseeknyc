$(document).ready(function(){
  var complaintGeoJson;

  function getColor(d) {
    return d > 25000 ? '#081d58' :
           d > 20000 ? '#08306b' :
           d > 15000 ? '#08519c' :
           d > 10000 ? '#2171b5' :
           d > 5000  ? '#4292c6' :
           d > 1000  ? '#6baed6' :
           d > 500   ? '#9ecae1' :
           d > 100   ? '#c6dbef' :
           d > 50    ? '#deebf7' :
                       '#f7fbff' ;
  }

  //   function getColor(d) {
  //   return d > 25000 ? '#08519c' :
  //          d > 20000 ? '#2171b5' :
  //          d > 15000 ? '#4292c6' :
  //          d > 10000 ? '#6baed6' :
  //          d > 5000  ? '#9ecae1' :
  //          d > 1000  ? '#c6dbef' :
  //          d > 500   ? '#deebf7' :
  //                      '#f7fbff' ;
  // }
   
  function style(feature) {
    return {
      fillColor: getColor(feature.properties.density),
      weight: 1,
      opacity: 1,
      color: 'white',
      dashArray: '3',
      fillOpacity: 0.7
    };
  }

  function onEachFeature(feature, layer) {
    layer.on({
      click: zoomToFeature,
      mouseover: highlightFeature,
      mouseout: resetHighlight
    });
  }

  function highlightFeature(e) {
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
    info.update(layer.feature.properties);
  }

  function resetHighlight(e) {
    complaintGeoJson.resetStyle(e.target);
    info.update();
  }

  function zoomToFeature(e) {
    map.fitBounds(e.target.getBounds());
  }

  complaintGeoJson = L.geoJson(geoJsonZipCode, {
      style: style,
      onEachFeature: onEachFeature
  }).addTo(map);

  var info = L.control();

  info.onAdd = function (map) {
      this._div = L.DomUtil.create('div', 'info'); // create a div with a class "info"
      this.update();
      return this._div;
  };

  // method that we will use to update the control based on feature properties passed
  info.update = function (props) {
      this._div.innerHTML = '<h4>Heating Complaints by Zip Code</h4>' +  (props ?
          '<b> Zip Code: ' + props.postalCode + '</b><br />Complaints: ' + props.density
          : 'Hover over a Zip Code');
  };

  info.addTo(map);

  var legend = L.control({position: 'bottomright'});

  legend.onAdd = function (map) {

      var div = L.DomUtil.create('div', 'info legend'),
          grades = [0, 50, 100, 500, 1000, 5000, 10000, 15000, 20000, 25000],
          labels = ['#f7fbff', '#deebf7', '#c6dbef', '#9ecae1', '#6baed6', '#4292c6', '#2171b5', '#08519c', '#08306b', '#081d58'];

      // loop through our density intervals and generate a label with a colored square for each interval
      for (var i = 0; i < grades.length; i++) {
          div.innerHTML +=
              '<i style="background:' + getColor(grades[i] + 1) + '"></i> ' +
              grades[i] + (grades[i + 1] ? '&ndash;' + grades[i + 1] + '<br>' : '+');
      }

      return div;
  };

  legend.addTo(map);

  map.attributionControl._container.innerHTML = 
    "<a href='http://leafletjs.com' title='A JS library for interactive maps'>Leaflet</a> | " + 
    "Map Data © <a href='http://www.openstreetmap.org/about'>OpenStreetMap</a> " +
    "contributors, <a href='http://creativecommons.org/licenses/by-sa/2.0/'>CC-BY-SA</a>, " + 
    "Tile Set © <a href='https://www.mapbox.com/about/'>Mapbox</a>, " + 
    "Complaint Data © <a href='https://nycopendata.socrata.com/'>NYC Open Data</a>";

});