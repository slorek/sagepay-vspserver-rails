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

    add_index :sage_pay_payments, :transaction_code
    add_index :sage_pay_payments, :billing_address_id
    add_index :sage_pay_payments, :delivery_address_id
    add_index :sage_pay_payments, :vps_transaction_id
    add_index :sage_pay_payments, :status
  end

  def self.down
    drop_table :sage_pay_payments
  end
end
