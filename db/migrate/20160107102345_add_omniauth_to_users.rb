class AddOmniauthToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :provider, null: false, default: ''
      t.string :uid, null: false, default: ''
      t.string :name, null: false, default: ''
      t.string :token, null: false, default: ''
    end
  end
end
