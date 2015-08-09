module Graspi
  class Config

    def initialize(config_file)
      @merged_config = YAML.load_file(config_file)['mergedConfig']
    end

    def options
      @merged_config['options']
    end

    def env(env_name)
      @merged_config['environments'][env_name.to_s]
    end

    def emc_config(env_name, mod_name)
      env(env_name)['modules'][mod_name.to_s]
    end

    def grunt_root
      options['gruntRoot']
    end

    def manifest(env_name, mod_name)
      emc = emc_config(env_name, mod_name)
      path = File.join(grunt_root, emc['postpipeline']['manifest']['options']['path'])

      Graspi::Manifest.new(env_name, mod_name, path)
    end

  end
end