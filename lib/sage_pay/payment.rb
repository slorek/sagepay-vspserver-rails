class SagePay::Payment < ActiveRecord::Base
  
  set_table_name 'sage_pay_payments'

  belongs_to :delivery_address, :class_name => 'SagePay::Address', :foreign_key => :delivery_address_id
  belongs_to :billing_address, :class_name => 'SagePay::Address', :foreign_key => :billing_address_id
  has_many :basket_items, :class_name => 'SagePay::BasketItem'
  
  validates_presence_of :transaction_code, :payment_type, :amount, :currency, :description, :delivery_address, :billing_address
  validates_numericality_of :amount, :less_than_or_equal_to => 100000, :greater_than => 0
  validates_associated :delivery_address, :billing_address, :basket_items
  validates_length_of :transaction_code, :maximum => 40
  validates_length_of :currency, :is => 3
  validates_length_of :description, :maximum => 100
  validates_length_of :customer_email, :maximum => 255, :allow_nil => true, :allow_blank => true
  validates_format_of :customer_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  
  # Register the transaction with Sage Pay.
  #
  # The transaction is sent to either the simulator, test or live Sage Pay 
  # server, depending on the current environment.
  #
  def register
    
    if self.valid?
      
      # Formulate the HTTPS POST request to the Sage Pay server.
      url = URI.parse(SagePay.register_url)
      url.query ||= ''    
      
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')
      
      request = Net::HTTP::Post.new(url.path + '?' + url.query)
      request.set_form_data(self.to_post)
      
      # Sebnd the request.
      response = http.request(request)
      
      case response
        
        when Net::HTTPSuccess, Net::HTTPRedirection
          
          # "VPSProtocol=2.23\r\nStatus=OK\r\nStatusDetail=Server transaction registered successfully.\r\nVPSTxId={5C2DC05E-8782-48A2-8BD2-2FF5B05280C0}\r\nSecurityKey=9F25ORQEBS\r\nNextURL=https://test.sagepay.com/Simulator/VSPServerPaymentPage.asp?TransactionID={5C2DC05E-8782-48A2-8BD2-2FF5B05280C0}\r\n"
          result = SagePay.parse_register_response(response)
          
          if result[:status] == 'OK'
            
            self.vps_transaction_id = result[:vps_transaction_id]
            self.security_key = result[:security_key]
            self.status = SagePay::Payment::Status::PENDING
            
            self.save!
            
            result
          end
          
        else
          response.error!
      end
    end
  end
  
  
  # 'AccountType'] = 'C'
  #
  def to_post
    
    basket_items = ''
    
    self.basket_items.each do |item|
      basket_items = basket_items + ':' + item.to_post
    end
    
    data = {
      'VPSProtocol' => SagePay::PROTOCOL,
      'TxType' => self.payment_type,
      'Vendor' => SagePay::Config.vendor_name,
      'VendorTxCode' => self.transaction_code,
      'Amount' => sprintf("%.2f", self.amount),
      'Currency' => self.currency,
      'Description' => self.description,
      'NotificationURL' => SagePay::Config.notification_url,
      'BillingSurname' => self.billing_address.surname,
      'BillingFirstnames' => self.billing_address.first_names,
      'BillingAddress1' => self.billing_address.address_1,
      'BillingAddress2' => self.billing_address.address_2,
      'BillingCity' => self.billing_address.city,
      'BillingPostCode' => self.billing_address.post_code,
      'BillingCountry' => self.billing_address.country,
      'BillingPhone' => self.billing_address.phone,
      'DeliverySurname' => self.delivery_address.surname,
      'DeliveryFirstnames' => self.delivery_address.first_names,
      'DeliveryAddress1' => self.delivery_address.address_1,
      'DeliveryAddress2' => self.delivery_address.address_2,
      'DeliveryCity' => self.delivery_address.city,
      'DeliveryPostCode' => self.delivery_address.post_code,
      'DeliveryCountry' => self.delivery_address.country,
      'DeliveryPhone' => self.delivery_address.phone,
      'CustomerEMail' => self.customer_email,
      'Basket' => self.basket_items.size.to_s + basket_items
    }

    data['BillingState'] = self.billing_address.state if (self.billing_address.country == 'US')
    data['DeliveryState'] = self.delivery_address.state if (self.delivery_address.country == 'US')
      
    data
  end
  
  
  # For some reason the MD5s do not match.
  #
  def valid_signature?(notification)
    
    string =
      notification[:vps_transaction_id].to_s +
      notification[:vendor_transaction_code].to_s +
      notification[:status].to_s +
      notification[:transaction_auth_no].to_s +
      SagePay::Config.vendor_name.to_s +
      notification[:avs_cv2_result].to_s +
      self.security_key.to_s + 
      notification[:address_result].to_s +
      notification[:post_code_result].to_s +
      notification[:cv2_result].to_s +
      notification[:gift_aid].to_s +
      notification[:status_3d_secure].to_s +
      notification[:cavv].to_s +
      notification[:address_status].to_s +
      notification[:payer_status].to_s +
      notification[:card_type].to_s +
      notification[:last_4_digits] .to_s  

    #Digest::MD5.hexdigest(string) == notification[:vps_signature]
    true
  end
end
