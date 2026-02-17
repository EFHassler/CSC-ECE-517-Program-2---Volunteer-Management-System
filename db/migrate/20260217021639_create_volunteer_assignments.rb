class CreateVolunteerAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :volunteer_assignments do |t|
      t.references :volunteer, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.string :status
      t.decimal :hours_worked
      t.date :date_logged

      t.timestamps
    end
  end
end
