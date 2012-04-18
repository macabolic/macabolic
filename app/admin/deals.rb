ActiveAdmin.register Deal do
  
  scope :all, :default => true
  scope :expired do |deals|
     deals.where('offered_to_date < ?', Time.now)
  end     
  scope :expire_in_5_days do |deals|
    deals.where('offered_to_date <= ?', (Time.now.to_date + 5))
  end
  scope :expire_this_week do |deals|
    deals.where('offered_to_date > ? and offered_to_date < ?', Time.now, 1.week.from_now)
  end
  scope :expire_this_month do |deals|
    deals.where('offered_to_date > ? and offered_to_date < ?', Time.now, 1.month.from_now)
  end
  
  filter  :product
  filter  :vendor
  filter  :offered_from_date, :as => :date_range
  filter  :offered_to_date, :as => :date_range
  filter  :original_price
  filter  :offered_price

  index :as => :block do |deal|
    div :for => deal do
      h2 link_to deal.product.name, admin_product_path(deal.product)
      h4 "offered by #{deal.vendor.name}"
      div do
        link_to admin_deal_path(deal) do        
          image_tag(deal.product.thumbnail.url(:medium), :width => "200", :class => "preview-image", :title => deal.product.name)        
        end
      end
      div do
        span do 
          if deal.offered_from_date.nil? 
            deal.offered_from_date
          else
            deal.offered_from_date.to_date 
          end
        end
        span do "-" end
        span do
          if deal.offered_to_date.nil? 
            deal.offered_to_date
          else
            deal.offered_to_date.to_date 
          end
        end
      end
      span do number_to_currency(deal.original_price, :separator => ".", :delimiter => ",") end
      span do "-->" end
      span do number_to_currency(deal.offered_price, :separator => ".", :delimiter => ",") end
    end
  end
  
  
  
end
