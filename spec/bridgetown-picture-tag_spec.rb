# frozen_string_literal: true

require "spec_helper"

module TestValues
  class << self
    attr_accessor :config
  end
end

describe(Bridgetown::PictureTag) do
  let(:config) {
    TestValues::config ||= Bridgetown.configuration(Bridgetown::Utils.deep_merge_hashes({
      "full_rebuild" => true,
      "root_dir"     => root_dir,
      "source"       => source_dir,
      "destination"  => dest_dir
    }, overrides)).tap do |conf|
      conf.run_initializers! context: :static
    end
  }

  describe "plugin behavior" do
    let(:overrides) { {} }
    let(:metadata_overrides) { {} }
    let(:metadata_defaults) do
      {
        "name" => "My Awesome Site",
        "author" => {
          "name" => "Ada Lovejoy",
        }
      }
    end
    let(:site) { Bridgetown::Site.new(config) }

    before(:each) do
      metadata = metadata_defaults.merge(metadata_overrides).to_yaml.sub("---\n", "")
      File.write(source_dir("_data/site_metadata.yml"), metadata)
      site.process
      FileUtils.rm(source_dir("_data/site_metadata.yml"))
    end

    before(:all) { remove_generated_image_files! }
    after(:all) { remove_generated_image_files! }

    def remove_generated_image_files!
      FileUtils.rm_rf(
        source_dir("assets/images/generated")
      )
      FileUtils.rm_rf(
        source_dir("assets/images/downloaded")
      )
    end

    [:liquid, :erb].each do |rendering_engine_type|
      context "#{rendering_engine_type} tag" do
        let(:contents) { File.read(dest_dir("index-#{rendering_engine_type}.html")) }
        let(:page) { Capybara::Node::Simple.new(contents) }

        [:direct_path, :download_url].each do |image_type|
          describe image_type.to_s.humanize do
            it "includes id" do
              expect(page).to have_css("picture[id='#{image_type}']")
            end

            it "includes class" do
              expect(page).to have_css("picture[id='#{image_type}'].responsive")
            end

            it "includes alt" do
              expect(page).to have_css("picture[id='#{image_type}'] img[alt='Awesome Alt']")
            end

            it "includes alt as title" do
              expect(page).to have_css("picture[id='#{image_type}'] img[title='Awesome Alt']")
            end

            it "img should be jpeg" do
              expect(page.find("picture[id='#{image_type}'] img[alt='Awesome Alt']")[:src]).to match(/\.jpg$/)
            end

            it "sets sources" do
              webp = page.find("picture[id='#{image_type}'] source[type='image/webp']")
              expect(webp).to be_present
              expect(src_set_sizes(webp)).to eq(Bridgetown::PictureTag.config.widths)

              jxl = page.find("picture[id='#{image_type}'] source[type='image/jxl']")
              expect(jxl).to be_present
              expect(src_set_sizes(jxl)).to eq(Bridgetown::PictureTag.config.widths)

              avif = page.find("picture[id='#{image_type}'] source[type='image/avif']")
              expect(avif).to be_present
              expect(src_set_sizes(avif)).to eq(Bridgetown::PictureTag.config.widths)

              jpeg = page.find("picture[id='#{image_type}'] source[type='image/jpeg']")
              expect(jpeg).to be_present
              expect(src_set_sizes(jpeg)).to eq(Bridgetown::PictureTag.config.widths)
            end

            def src_set_sizes(source)
              source[:srcset].split(/\s|,/).select { |section| section =~ /\d.w$/ }.map(&:to_i)
            end

            it "sets sources in correct order" do
              all_source_types =
                page
                  .all("picture[id='#{image_type}'] source")
                  .map { |source| source[:type] }

              expect(all_source_types).to eq(
                [
                  "image/jxl",
                  "image/avif",
                  "image/webp",
                  "image/jpeg"
                ]
              )
            end
          end
        end
      end
    end

    # xcontext "transformations" do
    #   it "outputs a custom transformation" do
    #     expect(contents).to match '<img alt="Transformation" src="https://res.cloudinary.com/bridgetown_test/image/upload/w_4096,c_limit,q_65/local_id.jpg" />'
    #   end
    # end

    # xcontext "image generator" do
    #   it "sets the page's image variable default path" do
    #     expect(contents).to match "image: https://res.cloudinary.com/bridgetown_test/image/upload/c_fill,g_face:center,w_1600,h_900,q_50/the_id_123.jpg"
    #   end
    # end
  end
end
