class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider, null: false
      t.string :uid, null: false
      
      t.string :name
      t.integer :weight
      t.string :token
      t.string :refresh_token
      t.integer :expires_at
      t.timestamps null: false
    end
  end
end
