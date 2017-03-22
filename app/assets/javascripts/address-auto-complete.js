$(function() {
  return $('#user_address').autocomplete({
    minLength: 2,
    source: $('#user_address').data('autocomplete-source')
  });
});
