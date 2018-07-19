function getKeyNameFromInputName(name) {
  return name.split('[', 2)[1].slice(0, -1);
}

function inputGroupToObject() {
  var obj = {};
  $(this)
    .find('.form-control')
    .map(function() {
      obj[getKeyNameFromInputName($(this).attr('name'))] = $(this).val();
    });

  return obj;
}

function inputGroupsToJSON(inputGroupSelector) {
  return JSON.stringify(
    $(inputGroupSelector)
      .map(inputGroupToObject)
      .get()
  );
}

function populateHiddenMultiPartField(fieldSelector, inputGroupSelector) {
  $(fieldSelector).val(inputGroupsToJSON(inputGroupSelector));
}

$(document).ready(function() {
  $('.edit_audiovisual_work').submit(function() {
    populateHiddenMultiPartField('#audiovisual_work_note', 'li.note_with_type');
    populateHiddenMultiPartField('#audiovisual_work_related_item', 'li.related_item_with_label');
  });
});
