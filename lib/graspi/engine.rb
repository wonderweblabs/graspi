module Graspi
  class Engine < ::Rails::Engine
    isolate_namespace Graspi
    engine_name 'graspi'

    # add graspi helpers to app
    initializer 'graspi.add_helpers' do |app|
      ActiveSupport.on_load(:action_view) do
        include Graspi::AssetsIncludeHelper
      end
    end

  end
end
