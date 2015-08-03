# for rails
if defined?(Rails)
  require 'rails/all'

  require "graspi/engine"

  require "graspi/helpers/assets_include_helper"
  require 'graspi/rails'
end

require 'yaml'
require 'json'

require 'graspi/config'
require 'graspi/manifest'

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

end