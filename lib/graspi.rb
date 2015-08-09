require 'yaml'
require 'json'

module Graspi

  def self.root
    File.expand_path '../..', __FILE__
  end

  def self.grunt_root
    self.config().options['gruntRoot']
  end

  def self.config_file
    @@config_file ||= 'graspi.yml'
  end

  def self.config_file=(config)
    @@config_file = config
  end

  def self.config
    @@config ||= Graspi::Config.new(self.config_file)
  end

  def self.manifest(env_name, mod_name)
    self.config().manifest(env_name, mod_name)
  end

  def self.manifest_resolve_path(env_name, file)
    file = file.split('/')

    self.manifest(env_name, file.shift).resolve_path(file.join('/'))
  end

  def self.manifest_resolve_absolute_path(env_name, file)
    file = file.split('/')

    self.manifest(env_name, file.shift).resolve_absolute_path(file.join('/'))
  end

  require 'graspi/rails' if defined?(Rails)
  require 'graspi/middleman' if defined?(Middleman)

  require 'graspi/config'
  require 'graspi/manifest'

end