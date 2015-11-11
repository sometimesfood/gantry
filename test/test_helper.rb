$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require_relative 'test_helpers/test_coverage'
measure_coverage if coverage?

require 'minitest/autorun'
