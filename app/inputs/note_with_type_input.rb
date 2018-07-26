# Copyright 2011-2018, The Trustees of Indiana University and Northwestern
# University. Additional copyright may be held by others, as reflected in
# the commit history.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

class NoteWithTypeInput < MultiValueInput
  # Override to include note_with_type class
  def inner_wrapper
    <<-HTML
      <li class="field-wrapper note_with_type">
        #{yield}
      </li>
    HTML
  end

  def common_field_options
    options = {}
    options[:class] ||= []
    options[:class] += ["#{input_dom_id} form-control multi-text-field multi_value"]
    options[:'aria-labelledby'] = label_id
    options
  end

  def select_input_html_options
    common_field_options.dup.merge(
      name: "#{@builder.object_name}[note_type][]",
      id: nil,
      required: nil
    )
  end

  def text_area_input_html_options(value)
    common_field_options.dup.merge(
      name: "#{@builder.object_name}[note_body][]",
      id: nil,
      required: nil,
      value: value
    )
  end

  def build_field(value, _index)
    @rendered_first_element = true
    note_type_choices = Hyrax::NoteTypesService.select_options
    output = @builder.select(:note_type, note_type_choices, { selected: value[0] }, select_input_html_options)
    output += @builder.text_area(:note_body, text_area_input_html_options(value[1]))
    output
  end
end
