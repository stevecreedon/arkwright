module LightArt
  module Shopify
  extend self


     def import
      ShopifyAPI::Order.all.each do |shopify_order|
        to_order(shopify_order)
      end
    end

    def to_order(shopify_order)
      order = Order.find_or_initialize_by(shopify_id: shopify_order.id)
      order.landing_site = shopify_order.landing_site
      order.customer = customer(shopify_order.customer)
      order.address = address(order, shopify_order.shipping_address)
      shopify_order.line_items.each do |shopify_item|
        order.items << item(order, shopify_item)
      end
      order.customer.save
      order.save
    end

    def customer(shopify_customer)
      customer = find_or_initialize_customer(shopify_customer)
      build_model(customer, shopify_customer, :first_name, :last_name, :email)
      customer.save
      customer
    end

    def item(order, shopify_line_item)
      item = find_or_initialize_item(order, shopify_line_item)
      build_model(item, shopify_line_item, :title,:variant_title,:quantity)
    end

    def address(order, shopify_shipping_address)
      address = find_or_initialize_address(order)
      build_model(address, shopify_shipping_address, :address1, :address2, :city, :company, :country, :first_name, :last_name, :phone, :province, :zip, :name, :province_code, :country_code)
      address
    end

    def find_or_initialize_customer(shopify_customer)
      Customer.find_or_initialize_by(shopify_id: shopify_customer.id)
    end

    def find_or_initialize_item(order, shopify_item)
      order.items.find_or_initialize_by(shopify_id: shopify_item.id)
    end

    def find_or_initialize_address(order)
      order.address || Address.new  
    end

    def build_model(*args)
      model = args.shift
      shopify_model = args.shift

      raise ArgumentError.new("expected first argument to be a Mongoid document found #{model.class}") unless model.is_a?(Mongoid::Document)
      raise ArgumentError.new("expected second argument to be a subclass of ShopifyAPI::Base found #{shopify_model.class}") unless shopify_model.is_a?(ShopifyAPI::Base) 
      
      args.each do |field|
        model.send("#{field}=".to_sym, shopify_model.send(field))
      end
      model
    end

    
    
  
  end
end
