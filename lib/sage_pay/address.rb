class SagePay::Address < ActiveRecord::Base
  
  set_table_name 'sage_pay_addresses'
  
  validates_presence_of :surname, :first_names, :address_1, :city, :post_code, :country
  validates_presence_of :state, :if => 'country == "US"'
  validates_length_of :surname, :first_names, :maximum => 20
  validates_length_of :address_1, :maximum => 100
  validates_length_of :address_2, :maximum => 100, :allow_nil => true, :allow_blank => true
  validates_length_of :city, :maximum => 40
  validates_length_of :phone, :maximum => 20, :allow_nil => true, :allow_blank => true
  validates_length_of :post_code, :maximum => 10
  validates_length_of :country, :is => 2, :if => '!country.blank?'
  validates_length_of :state, :is => 2, :if => 'country == "US" and !state.blank?'
  
end