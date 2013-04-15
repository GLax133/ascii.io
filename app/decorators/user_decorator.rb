class UserDecorator < ApplicationDecorator
  decorates :user

  def name
	"#{user.name}"
  end

  def asciicasts_count
    model.asciicasts.count
  end

  def link(options = {})
    h.link_to user.name, @user 
  end

  def img_link(options = {})
    link(options) do
      h.avatar_image_tag(user)
    end
  end
end
