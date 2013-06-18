class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.integer :user_id 
      t.timestamps
    end
  end
end
