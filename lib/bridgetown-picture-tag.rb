
# frozen_string_literal: true

require "bridgetown"

require "bridgetown-picture-tag/utils"
require "bridgetown-picture-tag/format"
require "bridgetown-picture-tag/builder"
require "bridgetown-picture-tag/processors/picture_processor"
require "bridgetown-picture-tag/processors/processed_image"
require "bridgetown-picture-tag/processors/unprocessed_image"
require "bridgetown-picture-tag/picture_tag_for"

# rubocop:disable Metrics/ParameterLists
Bridgetown.initializer :"bridgetown-picture-tag" do |config,
  formats: nil,
  widths: nil,
  format_order: nil,
  transformations: nil|

  options = {
    formats: formats || %w[original webp jxl avif],
    widths: widths || [200, 400, 800, 1200, 1600],
    transformations: transformations || {},
    format_order: format_order || %w[jxl avif webp jpeg png]
  }

  if config.picture_tag
    config.picture_tag Bridgetown::Utils.deep_merge_hashes(options, config.picture_tag)
  else
    config.picture_tag(options)
  end

  config.builder Bridgetown::PictureTag::Builder
end
# rubocop:enable Metrics/ParameterLists
