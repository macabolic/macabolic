class CreateEmailPreferences < ActiveRecord::Migration
  def self.up
    create_table :email_preferences do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :email_preferences
  end
end