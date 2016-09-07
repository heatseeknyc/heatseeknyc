$(function() {
  function unitOption(unit) {
    return '<option value="' + unit.id + '">' + unit.name.toUpperCase() + '</option>'; 
  }

  function getUnitOptions(buildingId, $unitSelector) {
    $unitSelector.attr('disabled', true);
    $unitSelector.children().remove();

    if (buildingId === '')
    { 
      return;
    }

    $.getJSON('/admin/buildings/' + buildingId + '/units', function(data) {
      $unitSelector.append('<option></option>');

      if (data.results.length !== 0)
      {
        $.each(data.results, function() {
          $unitSelector.append(unitOption(this));
        });
      }

      $unitSelector.attr('disabled', false);
    });
  }

  $(document).ready(function() {
    var $buildingSelector = $('#user_building_id');
    var $unitSelector = $('#user_unit_id');

    $($buildingSelector).change(function() {
      getUnitOptions($buildingSelector.val(), $unitSelector);
    });
  });
});