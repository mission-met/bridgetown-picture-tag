module Bridgetown
  module PictureTag
    class Format
      def self.formats
        @@formats ||= []
      end

      def self.find(ext)
        ext = ext.to_s
        formats.find { |format| format.matches?(ext) }
      end

      def initialize(desired_ext:, extensions: nil, vips_format: nil, mime: nil)
        @extensions = extensions
        @desired_ext = desired_ext
        @vips_format = vips_format
        @mime = mime

        @@formats ||= []
        @@formats << self
      end

      attr_reader :desired_ext

      def extensions
        @extensions || [@desired_ext]
      end

      def matches?(ext)
        extensions.include?(ext)
      end

      def vips_format
        @vips_format || @desired_ext
      end

      def mime
        @mime || "image/#{@desired_ext}"
      end
    end

    JPEGFormat = Format.new(desired_ext: "jpeg", extensions: %w[jpg jpeg jpe jif jfif jfi])
    WEBPFormat = Format.new(desired_ext: "webp")
    AVIFFormat = Format.new(desired_ext: "avif")
    JXLFormat = Format.new(desired_ext: "jxl")
  end
end


