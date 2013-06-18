require 'yaml'
require 'ostruct'

module LightArt
  module Configuration 
    extend self    

    attr_accessor :paths

    self.paths = [File.join(ENV['HOME'], '.shopify', 'auth.yaml')]

    def yaml
      paths.each do |path|
        return YAML.load_file(path) if File.exists?(path)
      end
      raise ArgumentError.new "no yaml files exist in the paths #{LightArt::Configuration.paths}"
    end

    def config
      OpenStruct.new(yaml[Rails.env]) 
    end

  end
end
