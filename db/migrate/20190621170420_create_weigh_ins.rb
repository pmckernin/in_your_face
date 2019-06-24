class CreateWeighIns < ActiveRecord::Migration
  def change
    create_table :weigh_ins do |t|
      t.float :weight
      t.date :date
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
