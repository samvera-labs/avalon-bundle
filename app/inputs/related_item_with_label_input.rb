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

class RelatedItemWithLabelInput < MultiValueInput
  # Override to include note_with_type class
  def inner_wrapper
    <<-HTML
      <li class="field-wrapper related_item_with_label">
        #{yield}
      </li>
    HTML
  end

  def common_field_options
    options = {}
    options[:class] ||= []
    options[:class] += ["#{input_dom_id} form-control multi-text-field multi_value"]
    options[:'aria-labelledby'] = label_id
    options[:style] = 'width:50%'
    options
  end

  def url_input_html_options(value)
    common_field_options.dup.merge(
      name: "#{@builder.object_name}[related_item_url][]",
      id: nil,
      required: nil,
      placeholder: 'URL',
      value: value
    )
  end

  def label_input_html_options(value)
    common_field_options.dup.merge(
      name: "#{@builder.object_name}[related_item_label][]",
      id: nil,
      required: nil,
      placeholder: 'Label',
      value: value
    )
  end

  def build_field(value, _index)
    @rendered_first_element = true
    output = @builder.text_field(:related_item_label, label_input_html_options(value[0]))
    output += @builder.text_field(:related_item_url, url_input_html_options(value[1]))
    output
  end
end
