module Bridgetown
  module PictureTag
    def self.site
      Bridgetown.sites.first
    end

    def self.config
      site.config.picture_tag
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