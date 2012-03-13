class CreateProductIssues < ActiveRecord::Migration
  def self.up
    create_table :product_issues do |t|
      t.references  :product
      t.integer     :reporter_id    
      t.integer     :option
      t.text        :remark
      
      t.timestamps
    end
  end

  def self.down
    drop_table :product_issues
  end
end
