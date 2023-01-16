module Bridgetown
  module PictureTag
    module Processors
      class PictureProcessor

        def initialize(site, path)
          Bridgetown::PictureTag.site = site
          @images = []

          path_without_forward_slash = path.delete_prefix("/")
          @path = Bridgetown::PictureTag.site_source.join(path_without_forward_slash)
        end

        attr_reader :images

        def process!(**params)
          @images = UnprocessedImage.new(self).process_images
        end

        def path
          Bridgetown::PictureTag.site_source.join(@path)
        end
      end
    end
  end
end