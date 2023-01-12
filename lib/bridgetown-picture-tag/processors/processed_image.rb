require "image_processing/vips"

class Bridgetown::PictureTag::Processors::ProcessedImage
  def initialize(unprocessed_image, format, width)
    @unprocessed_image, @format_str, @width = unprocessed_image, format, width
  end

  attr_reader :width, :processed

  def output_filename

    Bridgetown::PictureTag
      .site_source
      .join(
        Bridgetown::PictureTag.config.generation_destination
      ).join(
        "#{unprocessed_image.md5}/#{unprocessed_image.file_name}-#{width}.#{desired_format}"
      )
  end

  def output_src_path
    "/" + output_filename.relative_path_from(Bridgetown::PictureTag.site_source).to_s
  end

  def desired_format
    f = @format_str

    if @format_str == "original"
      f = unprocessed_image.file_extension.gsub(".", "")
    end

    Bridgetown::PictureTag::Format.find(f)
  end

  def process!
    return unless process?

    mkpath!

    operations = {
      source: unprocessed_image.path,
      resize_to_limit: [@width, nil],
      convert: desired_format.vips_format
    }

    @processed =
      ImageProcessing::Vips
        .apply(operations.compact)
        .call(destination: output_filename.to_s)
  end

  private

  attr_reader :unprocessed_image

  def mkpath!
    FileUtils.mkdir_p(output_filename.dirname)
  end

  def process?
    !output_filename.file?
  end
end