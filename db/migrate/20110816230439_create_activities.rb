class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.references  :user
      t.string      :name
      t.integer     :type_id
      t.string      :action
      t.datetime    :performed_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
