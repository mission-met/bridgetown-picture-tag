
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
Bridgetown.initializer :"bridgetown-picture-tag" do |config, **options|
  options[:generation_destination] ||= "assets/images/generated"
  options[:download_destination] ||= "assets/images/downloaded"
  options[:format_order] ||= %w[jxl avif webp jpeg png]
  options[:formats] ||= %w[original webp jxl avif]
  options[:transformations] ||= {}
  options[:widths] ||= [200, 400, 800, 1200, 1600]

  if config.picture_tag
    config.picture_tag Bridgetown::Utils.deep_merge_hashes(options, config.picture_tag)
  else
    config.picture_tag(options)
  end

  config.builder Bridgetown::PictureTag::Builder
end
# rubocop:enable Metrics/ParameterLists
