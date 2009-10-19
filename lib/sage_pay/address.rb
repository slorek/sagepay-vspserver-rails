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

  validates_format_of :phone, :with => /\A[-\  0-9A-Za-z\(\)\+]{0,20}\Z/, :message => 'Only numbers, letters, spaces, -, (), and + are allowed'
  validates_format_of :state, :with => /\A[A-Z]{2}\Z/, :if => 'country == "US" and !state.blank?'
  validates_format_of :country, :with => /\A[A-Z]{2}\Z/
  validates_format_of :post_code, :with => /\A[-\ 0-9A-Za-z]{0,10}\Z/
  
end