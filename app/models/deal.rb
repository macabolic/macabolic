class Deal < ActiveRecord::Base
  belongs_to  :product
  belongs_to  :vendor
  
  scope :expired, where('offered_to_date < ?', Time.now)
  scope :expire_in, lambda { |day|
    where('offered_to_date <= ?', (Time.now.to_date + day))
  }
  scope :expire_this_week, where('offered_to_date > ? and offered_to_date < ?', Time.now, 1.week.from_now)
  scope :expire_this_month, where('offered_to_date > ? and offered_to_date < ?', Time.now, 1.month.from_now)
  scope :no_expiry_date, where('offered_to_date is null')  
  scope :popular_deals, where('offered_to_date is null or offered_to_date >= ?', 1.month.from_now)
  scope :store_deals, lambda { |store|
    where('vendor_id = ?', store.id)
  }
  
  scope :product_deals, lambda { |product| 
    where('deals.product_id = ?', product.id) 
  }

  scope :vendor_related_offerings, lambda { |vendor|
    joins('INNER JOIN products ON deals.product_id = products.id').where('products.vendor_id = ? and products.vendor_id <> deals.vendor_id', vendor.id)
  }

  def days_left
    logger.debug("calculating.....")
    if !self.offered_to_date.nil?
      days_left = ((self.offered_to_date - Time.now) / (60*60*24)).round
    end
  end
  
end
