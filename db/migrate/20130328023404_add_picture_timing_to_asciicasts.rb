class AddPictureTimingToAsciicasts < ActiveRecord::Migration
  def change
    add_column :asciicasts, :picture_timing, :string
  end
end
