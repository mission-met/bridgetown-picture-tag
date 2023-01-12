module Bridgetown
  module PictureTag
    module Processors
      class PictureProcessor
        def initialize(site, url_or_path)
          Bridgetown::PictureTag.site = site
          @url_or_path, @images = url_or_path, []

          process_path!
        end

        attr_reader :images

        def process!(**params)
          @images = UnprocessedImage.new(self).process_images
        end

        def path
          Bridgetown::PictureTag.site_source.join(@path)
        end

        private

        def process_path!
          @path =
            if @url_or_path.start_with?("http")
              Bridgetown::PictureTag::Processors::Downloader.new(@url_or_path).path
            else
              path_without_forward_slash = @url_or_path.delete_prefix("/")
              Bridgetown::PictureTag.site_source.join(path_without_forward_slash)
            end
        end
      end
    end
  end
end