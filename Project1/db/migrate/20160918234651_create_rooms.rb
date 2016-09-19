class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.string :room_id
      t.string :building
      t.string :size

      t.timestamps
    end
  end
end
