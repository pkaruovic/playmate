# frozen_string_literal: true

require "rails_helper"

describe NotificationHelper, type: :helper do
  describe "#notification_text" do
    it "renders bold text" do
      notification = build(:notification, text: "*Hello* there my *friend*!")

      expect(helper.notification_text(notification))
        .to eq "<span class=\"bold\">Hello</span> there my <span class=\"bold\">friend</span>!"
    end
  end
end
