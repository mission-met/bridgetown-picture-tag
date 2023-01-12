module Bridgetown
  module PictureTag
    module Processors
      class PictureProcessor
        def initialize(site, path)
          @site, @path, @images = site, path, []
        end

        attr_reader :images

        def process!(**params)
          @images = UnprocessedImage.new(self, to).process_images
        end

        def to
          source.join("assets/images/generated")
        end

        def path
          source.join(@path)
        end

        def source
          Pathname.new(@site.source)
        end
      end
    end
  end
end