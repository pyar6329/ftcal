class AddRefreshTokenToDeviseUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :refresh_token, null: false, default: ''
    end
  end
end
