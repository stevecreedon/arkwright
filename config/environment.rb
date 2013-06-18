# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Arkwright::Application.initialize!

ShopifyAPI::Base.site = LightArt::Configuration.config.url
