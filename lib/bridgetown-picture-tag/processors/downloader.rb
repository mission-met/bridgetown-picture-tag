module Bridgetown
  module PictureTag
    module Processors
      class Downloader
        def initialize(url)
          @url = url
        end

        def path
          # parse url for naming
          domain = url.host
          ext = File.extname(url.path)
          filename = File.basename(url.path, ".*")

          # set path
          download_path = "#{domain}/#{filename}-#{identifier}#{ext}"
          full_download_path = Bridgetown::PictureTag.config_download_destination.join(download_path)
          FileUtils.mkdir_p(full_download_path.dirname)

          # conditionally write file
          if !File.exist?(full_download_path)
            File.write(full_download_path, response_body)
          end

          full_download_path
        end

        private

        def url
          URI.parse(@url)
        end

        def head
          @head ||= Faraday.new.head(url)
        end

        def response_body
          @response_body ||= Faraday.new.get(url).body
        end

        def identifier
          (
            head.headers["ETag"] ||
              head.headers["Last-Modified"] ||
              Digest::MD5.hexdigest(response_body)
          ).gsub("\"", "") # remove quotes
        end
      end
    end
  end
end