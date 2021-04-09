# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'pdf2htmlex'

RSpec.configure do |config|
  config.mock_framework = :mocha
end
