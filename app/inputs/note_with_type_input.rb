  class NoteWithTypeInput < MultiValueInput
    # Override to include note_with_type class
    def inner_wrapper
      <<-HTML
        <li class="field-wrapper note_with_type">
          #{yield}
        </li>
      HTML
    end

    def build_field(value, index)
      select_input_html_options = input_html_options.dup.merge({
        name: "#{@builder.object_name}[note_type][]"
      })

      text_input_html_options = input_html_options.dup.merge({
        name: "#{@builder.object_name}[note_body][]",
        value: value[1]
      })

      # Do not set the 'note_type' select to required, since blank option is allowed.
      # But 'note_body' needs to remain required if set.
      select_input_html_options.delete(:required)
      select_input_html_options[:class].delete(:required)
      text_input_html_options[:class] << "multi-text-field"

      # Remove ids to avoid id collisions
      select_input_html_options[:id] = nil
      text_input_html_options[:id] = nil

      if(text_input_html_options[:note_body].blank?)
        if(@rendered_first_element)
          text_input_html_options.delete(:required)
          text_input_html_options[:class].delete(:required)
        end
        @rendered_first_element = true
      end

      note_type_choices = Hyrax::NoteTypesService.select_options
      output = @builder.select(:note_type, note_type_choices, { selected: value[0] }, select_input_html_options)
      output += @builder.text_field(:note_body, text_input_html_options)
      output
    end
  end
