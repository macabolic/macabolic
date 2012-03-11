ActiveAdmin::Dashboards.build do

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.
  section "Recent Products", :priority => 1 do
    table_for Product.order("created_at desc").limit(10) do
      column :vendor
      column :product_line
      column :name
      column :created_at
    end
    strong { link_to "View All Products", admin_products_path }
  end
  
  section "Recent Signups", :priority => 2 do
    table_for User.order("created_at desc").limit(10) do
      column :id
      column :first_name
      column :last_name
      column :email
      column :encrypted_password
    end
    strong { link_to "View All Users", admin_users_path }    
  end
  
end
