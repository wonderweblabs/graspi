$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "graspi/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "graspi"
  s.version     = Graspi::VERSION
  s.authors     = ["Sascha Hillig"]
  s.email       = ["sascha@wonderweblabs.com"]
  s.homepage    = "https://www.wonderweblabs.com"
  s.summary     = "Grunt asset pipeline with additional helpers for rails and middleman"
  s.description = <<-EOS
    Grunt asset pipeline for css, js, images, html templates and web components.
    Additionally graspi provides some helper methods for rails and middleman.
  EOS
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

end
