module Bridgetown
  module PictureTag
    class Format
      def self.formats
        @@formats ||= []
      end

      def self.find(ext)
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

      def to_s
        desired_ext
      end

      def extensions
        Array(@extensions || [@desired_ext]).map(&:to_s)
      end

      def matches?(ext)
        extensions.include?(ext.to_s)
      end

      def vips_format
        @vips_format || @desired_ext
      end

      def mime
        @mime || "image/#{@desired_ext}"
      end
    end

    AVIFFormat = Format.new(desired_ext: "avif")
    GIFFormat = Format.new(desired_ext: "gif")
    JPEGFormat = Format.new(desired_ext: "jpeg", extensions: %w[jpg jpeg jpe jif jfif jfi])
    JXLFormat = Format.new(desired_ext: "jxl")
    PNGFormat = Format.new(desired_ext: "png")
    WEBPFormat = Format.new(desired_ext: "webp")
  end
end


