require 'json'

module Gantry
  class LayerEnumerator
    def initialize(image_reader, image, version)
      @image_reader = image_reader
      @image = image
      @version = version
    end

    def image_layers
      layers = []
      next_layer = top_layer
      while next_layer
        layers.unshift(next_layer)
        next_layer = parent_layer(next_layer)
      end
      layers
    end

    private

    attr_reader :image_reader, :image, :version

    def top_layer
      repo_filename = 'repositories'
      image_reader.seek(repo_filename) do |repo_file|
        repo = JSON[repo_file.read]
        repo[image][version]
      end
    end

    def parent_layer(layer)
      layer_info_filename = File.join(layer, 'json')
      image_reader.seek(layer_info_filename) { |f| JSON[f.read]['parent'] }
    end
  end
end
