module SagePay::Payment::Status
  
  COMPLETE = 'COMPLETE'
  PENDING = 'PENDING'
  FAILED = 'FAILED'
  
  def valid?(type)
    true
  end
  
end
