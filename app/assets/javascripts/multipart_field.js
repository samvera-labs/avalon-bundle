/*
 * Copyright 2011-2018, The Trustees of Indiana University and Northwestern
 * University. Additional copyright may be held by others, as reflected in
 * the commit history.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ---  END LICENSE_HEADER BLOCK  ---
*/

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

  // Try again to focus on the first input field for related item.
  // FIXME: This isn't working and the second input field gets focus
  $('div.audiovisual_work_related_items_with_labels').bind('managed_field:add', function(e, newElement) {
    $(newElement).focus();
  });
});
