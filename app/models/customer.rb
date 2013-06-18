class Customer
  include Mongoid::Document

  has_many :orders

  field :shopify_id, type: String
  field :email, type: String
  field :first_name, type: String
  field :last_name, type: String
end
