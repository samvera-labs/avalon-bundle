function inputGroupToObject() {
  return {
    note_type: $(this)
      .find('select')
      .val(),
    note_body: $(this)
      .find('input')
      .val()
  };
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
  });
});
