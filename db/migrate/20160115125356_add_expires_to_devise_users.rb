class AddExpiresToDeviseUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :expires_at, null: false, default: 0
      t.boolean :expires, null: false, default: false
    end
  end
end
