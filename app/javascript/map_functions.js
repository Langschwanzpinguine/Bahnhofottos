let map;
let markers;
let selectedCountry;
let select_tag;
let listOfResults;
let searchInput;

const STATION_GREEN = "/assets/bahnhof_windowless_green";
const STATION_YELLOW = "/assets/bahnhof_windowless_yellow";
const STATION_RED = "/assets/bahnhof_windowless_red";

document.addEventListener("DOMContentLoaded", initPage);
let fuse = new Fuse([], {
    keys: [
        "tags.name"
    ]}
);


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

        const fuseOptions = {
            keys: [
                "tags.name"
            ]
        };
        fuse = new Fuse(allStations, fuseOptions);

        for (const station of allStations) {
            let lat = station.lat;
            let lon = station.lon;
            let marker = L.marker([lat, lon]);

            marker.bindPopup(createPopUp(station));
            markers.addLayer(marker);
            map.addLayer(markers);
        }
    }).catch(error => {
        console.error('Fetch error:', error);
    });

}

function createPopUp(station){
    let operator_string = station.tags.operator
    let returnString = `<h5>${station.tags.name ?? station.tags.description}</h5>
    <p><i class="fa-solid fa-train"></i> ${station.tags.railway.charAt(0).toUpperCase() + station.tags.railway.slice(1)}</p>`
    if(operator_string){
        let op_arr = operator_string.split(';')
        for(const operator of op_arr){
            returnString += `<p><i class="fa-solid fa-building"></i> ${operator}</p>`
        }

    }
    return returnString;
}

function initPage(){
    searchInput = document.getElementById('station_search');
    select_tag = document.getElementById('country_selection');
    selectedCountry = select_tag.value;
    select_tag.addEventListener('change', countrySelected);
    listOfResults = document.getElementById('matches');
    initMap();
    countrySelected();
    const element = document.querySelector('.country_dropdown');
    const choices = new Choices(element, {
        searchEnabled: true,
        itemSelectText: '',
        searchPlaceholderValue: "Search...",
        shouldSort: false
    });

    document.addEventListener('click', (ev) => {
        disableResults(ev);
    });
    document.getElementById('station_search').addEventListener('input', perform_search);
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

function perform_search(){
    let pattern = document.getElementById('station_search').value;
    let results = fuse.search(pattern).slice(0, 5);
    listOfResults.innerHTML = '';
    listOfResults.style.display = 'block';

    for (const res of results) {
        const li = document.createElement('li');
        li.setAttribute('data-id', res.item.id);
        li.textContent = res.item.tags.name;

        li.addEventListener('click', (ev) => {
            viewSearchedStation(ev);
        });

        listOfResults.appendChild(li);
    }
}

function disableResults(event){
    if (event.target !== searchInput && event.target !== listOfResults && !listOfResults.contains(event.target)) {
        const liElements = document.querySelectorAll('.matches li');
        liElements.forEach((li) => {
            console.log("Mounted listener")
            li.removeEventListener('click', viewSearchedStation);
        });
        document.getElementById('station_search').value = "";
        listOfResults.style.display = 'none';
    }
}

function viewSearchedStation(event){
    console.log(`Clicked on ${event.target.getAttribute('data-id')}`)
}




