class AddIndexToActivities < ActiveRecord::Migration
  def change
    add_index :activities, :user_id, { :name => "activities_user_id_index" }
    add_index :activities, [ :user_id, :action ], { :name => "activities_user_id_action_index" }
    add_index :activities, [ :name, :type_id ], { :name => "activities_name_type_id_index" }
  end
end
