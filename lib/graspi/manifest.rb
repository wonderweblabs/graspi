module Graspi
  class Manifest

    def initialize(env_name, mod_name, path)
      json = File.read(path)

      @env_name = env_name
      @mod_name = mod_name

      @config = JSON.parse(json)[env_name]
    end

    def config
      @config
    end

    def resolve_path(file)
      @config[File.join(@mod_name, file)]
    end

  end
end