require 'factory_girl'
require 'faker'

FactoryGirl.define do

  sequence :shopify_id do |n|
    n + 1000000
  end

  factory :order do
    landing_site Faker::Internet.url
  end
 
  factory :order_with_item, :class => Order do
    landing_site Faker::Internet.url
    items {[FactoryGirl.build(:item)]}
  end

  factory :item do
    title Faker::Lorem.sentence(3)
    variant_title  Faker::Lorem.sentence(3)
    quantity 5
    shopify_id
  end

  factory :shopify_item, :class => ShopifyAPI::LineItem do
    title Faker::Lorem.sentence(3)
    variant_title  Faker::Lorem.sentence(3)
    quantity 5
    id {FactoryGirl.generate(:shopify_id)} 
  end

  factory :shopify_order, :class => ShopifyAPI::Order do
    landing_site Faker::Internet.url
  end

  factory :shopify_customer, :class => ShopifyAPI::Customer do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    email Faker::Internet.email 
  end

  factory :customer do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    email Faker::Internet.email
    shopify_id {FactoryGirl.generate(:shopify_id)} 
  end

  factory :shopify_address, :class => ShopifyAPI::ShippingAddress do
    address1 Faker::Address.street_address
    address2 Faker::Address.street_address 
    city Faker::Address.city
    company ''
    country Faker::Address.country
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    phone Faker::PhoneNumber.phone_number
    province ''
    zip Faker::Address.zip_code
    name {"#{first_name} #{last_name}"}
    province_code nil
    country_code Faker::Lorem.characters(2).upcase
  end

  factory :address do
    address1 Faker::Address.street_address
    address2 Faker::Address.street_address 
    city Faker::Address.city
    company ''
    country Faker::Address.country
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    phone Faker::PhoneNumber.phone_number
    province ''
    zip Faker::Address.zip_code
    name {"#{first_name} #{last_name}"}
    province_code nil
    country_code Faker::Lorem.characters(2).upcase
  end


end
