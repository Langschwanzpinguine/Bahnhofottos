let map;
let markers;
let selectedCountry;
let select_tag;

const STATION_GREEN = "/assets/bahnhof_windowless_green";
const STATION_YELLOW = "/assets/bahnhof_windowless_yellow";
const STATION_RED = "/assets/bahnhof_windowless_red";

document.addEventListener("DOMContentLoaded", initPage);


function countrySelected(){
    markers ? markers.clearLayers() : null;
    selectedCountry = select_tag.value;
    const foundCountry = country_info['countries'].find((country) => country.code === selectedCountry);
    let bbox = foundCountry['bounding_box'];
    map.fitBounds([
        [bbox[0], bbox[2]],
        [bbox[1], bbox[3]]
    ])
    const url = "http://localhost:3000/api/countries/" + foundCountry['code'];
    console.log(url)
    const requestOptions = {
        method: 'GET',
    };
    markers = L.markerClusterGroup({
            iconCreateFunction: function(cluster) {
                let childCount = cluster.getChildCount();
                let image_source;

                if (childCount < 10) {
                    image_source = '<img class="station_marker" src="' + STATION_GREEN + '">';
                } else if (childCount < 100) {
                    image_source = '<img class="station_marker" src="' + STATION_YELLOW + '">';
                } else {
                    image_source = '<img class="station_marker" src="' + STATION_RED + '">';
                }
                return L.divIcon({ html: '<div class="childcount">' + childCount + '</div>' + image_source,
                                iconSize: L.point(40, 15)});
            }
        }
    );
    fetch(url, requestOptions)
        .then(res => {
            if (!res.ok) {
                console.error(`HTTP error! Status: ${res.status}`);
                return;
            }
            return res.json();
        }).then(data => {
        let allStations = data.elements;
        for (const station of allStations) {
            let lat = station.lat;
            let lon = station.lon;
            let marker = L.marker([lat, lon]);
            marker.bindPopup(station.tags.name ?? station.tags.description);
            markers.addLayer(marker);
            map.addLayer(markers);
        }
    }).catch(error => {
        console.error('Fetch error:', error);
    });

}

function initPage(){
    select_tag = document.getElementById('country_selection')
    selectedCountry = select_tag.value;
    select_tag.addEventListener('change', countrySelected)
    initMap();
    countrySelected();
    const element = document.querySelector('.country_dropdown');
    const choices = new Choices(element, {
        searchEnabled: true,
        itemSelectText: '',
        searchPlaceholderValue: "Search...",
        shouldSort: false
    });
}

function initMap(){
    map = L.map('map')
     //Thunderforest
    L.Marker.prototype.options.icon = L.icon({
        iconUrl: "/assets/Point.png",
        shadowUrl: "https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png",
        iconAnchor: [13, 41],
        popupAnchor:  [0, -35]
    });
    L.tileLayer('http://localhost:3000/proxy/map-tiles/thunderforest?z={z}&x={x}&y={y}', {
        maxZoom: 19,
        attribution: '© OSM x IG Langschwanzpinguine'
    }).addTo(map);

    //JAWG
    // L.tileLayer('http://localhost:3001/proxy/jawg?z={z}&x={x}&y={y}', {})
    //     .addTo(map);
    // map.attributionControl.addAttribution("OSM x <a href='https://github.com/Langschwanzpinguine' target='_blank'>Langschwanzpinguine e.V.</a>")
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
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(request_body),
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

