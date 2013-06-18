class Item
  include Mongoid::Document
  embedded_in :order

  field :shopify_id, type: Integer
  field :title, type: String
  field :variant_title, type: String
  field :quantity, type: Integer

end
