class Liveroom < ActiveRecord::Base
  attr_accessible :admin, :description, :image, :name, :status, :teacher
end
