module  Bridgetown
  module PictureTag
    class Builder < Bridgetown::Builder
      LIQUID_MATCHER = /([a-zA-Z0-9_\-]+)\s*:\s*(#{Liquid::QuotedFragment})/.freeze

      def build
        liquid_tag "picture" do |attributes, tag|
          path, args = attributes.split(",", 2)
          path = unescape_string(path)
          args ||= ""
          args = args.scan(LIQUID_MATCHER).map do |arg|
           [arg[0].to_sym, unescape_string(arg[1])]
          end.to_h

          process(path, **args)
        end

        helper "picture" do |path, attributes|
          process(path, **attributes)
        end
      end

      private

      def process(path, **params)
        processor = Processors::PictureProcessor.new(site, path)
        processor.process!(**params)

        PictureTagFor.new(processor).out(**params)
      end

      def unescape_string(string)
        string.undump
      rescue
        string
      end
    end
  end
end