$(document).ready(function(){
  // complaints is a variable made available to the complaints/index.html.erb
  try {
    addComplaintsToMap(complaints);
  }catch(err){
    // does nothing if there is no complaints
  }
});

// converts complaint lat/long to latlng objects in an array
function createLatLngs(complaintsCoordinates){
  var convertedLatLngArray = [];
  complaints.forEach(function(complaintsCoordinates){
    convertedLatLngArray.push(
      L.latLng(complaintsCoordinates[0], complaintsCoordinates[1])
    );
  });
  return convertedLatLngArray;
}

// adds complaints to map
function addComplaintsToMap(complaintsCoordinates){
  var convertedComplaints = createLatLngs(complaintsCoordinates);
  L.heatLayer(
    convertedComplaints, 
    {
      radius: 8, 
      gradient: {0.25: 'blue', 0.55: 'lime', 0.75: 'yellow', 0.95: 'red'},
      blur: 14
      // for more heatmap options see https://github.com/Leaflet/Leaflet.heat
    }
  ).addTo(map);
}