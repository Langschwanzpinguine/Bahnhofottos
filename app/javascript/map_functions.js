let map;
let markersLayer;
//document.addEventListener("turbolinks:load", initMap);
document.addEventListener("DOMContentLoaded", initMap);

function initMap(){
    map = L.map('map').setView([49, 8.5], 6.5);
     //Thunderforest
    // L.tileLayer('http://localhost:3000/proxy/map-tiles/thunderforest?z={z}&x={x}&y={y}', {
    //     maxZoom: 19,
    //     attribution: '© OSM x Langschwanzpinguine e.V.'
    // }).addTo(map);

    //JAWG
    L.tileLayer('http://localhost:3000/proxy/map-tiles/jawg?z={z}&x={x}&y={y}&r={r}', {})
        .addTo(map);
    map.attributionControl.addAttribution("OSM x <a href='https://github.com/Langschwanzpinguine' target='_blank'>Langschwanzpinguine e.V.</a>")
    markersLayer = L.layerGroup().addTo(map);
}


function fetchTrainStationsInView(){
    markersLayer.clearLayers();
    const bounding_box = map.getBounds();
    const request_body = {
        start_lat: bounding_box["_northEast"]["lat"],
        start_lon: bounding_box["_northEast"]["lng"],
        end_lat: bounding_box["_southWest"]["lat"],
        end_lon: bounding_box["_southWest"]["lng"],
    }

    const url = "http://localhost:3000/api/overpass/stations";
    const requestOptions = {
        method: 'POST',
        mode: 'cors',
        headers: {
            'Content-Type': 'application/json', // Specify the content type as JSON
        },
        body: JSON.stringify(request_body), // Convert the object to JSON string
    };
    console.log(request_body);

    fetch(url, requestOptions)
        .then(res => {
            if (!res.ok) {
                console.error(`HTTP error! Status: ${res.status}`);
                return;
            }
            console.log(res)
            return res.json();
        }).then(data => {
            console.log('Response data:', data);
            let allStations = data.elements;
            for (const station of allStations) {
                let lat = station.lat;
                let lon = station.lon;
                let marker = L.marker([lat, lon]).addTo(map);
                marker.bindPopup(station.tags.name ?? station.tags.description);
                markersLayer.addLayer(marker);
        }
    }).catch(error => {
        console.error('Fetch error:', error);
    });
}