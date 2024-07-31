let select_tag;
let listOfResults;

document.addEventListener("DOMContentLoaded", initPage);

function initPage(){
    select_tag = document.getElementById('country_selection');

    //select_tag.addEventListener('change', countrySelected);

    const element = document.querySelector('.country_dropdown');
    const choices = new Choices(element, {
        searchEnabled: true,
        itemSelectText: '',
        searchPlaceholderValue: "Search...",
        shouldSort: false
    });

    setInitialCountry(choices);
}

function setInitialCountry(choices){
    let countryToLoad = session_info['show_country'] ?? 'DE';
    choices.setChoiceByValue(countryToLoad);
}