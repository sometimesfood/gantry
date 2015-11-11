require 'open3'
require 'tmpdir'
require 'rubygems/package'

require 'gantry/layer_enumerator'
require 'gantry/nested_tar_extractor'

module Gantry
  class ImageExtractor
    def initialize(image_name, image_version)
      @image_name = image_name
      @image_version = image_version
    end

    def extract_to(target_dir)
      Dir.mktmpdir('gantry') do |dir|
        image_path = File.join(dir, "#{image_name}-#{image_version}.tar")
        save_image(image_path)
        image_layers(image_path).each do |layer|
          extract_layer(image_path, layer, target_dir)
        end
      end
    end

    private

    def image_layers(image_path)
      image_reader = Gem::Package::TarReader.new(File.open(image_path))
      enumerator = LayerEnumerator.new(image_reader, image_name, image_version)
      enumerator.image_layers
    ensure
      image_reader.close
    end

    def extract_layer(image_path, layer, target_dir)
      layer_path = File.join(layer, 'layer.tar')
      extractor = Gantry::NestedTarExtractor.new(image_path, layer_path)
      extractor.extract_to(target_dir)
    end

    # @todo Add error handling
    def save_image(image_path)
      cmd = %W(docker save -o #{image_path} #{image_name}:#{image_version})
      stdout, stderr, status = Open3.capture3(*cmd)
    end

    attr_reader :image_name, :image_version
  end
end
