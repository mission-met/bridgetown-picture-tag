require "image_processing/vips"

class Bridgetown::PictureTag::Processors::ProcessedImage
  def initialize(unprocessed_image, to, format, width)
    @unprocessed_image, @to, @format_str, @width = unprocessed_image, to, format, width
  end

  attr_reader :width, :processed

  def output_filename
    @to.join("#{unprocessed_image.md5}/#{unprocessed_image.file_name}-#{width}.#{ext}")
  end

  def output_src_path
    "/#{output_filename.relative_path_from(unprocessed_image.builder.source)}"
  end

  def desired_format
    f = @format_str

    if @format_str == "original"
      f = unprocessed_image.file_extension.gsub(".", "")
    end

    Bridgetown::PictureTag::Format.find(f)
  end

  def ext
    desired_format.desired_ext
  end

  def convert
    desired_format.vips_format
  end

  def process!
    return unless process?

    mkpath!

    ops = {
      source: unprocessed_image.path,
      resize_to_limit: [@width, nil],
      convert: convert
    }

    @processed =
      ImageProcessing::Vips
      .apply(ops.compact)
      .call(destination: output_filename.to_s)
  end

  private

  attr_reader :unprocessed_image

  def mkpath!
    output_filename.dirname.mkpath
  end

  def process?
    !output_filename.file?
  end
end