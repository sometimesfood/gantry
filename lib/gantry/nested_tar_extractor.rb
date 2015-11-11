require 'fileutils'
require 'open3'

module Gantry
  # Nested tarfile extractor. Uses tar(1) rather than a native Ruby
  # implementation because it implements long (GNU) file names and
  # preserves file owners, types and permissions.
  class NestedTarExtractor
    def initialize(tar_filename, nested_tar_filename)
      @tar_filename = tar_filename
      @nested_tar_filename = nested_tar_filename
    end

    # @todo: Add error handling
    def extract_to(target_directory)
      FileUtils.mkdir_p(target_directory)
      Dir.chdir(target_directory) do
        Open3.pipeline(untar_outer_cmd, untar_inner_cmd)
      end
    end

    private

    attr_reader :tar_filename, :nested_tar_filename

    def untar_outer_cmd
      %W(tar -xOf #{tar_filename} #{nested_tar_filename})
    end

    def untar_inner_cmd
      %w(tar -x)
    end
  end
end
