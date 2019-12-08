$(document).on('turbolinks:load', function bindAutocompleteHandlers() {
  $('[data-provide=city-autocomplete]').each(function() {
    const element = this;
    const autocomplete = new google.maps.places.Autocomplete(element, {
      types: ['(cities)'],
      fields: ['place_id', 'name'],
    });

    autocomplete.addListener('place_changed', function(param) {
      const place = autocomplete.getPlace();
      const [city, country] = place.name.split(',');
      element.value = city;
    });
  });
});
