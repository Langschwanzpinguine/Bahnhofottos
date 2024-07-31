class CountrySelector {
    constructor() {
        this.selectTag = document.getElementById('country_selection');
        this.hiddenCountryForm = document.getElementById('user_station_country');
        this.hiddenForm = document.getElementById('hidden_form');

        this.init();
    }

    init() {
        this.selectTag.addEventListener('change', this.selectionChanged.bind(this));

        const element = document.querySelector('.country_dropdown');
        this.choices = new Choices(element, {
            searchEnabled: true,
            itemSelectText: '',
            searchPlaceholderValue: "Search...",
            shouldSort: false
        });

        this.setInitialCountry();
    }

    selectionChanged() {
        this.hiddenCountryForm.value = this.selectTag.value;
        this.hiddenForm.submit()
    }

    setInitialCountry() {
        if(user_country){
            this.choices.setChoiceByValue(user_country);
        }
    }
}

document.addEventListener("DOMContentLoaded", () => new CountrySelector());