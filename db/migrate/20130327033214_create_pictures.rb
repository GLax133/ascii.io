class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :picture_file
      t.integer :asciicast_id

      t.timestamps
    end
  end
end
