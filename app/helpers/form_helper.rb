# frozen_string_literal: true

module FormHelper
  def label_for(form, field, options)
    field_name = field.to_s.capitalize.gsub("_", " ")
    text = "#{field_name} #{form.object.errors[field].first}"
    form.label(field, text, options)
  end
end
