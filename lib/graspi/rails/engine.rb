module Graspi
  class Engine < ::Rails::Engine
    isolate_namespace Graspi
    engine_name 'graspi'

    # add graspi helpers to app
    initializer 'graspi.add_helpers' do |app|
      ActiveSupport.on_load(:action_view) do
        include Graspi::Rails::AssetsIncludeHelper
      end
    end

    # path - app root
    initializer 'curo.load_app_root' do |app|
      Graspi::Rails.root = app.root
      Graspi::Rails.app = app
    end

  end
end
