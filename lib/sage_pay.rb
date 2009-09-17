module SagePay
  
  PROTOCOL = '2.23'  
  
  SIMULATOR_URL_REGISTER = 'https://test.sagepay.com/Simulator/VSPServerGateway.asp?Service=VendorRegisterTx'

  TEST_URL_REGISTER = 'https://test.sagepay.com/gateway/service/vspserver-register.vsp'
  TEST_URL_REFUND = 'https://test.sagepay.com/gateway/service/vspserver-refund.vsp'
  TEST_URL_VOID = 'https://test.sagepay.com/gateway/service/vspserver-void.vsp'
  TEST_URL_RELEASE = 'https://test.sagepay.com/gateway/service/vspserver-release.vsp'
  
  LIVE_URL_REGISTER = 'https://live.sagepay.com/gateway/service/vspserver-register.vsp'
  LIVE_URL_REFUND = 'https://live.sagepay.com/gateway/service/vspserver-refund.vsp'
  LIVE_URL_VOID = 'https://live.sagepay.com/gateway/service/vspserver-void.vsp'
  LIVE_URL_RELEASE = 'https://live.sagepay.com/gateway/service/vspserver-release.vsp'
  
  
  # Return the transaction registration URL for the configured Sage Pay environment.
  #
  # See SagePay::Config.environment
  #
  def self.register_url
    
    case SagePay::Config.environment
      
      when SagePay::Environment::SIMULATOR
        self::SIMULATOR_URL_REGISTER
        
      when SagePay::Environment::TEST
        self::TEST_URL_REGISTER
        
      when SagePay::Environment::LIVE
        self::LIVE_URL_REGISTER
    end
  end
  
  
  def self.generate_transaction_code
    uuid = UUID.new
    uuid.generate
  end
  
  
  # Parse the response from Sage Pay into a hash.
  #
  def self.parse_register_response(response)
    
    response_hash = {}
    
    response.body.split("\r\n").each do |data|
      parsed = data.split('=', 2)
      response_hash[self.translations[parsed.first]] = parsed.last unless self.translations[parsed.first].nil?
    end
    
    response_hash
  end
  
  
  def self.parse_notification(params)
    
    notification_hash = {}
    
    params.each_pair do |key, value|
      notification_hash[self.translations[key]] = value unless self.translations[key].nil?
    end
    
    notification_hash
  end
  
  
  #protected

    # Hash to translate Sage Pay parameters to Ruby-like syntax.
    def self.translations
      {
        'VPSProtocol' => :vps_protocol,
        'Status' => :status,
        'StatusDetail' => :status_detail,
        'VPSTxId' => :vps_transaction_id,
        'SecurityKey' => :security_key,
        'NextURL' => :next_url,
        'TxType' => :payment_type,
        'VendorTxCode' => :vendor_transaction_code,
        'TxAuthNo' => :transaction_auth_no,
        'AVSCV2' => :avs_cv2_result,
        'AddressResult' => :address_result,
        'PostCodeResult' => :post_code_result,
        'CV2Result' => :cv2_result,
        'GiftAid' => :gift_aid,
        '3DSecureStatus' => :status_3d_secure,
        'CAVV' => :cavv,
        'CardType' => :card_type,
        'Last4Digits' => :last_4_digits,
        'VPSSignature' => :vps_signature,
        'AddressStatus' => :address_status,
        'PayerStatus' => :payer_status
      }
    end
end
