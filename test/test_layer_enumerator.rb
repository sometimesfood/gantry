require_relative 'test_helper'

require 'gantry/layer_enumerator'

class TarReaderDouble
  def initialize(files_hash)
    @files = files_hash
  end

  def seek(path)
    yield StringIO.new(files[path])
  end

  private

  attr_reader :files
end

class TestLayerEnumerator < MiniTest::Unit::TestCase
  def test_image_layers
    image_name = 'debian'
    image_version = 'jessie'
    files = {
      'repositories' => {
        image_name => { image_version => 'top_layer' }
      }.to_json,
      'top_layer/json' => { parent: 'middle_layer' }.to_json,
      'middle_layer/json' => { parent: 'bottom_layer' }.to_json,
      'bottom_layer/json' => {}.to_json
    }
    image_reader = TarReaderDouble.new(files)
    enumerator = Gantry::LayerEnumerator.new(image_reader,
                                             image_name,
                                             image_version)

    expected = %w(bottom_layer middle_layer top_layer)
    actual = enumerator.image_layers
    assert_equal(expected, actual)
  end
end
