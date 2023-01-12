module Bridgetown
  module PictureTag
    class PictureTagFor
      def initialize(processor)
        @processor = processor
      end

      def out(**params)
        picture_tag(**params.slice(:class, :id, :alt))
      end

      private

      def path
        @processor.path
      end

      def images
        @processor.images
      end

      def picture_tag(**params)
        picture_attrs = Utils.attributify params.slice(:class, :id)
        img_attrs = Utils.attributify params.slice(:alt).merge(title: params[:alt])

        <<~TAG
        <picture #{picture_attrs}>
          #{sources}
          <img src="#{path}" #{img_attrs}>
        </picture>
        TAG
          .html_safe
      end

      def sources
        images
          .sort_by(&:width)
          .group_by(&:desired_format)
          .sort_by do |format, _|
            PictureTag.config.format_order.index(format.desired_ext)
          end
          .map { |format, images| source_tag_for(format, images) }
          .join("\n")
          .html_safe
      end

      def source_tag_for(format, images)
        srcset = images.map { |file| "#{file.output_src_path} #{file.width}w" }.join(",")

        "<source #{Utils.attributify(type: format.mime, srcset: srcset)}>".html_safe
      end
    end
  end
end