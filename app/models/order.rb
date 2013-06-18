class Order
  include Mongoid::Document

  belongs_to :customer
  embeds_many :items
  index({"items.shopify_id" => 1}, {unique: true})
  embeds_one :address

  field :shopify_id, type: Integer
  field :landing_site, type: String
  field :customer_id, type: String

end
