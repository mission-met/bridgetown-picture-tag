require "digest/md5"

module Bridgetown
  module PictureTag
    module Processors
      class UnprocessedImage
        def initialize(builder)
          @builder = builder
        end

        def process_images
          PictureTag.config.formats.flat_map do |format|
            PictureTag.config.widths.flat_map do |width|
              pi = ProcessedImage.new(self, format, width)
              pi.process!
              pi
            end
          end
        end

        def md5
          @md5 ||= Digest::MD5.hexdigest(path.read)
        end

        attr_reader :builder

        def path
          @builder.path
        end

        def file_name
          path.basename(".*")
        end

        def file_extension
          path.extname
        end
      end
    end
  end
end