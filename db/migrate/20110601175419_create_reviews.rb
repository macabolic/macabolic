class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.references  :product
      t.references  :user
      t.string      :title
      t.text        :content

      t.timestamps
    end
  end

  def self.down
    drop_table :reviews
  end
end
