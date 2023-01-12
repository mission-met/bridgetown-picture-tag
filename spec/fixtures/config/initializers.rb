# frozen_string_literal: true

Bridgetown.configure do
  # partial config here, also in bridgetown.config.yml
  init :"bridgetown-picture-tag" do
    formats ["jxl", "webp", "avif", "jpeg"]
    widths [320, 640, 960, 1280, 1920, 2560]
  end
end
