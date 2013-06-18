require 'spec_helper'

describe LightArt::Shopify do

  let(:shopify_customer){FactoryGirl.build(:shopify_customer)}
  let(:shopify_item){FactoryGirl.build(:shopify_item)}
  let(:shopify_address){FactoryGirl.build(:shopify_address)}
  let(:order){FactoryGirl.build(:order)}
    
  
  describe 'customer' do

    it 'should populate the customer object with the shopify customer object' do

      customer = subject.customer(shopify_customer)

      customer.email.should == shopify_customer.email
      customer.first_name.should == shopify_customer.first_name
      customer.last_name.should == shopify_customer.last_name

    end

    it 'should save the customer object' do
      customer = FactoryGirl.build(:customer)
      customer.should_receive(:save).once
      subject.stub(:find_or_initialize_customer).with(shopify_customer).and_return(customer)
      customer = subject.customer(shopify_customer)
   end


    describe 'find_or_initialize' do

      it 'should build a new customer if one does not exist with the id of the shopify object' do
        customer = subject.find_or_initialize_customer(shopify_customer)
        customer.should be_a Customer
        customer.new_record?.should be_true
      end

      it 'should return an existing customer if one exists with the id of a shopify customer object' do
        customer = FactoryGirl.create(:customer, shopify_id: shopify_customer.id)
        subject.find_or_initialize_customer(shopify_customer).should == customer
      end

    end

  end

  describe 'item' do

    it 'should populate the item object with the shopify item object' do
      item = subject.item(order, shopify_item)
      item.title.should == shopify_item.title
      item.variant_title.should == shopify_item.variant_title
      item.quantity.should == shopify_item.quantity
    end

    describe 'find_or_initialize_item' do

      it 'should build a new item if one does not exist with the id of the shopify object' do
        item = subject.find_or_initialize_item(order, shopify_item)
        item.should be_a Item
        item.new_record?.should be_true
      end

      it 'should return an existing item if one exists with the id of a shopify customer object' do
        order = FactoryGirl.build(:order_with_item) #note that build works as well as create because we are searching on the order.items embedded objects not the Item collection
        item = order.items.last
        subject.find_or_initialize_item(order, FactoryGirl.build(:shopify_item, id: item.shopify_id)).should == item
      end

    end
    

  end

  describe 'address' do
    
    it 'should populate the address with the shopify address object' do
      address = subject.address(order, shopify_address)
      
      address.address1.should == shopify_address.address1
      address.address2.should == shopify_address.address2 
      address.city.should == shopify_address.city
      address.company.should == shopify_address.company
      address.country.should == shopify_address.country
      address.first_name.should == shopify_address.first_name
      address.last_name.should == shopify_address.last_name
      address.phone.should == shopify_address.phone
      address.province.should == shopify_address.province
      address.zip.should == shopify_address.zip
      address.name.should == shopify_address.name
      address.province_code.should == shopify_address.province_code
      address.country_code.should == shopify_address.country_code

    end

    describe 'find_or_initialize_address' do

      it 'should build a new item if one does not exist with the id of the shopify object' do
        address = subject.find_or_initialize_address(order)
        address.should be_a Address
        address.new_record?.should be_true
      end

      it 'should return an existing item if one exists with the id of a shopify customer object' do
        order = FactoryGirl.build(:order)
        order.address = FactoryGirl.build(:address)
        subject.find_or_initialize_address(order).should == order.address
      end

    end
  end

  describe 'build_model' do

    class Foo
      include Mongoid::Document
    end

    class Bar < ShopifyAPI::Base
    end

    it 'should read the supplied fields from the shopify object to the model' do
       model = Foo.new
       shopify_model = Bar.new(method1: 'result1', method2: 'result2', method3: 'result3', method4: 'result4')

       model.should_receive(:method1=).with('result1').once
       model.should_receive(:method2=).with('result2').never
       model.should_receive(:method3=).with('result3').once
       model.should_receive(:method4=).with('result4').never

       subject.build_model(model, shopify_model, :method1, :method3)
    end

    it 'should raise an error if the first argument is not a model (a Mongoid::Document)' do
      model = [] #it should be a mongoID document such as Foo, Customer etc.
      shopify_model = Bar.new
      lambda do
        subject.build_model(model, shopify_model, :method1)
      end.should raise_error(ArgumentError, "expected first argument to be a Mongoid document found Array")
    end

    it 'should raise an error if the second argument is not a shopify model' do
      model = Foo.new
      shopify_model = {} #it should be a subclass of ShopifyAPI::Base
      lambda do
        subject.build_model(model, shopify_model, :method1)
      end.should raise_error(ArgumentError, "expected second argument to be a subclass of ShopifyAPI::Base found Hash")
    end

  end

  
end

