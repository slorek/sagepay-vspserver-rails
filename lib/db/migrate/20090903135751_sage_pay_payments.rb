class SagePayPayments < ActiveRecord::Migration
  def self.up
    
    create_table :sage_pay_payments do |t|
      
      t.string :transaction_code
      t.integer :billing_address_id
      t.integer :delivery_address_id
      t.string :payment_type
      t.decimal :amount, :precision => 8, :scale => 2
      t.string :currency
      t.string :description
      t.string :customer_email
      t.string :vps_transaction_id
      t.string :security_key
      t.string :auth_no
      t.string :card_type
      t.string :card_last_4_digits
      t.string :status
      
      t.timestamps
    end
  end

  def self.down
    drop_table :sage_pay_payments
  end
end
