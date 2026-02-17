class CreateVolunteers < ActiveRecord::Migration[8.1]
  def change
    create_table :volunteers do |t|
      t.string :username
      t.string :password_digest
      t.string :full_name
      t.string :email
      t.string :phone
      t.string :address
      t.text :skills

      t.timestamps
    end
  end
end
