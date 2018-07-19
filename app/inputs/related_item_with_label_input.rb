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
    options[:class] += ["#{input_dom_id} form-control multi-text-field"]
    options[:'aria-labelledby'] = label_id
    options
  end

  def url_input_html_options(value)
    common_field_options.dup.merge(
      name: "#{@builder.object_name}[related_item_url][]",
      id: nil,
      required: nil,
      value: value
    )
  end

  def label_input_html_options(value)
    common_field_options.dup.merge(
      name: "#{@builder.object_name}[related_item_label][]",
      id: nil,
      required: nil,
      value: value
    )
  end

  def build_field(value, _index)
    @rendered_first_element = true
    output = @builder.text_field(:related_item_url, url_input_html_options(value[0]))
    output += @builder.text_field(:related_item_label, label_input_html_options(value[1]))
    output
  end
end
