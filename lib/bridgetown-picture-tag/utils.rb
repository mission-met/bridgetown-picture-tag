module Bridgetown
  module PictureTag
    mattr_accessor :site

    def self.site_source
      Pathname.new(
        site.source
      )
    end

    def self.config_generation_destination
      site_source.join(config.generation_destination)
    end

    def self.config_download_destination
      site_source.join(config.download_destination)
    end

    def self.config
      site.config.picture_tag
    end

    def self.cache
      @cache ||= Bridgetown::Cache.new("bridgetown-picture-tag")
    end

    module Utils
      # convert hash from {class: "something", id: nil}
      # to class="something"
      def self.attributify(hash)
        hash
          .with_indifferent_access
          .compact
          .map do |attr, option|
            "#{attr}=\"#{Bridgetown::Utils.xml_escape(option)}\""
          end
          .join(" ")
      end
    end
  end
end