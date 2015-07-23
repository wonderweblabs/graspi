# for rails
if defined?(Rails)
  require 'rails/all'

  require "graspi/engine"

  require "graspi/helpers/assets_include_helper"
end

require 'yaml'
require 'json'

module Graspi

  def self.root
    File.expand_path '../..', __FILE__
  end

  def self.config_file
    @@config_file ||= 'graspi.yml'
  end

  def self.config_file=(config)
    @@config_file = config
  end

  def self.config(env = nil)
    @@config ||= begin
      config = {}
      config_yaml = YAML.load_file(self.config_file)

      config_yaml['environments'].each do |env_name|
        config[env_name] = config_yaml[env_name].clone
      end

      config_yaml['environments'].each do |env_name|
        config_yaml.delete(env_name)
      end

      config_yaml['environments'].each do |env_name|
        config[env_name] = config_yaml.clone.merge(config[env_name])
      end

      config
    end

    if env.nil?
      @@config
    else
      @@config[env]
    end
  end

  def self.manifest_path(env)
    File.join(Graspi.root, self.config(env)['manifest']['path'])
  end

  def self.manifest(env)
    file = File.read(self.manifest_path(env))

    JSON.parse(file)[env]
  end

end