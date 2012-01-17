Macabolic::Application.routes.draw do

  resources :searches do
    collection do
      get 'find_product'
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
  resources :invitations do
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
  resources :my_collection_items

  devise_for  :users, 
              :path_names => {  :sign_in => 'login', 
                                :sign_out => 'logout' },
                                #:sign_up => 'register' },
              :controllers => { :registrations => 'registrations',
                                :omniauth_callbacks => 'users/omniauth_callbacks' } do
     get 'users/sign_up/:invitation_token' => "registrations#new" 
     get 'users/auth/:provider' => 'users/omniauth_callbacks#passthru'          
  end

  # Products
  resources :products do
    member do
      get 'like'
      get 'unlike'
      get 'recommend'
    end

    collection do
      get 'product_search'
    end  
    resources :my_collection_items
  end
  
  # Members
  resources :members do
    member do
      get 'collections'
      get 'profile'
      get 'friends' => 'friendships#show'
    end
    
    resources :my_collections
  end
  
  resources :authentications
  resources :wishlists
  resources :wishlist_items

  # My Collections
  resources :wishlists do    
    delete 'wishlist_items/:product' => 'wishlist_items#destroy'
    resources :wishlist_items
  end

  #resources :registrations

  get "home/index"

  #match '/auth/:provider/callback' => 'authentications#create'
  match 'my_collections/add_product/:id' => 'my_collections#add_product'
  match 'about' => 'home#about_us'
  match 'features' => 'home#feature_tour'
  match 'contact' => 'home#contact_us'
  match 'faq' => 'home#faq'

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
  namespace :admin do
    resources :vendors
    resources :products
    resources :product_lines
  end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
