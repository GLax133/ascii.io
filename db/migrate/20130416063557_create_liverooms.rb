class CreateLiverooms < ActiveRecord::Migration
  def change
    create_table :liverooms do |t|
      t.string :name
      t.text :description
      t.string :status
      t.string :teacher
      t.string :admin
      t.string :image

      t.timestamps
    end
  end
end
