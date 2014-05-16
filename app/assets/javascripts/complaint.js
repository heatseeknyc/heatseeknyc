$(document).ready(function(){
  // complaints is a variable made available to the complaints/index.html.erb
  addComplaintsToMap(complaints);
}

// converts complaint lat/long to latlng objects in an array
function createLatLngs(complaintsCoordinates){
  var convertedLatLngArray = [];
  complaints.forEach(function(complaintsCoordinates){
    convertedLatLngArray.push(
      L.latLng(complaintsCoordinates[0], complaintsCoordinates[1])
    );
  });
  return convertedLatLngArray;
};

// adds complaints to map
function addComplaintsToMap(complaintsCoordinates){
  var convertedComplaints = createLatLngs(complaintsCoordinates);
  L.heatLayer(
    convertedComplaints, {radius: 10, gradient: {0.4: 'blue', 0.65: 'lime', 1: 'red'}}
  ).addTo(map);
};