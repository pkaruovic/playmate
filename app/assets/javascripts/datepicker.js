$(document).on('turbolinks:load', function() {
  $('[data-provide=date_picker]').flatpickr({
    altInput: true,
    altFormat: 'j F, Y',
    dateFormat: 'Y-m-d',
  });

  $('[data-provide=date_range_picker] [data-input]').flatpickr({
    altInput: true,
    altFormat: 'D, M j',
    dateFormat: 'Y-m-d',
    mode: 'range',
    onChange: function(selectedDates, dateStr, instance) {
      const dates = dateStr.split(' to ').filter(str => str !== '');
      const input = instance.input;
      const clearElement = $(input)
        .closest('[data-provide=date_range_picker]')
        .children('[data-clear]');
      const inputsToUpdate = input.dataset.fillInputs.split(', ');
      if (dates.length === 0) {
        inputsToUpdate.forEach(id => {
          $(`#${id}`).val(null);
          $(`#${id}`).change();
        });
        clearElement.hide();
      }
      if (dates.length === 2) {
        inputsToUpdate.forEach((id, index) => {
          $(`#${id}`).val(dates[index]);
          $(`#${id}`).change();
        });
        clearElement.show();
      }
    },
  });

  $('[data-provide=date_range_picker] [data-clear]').click(
    function setClickHandler() {
      $(this)
        .closest('[data-provide=date_range_picker]')
        .children('[data-input]')
        .each(function() {
          this._flatpickr.clear();
        });
    },
  );

  $('[data-provide=date_range_picker] [data-input]').each(
    function hideClearButton() {
      const dates = this.value.split(' to ').filter(str => str !== '');
      if (dates.length === 0) {
        $(this)
          .closest('[data-provide=date_range_picker]')
          .children('[data-clear]')
          .hide();
      }
    },
  );
});
