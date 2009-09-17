class SagePayAddresses < ActiveRecord::Migration
  def self.up
    
    create_table :sage_pay_addresses do |t|
      
      t.string :surname
      t.string :first_names
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :post_code
      t.string :country
      t.string :state
      t.string :phone
      
      t.timestamps
    end
  end

  def self.down
    drop_table :sage_pay_addresses
  end
end
