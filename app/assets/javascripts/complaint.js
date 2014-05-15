// converts complaint lat/long to latlng objects in an array
array = [];
complaints.forEach(function(arr){
 array.push(L.latLng(arr[0], arr[1]));
});
// adds complaints to map
L.heatLayer(array, {radius: 15, gradient: {0.4: 'blue', 0.65: 'lime', 1: 'red'}}).addTo(map);