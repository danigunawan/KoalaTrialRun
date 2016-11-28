class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.references :user, foreign_key: true
      t.string :provider
      t.string :uid
      t.string :email
      t.string :oauth_token
      t.datetime :oauth_expires_at

      t.timestamps
    end
  end
end
