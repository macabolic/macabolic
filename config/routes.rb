Macabolic::Application.routes.draw do

  resources :deals do
    collection do
      get 'popular' => "deals#popular"
      get 'ending' => "deals#ending_soon"
    end    
  end

  resources :photo_entries
  resources :contests, :controller => "photo_contests" do
    resources :entries, :controller => "photo_entries"
  end

  resources :notifications, :only => [:show, :beta_invitation] do
    collection do
      get 'beta_invitation'
    end
  end
    
  resources :stores, :controller => "vendors" do
    member do
      get 'like'
      get 'unlike'
      get 'follow'
      get 'unfollow'
    end
  end
  
  resources :email_preferences
  resources :bookmarklets

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :searches do
    collection do
      get 'find_product'
      get 'find_vendor'
    end    
  end
  
  resources :product_comments
  resources :my_collection_comments
  resources :recommendations

  resources :friendships do
    collection do
        get 'show_more'
        get 'search'
        get 'search_in_network'        
    end
  end

  resources :activities

  # Home
  resources :home do
    member do
      get 'home'
    end
    
    collection do
      get 'discover'
    end
  end

  # Questions
  resources :questions do
    member do
      get 'back'
    end
    resources :answers
  end
  
  # Answers
  resources :answers do
    member do
      get 'vote'
    end
  end
  
  # Invitations
  resources :invitations, :except => [:show, :edit, :update, :destroy] do
    member do
      get 'accept/:invitation_token' => "invitations#show"
      get 'skip'
    end
  end
  
  # Reviews
  #resources :reviews do
  #  member do
  #    get 'vote'
  #  end
  #end
  
  # My Collections
  resources :my_collections do    
    member do
      get 'like'
      get 'unlike'
      get 'skip'
      get 'follow'
      get 'unfollow'
      get 'thumbnail_view'
    end
    
    collection do
      post 'mass_create'      
    end
    resources :my_collection_items
  end

  # My Collection Items
#  resources :my_collection_items do
#    resources :products
#  end
  resources :my_collection_items do
    member do
      get 'own'
    end
  end

  devise_for  :users, 
              :path_names => {  :sign_in => 'login', 
                                :sign_out => 'logout' },
                                #:sign_up => 'register' },
              :controllers => { :registrations => 'registrations',
                                :omniauth_callbacks => 'users/omniauth_callbacks',
                                :sessions => 'users/sessions' } do
     get 'users/sign_up/:invitation_token' => "registrations#new" 
     get 'users/auth/:provider' => 'users/omniauth_callbacks#passthru'          
  end

  resources :product_links
  
  # Products
  resources :products do
    member do
      get 'like'
      get 'unlike'
      get 'recommend'
      get 'buy_now'
      post 'report_issue'
    end

    collection do
      get 'search'
      get 'bookmarklet'      
    end  
    resources :my_collection_items do
      member do
        get 'own'
      end
    end
    resources :wishlist_items
    #get ':id/page/:page', :action => :show, :on => :collection    
  end
  
  # Members
  resources :members do
    member do
      get 'collections'
      get 'profile'
      get 'friends' => 'friendships#show'
      get 'followers' => 'friendships#followers'
      get 'following' => 'friendships#following'
    end
    
    resources :my_collections
    resources :invitations, :only => :add_as_friend do
      member do
        get 'accept_request'        
      end
      collection do
        post 'add_as_friend'
      end
    end
    
    resources :friendships do
      member do
        get 'follow'
        get 'unfollow'
      end
    end
    
  end
  
  resources :authentications
  resources :wishlist_items

  get "home/index"

  #match '/auth/:provider/callback' => 'authentications#create'
  match 'my_collections/add_product/:id' => 'my_collections#add_product'
  match 'about' => 'home#about_us'
  #match 'features' => 'home#feature_tour'
  match 'contact' => 'home#contact_us'
  match 'faq' => 'home#faq'
  match 'discover' => 'home#discover'
  match 'extra' => 'home#extra'
  match 'newsletter/:year/monthly/:month' => 'home#monthly'
  match 'fdfabbdcddfcfecfee/send' => 'notifications#send_reminder'
  match 'people' => 'members#index'
  match 'index' => 'home#home'
  
# TODO
#  match '/auth/failure' => 'something to handle this error'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  
  #namespace :admin do
  #  resources :vendors
  #  resources :products
  #  resources :product_lines
  #end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "home#home"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
