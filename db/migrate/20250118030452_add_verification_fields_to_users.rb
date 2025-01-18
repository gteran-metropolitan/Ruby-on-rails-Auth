class AddVerificationFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :verification_code, :string
    add_column :users, :email_verified, :boolean
  end
end
