class AddMp3ToAsciicasts < ActiveRecord::Migration
  def change
    add_column :asciicasts, :mp3, :string
  end
end
