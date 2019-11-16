# frozen_string_literal: true

module NotificationHelper
  def notification_text(notification)
    result = notification.text.gsub /\*[^\*]+\*/ do |bold|
      "<span class=\"bold\">#{bold.gsub('*', '')}</span>"
    end
    result.html_safe
  end
end
