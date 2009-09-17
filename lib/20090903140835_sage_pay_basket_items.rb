class SagePayBasketItems < ActiveRecord::Migration
  def self.up
    
    create_table :sage_pay_basket_items do |t|

      t.integer :payment_id
      t.string :description
      t.integer :quantity
      t.decimal :cost, :precision => 8, :scale => 2
      t.decimal :tax, :precision => 8, :scale => 2
      
      t.timestamps
    end
  end

  def self.down
    drop_table :sage_pay_basket_items
  end
end
