class DealsController < ApplicationController
  
  # GET /deals
  # GET /deals.xml
  def index
    @ending_soon_deals = Deal.expire_this_month.limit(4)
    @popular_deals = Deal.popular_deals.limit(4)

    respond_to do |format|
      format.html # index.html.erb
      #format.xml  { render :xml => @deals }
    end
  end
  
  def popular
    @popular_deals = Deal.popular_deals

    respond_to do |format|
      format.html # index.html.erb
      #format.xml  { render :xml => @deals }
    end    
  end

  def ending_soon
    @ending_soon_deals = Deal.expire_this_month

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @deals }
    end    
  end

  def recently_launched
    @ending_soon_deals = Deal.expire_this_month.limit(4)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @deals }
    end    
    
  end
end
