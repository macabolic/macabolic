class CreateAnswerResponses < ActiveRecord::Migration
  def self.up
    create_table :answer_responses do |t|
      t.references  :answer
      t.references  :user
      t.boolean     :response_for

      t.timestamps
    end
  end

  def self.down
    drop_table :answer_responses
  end
end
