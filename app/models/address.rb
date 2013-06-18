class Address
  include Mongoid::Document
  embedded_in :order

  field :address1, type: String
  field :address2, type: String 
  field :city, type: String
  field :company, type: String 
  field :country, type: String
  field :first_name, type: String
  field :shopify_id, type: Integer
  field :last_name, type: String
  field :phone, type: String
  field :province, type: String
  field :zip, type: String
  field :name, type: String
  field :province_code, type: String
  field :country_code, type: String
  #field :default, type: Boolean

end
