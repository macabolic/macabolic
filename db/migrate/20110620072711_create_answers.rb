class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.string :content
      t.references  :question
      t.references  :user

      t.timestamps
    end
  end

  def self.down
    drop_table :answers
  end
end