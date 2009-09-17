class SagePay::BasketItem < ActiveRecord::Base
  
  set_table_name 'sage_pay_basket_items'
  
  belongs_to :payment, :class_name => 'SagePay::Payment'
  
#  validates_numericality_of :quantity, :greater_than => 0, :only_integer => true, :allow_blank => true
#  validates_numericality_of :cost, :tax, :allow_blank => true
  
  
  def cost_including_tax
    sprintf("%.2f", self[:cost] + self[:tax])
  end
  
  def total_cost
    sprintf("%.2f", self.cost_including_tax * self.quantity)
  end
  
  def tax
    
    self[:tax] = 0.00 if self[:tax] == nil
    sprintf("%.2f", self[:tax])
  end
  
  def cost
    
    self[:cost] = 0.00 if self[:cost] == nil
    sprintf("%.2f", self[:cost])
  end
  
  def to_post
    self.description + ':' + self.quantity.to_s + ':' + self.cost.to_s + ':' + self.tax.to_s + ':' + self.cost_including_tax + ':' + self.total_cost
  end
  
end