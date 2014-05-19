$(document).ready(function(){
  L.geoJson(geoJsonZipCode, {style: style, onEachFeature: onEachFeature}).addTo(map);
});

function getColor(d) {
  return d > 10000 ? '#08306b' :
         d > 5000  ? '#08519c' :
         d > 2000  ? '#2171b5' :
         d > 1000  ? '#4292c6' :
         d > 500   ? '#6baed6' :
         d > 200   ? '#9ecae1' :
         d > 100   ? '#c6dbef' :
         d > 50    ? '#deebf7' :
                     '#f7fbff' ;
}
 
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
}

function resetHighlight(e) {
  geojson.resetStyle(e.target);
}

function zoomToFeature(e) {
  map.fitBounds(e.target.getBounds());
}