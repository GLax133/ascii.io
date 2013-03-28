class Picture < ActiveRecord::Base
  attr_accessible :picture_file, :asciicast_id
  belongs_to :asciicast

  mount_uploader :picture_file, ImageUploader

end

