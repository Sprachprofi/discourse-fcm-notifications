module ::DiscourseFcmNotifications
  class Engine < ::Rails::Engine
    engine_name PLUGIN_NAME
    isolate_namespace DiscourseFcmNotifications
    config.autoload_paths << File.join(config.root, "lib")
  end
end