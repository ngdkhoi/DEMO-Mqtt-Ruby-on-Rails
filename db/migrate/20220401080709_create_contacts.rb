class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.name :string
      t.timestamps
    end
  end
end
