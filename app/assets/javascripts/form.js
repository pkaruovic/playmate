$(document).on('turbolinks:load', function() {
  $('[data-behaviour=autosubmit] input[type=text]').keyup(
    debounce(function() {
      submitForm(this.form);
    }, 300),
  );

  $('[data-behaviour=autosubmit] input').change(
    debounce(function() {
      submitForm(this.form);
    }, 100),
  );

  $('[data-behaviour=autosubmit] select').change(function() {
    submitForm(this.form);
  });

  $('[data-label-id]').each(updateLabel);

  $('[data-label-id]').change(updateLabel);

  function updateLabel() {
    const text = $(this)
      .children('option:selected')
      .text();
    $(`#${this.dataset.labelId}`).text(text);
  }

  function submitForm(form) {
    const action = $(form).attr('action');
    const formData = $(form).serialize();
    history.replaceState(null, document.title, action + '?' + formData);
    Rails.fire(form, 'submit');
  }
});
