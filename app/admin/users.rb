ActiveAdmin.register User do
  
  filter  :first_name
  filter  :last_name
  filter  :email
  
  index do
    column  "Id" do |user|
      link_to user.id, admin_user_path(user)
    end
    column  :first_name
    column  :last_name
    column  :birthday
    column  :email
    column  :sign_in_count
    column  :current_sign_in_at
    column  :last_sign_in_at
    column  :current_sign_in_ip
    column  :last_sign_in_ip
    column  :invitation_id
    column  :invitation_limit
    default_actions
  end
  
  form do |f|
      f.inputs "User" do
        f.input :first_name
        f.input :last_name
        f.input :birthday
        f.input :email
        f.input :invitation_id
        f.input :invitation_limit
      end
      f.buttons
  end  
end
