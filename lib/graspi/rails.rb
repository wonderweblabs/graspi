require 'rails/all'

require "graspi/rails/engine"

require "graspi/rails/helpers/assets_include_helper"


module Graspi
  module Rails

    # main application
    mattr_accessor :app

  end
end