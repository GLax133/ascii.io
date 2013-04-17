class UserDecorator < ApplicationDecorator
  decorates :user

  def name
	user.name
  end

  def asciicasts_count
    model.asciicasts.count
  end

  def link(options = {})
    h.link_to user.name 
  end

  def img_link(options = {})
    h.avatar_image_tag(user)
    
  end
end
