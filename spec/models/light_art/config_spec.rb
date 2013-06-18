require 'spec_helper'

describe LightArt::Configuration do

  let(:paths){[File.join('spec','fixtures','shopify','auth.yaml')]}
  let(:non_existant_path){File.join('some','bad','path','auth.yaml')}
  let(:test_yaml){{"development"=>nil, "test"=>{"url"=>"https://some-test-shop-url"}, "production"=>nil}}

  before(:each){LightArt::Configuration.paths = paths}
  
  describe 'yaml' do

    it 'should load the yaml file specified in path if it exists' do
      yaml = LightArt::Configuration.yaml.should == test_yaml
    end

    it 'should load the first yaml file that exists' do
      LightArt::Configuration.paths.unshift non_existant_path #this put the non-existent path first in the paths array
      LightArt::Configuration.yaml.should == test_yaml
    end

    it 'should raise an error if the auth file does not exist i any path' do
      LightArt::Configuration.paths = [non_existant_path]
      lambda do
        LightArt::Configuration.yaml
      end.should raise_error(ArgumentError,"no yaml files exist in the paths #{LightArt::Configuration.paths}")
    end

  end

  describe 'config' do

    it 'should return the portion of the yaml data that matches the rails environemnt as an openstruct' do
      LightArt::Configuration.config.should == OpenStruct.new(test_yaml['test'])
    end

  end

end

