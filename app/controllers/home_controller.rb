#coding=utf-8
class HomeController < ApplicationController
  def show
    @title = "共享你的代码---编程公园"

    if home_asciicast_id = CFG['HOME_CAST_ID']
      asciicast = Asciicast.find(home_asciicast_id)
    else
      asciicast = Asciicast.order("created_at DESC").first
    end

    if asciicast
      @asciicast = AsciicastDecorator.new(asciicast)
    end

    @asciicasts = AsciicastDecorator.decorate(
      Asciicast.order("created_at DESC").limit(9).includes(:user)
    )
  end
end
