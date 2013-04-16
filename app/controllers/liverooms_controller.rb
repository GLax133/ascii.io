#coding:utf-8
class LiveroomsController < ApplicationController
	def new
		if current_user.id == 1
			@liveroom = Liveroom.new
		else
		      	redirect_back_or_to root_url, :notice =>"你没有权限"
		end
	end
	
	def create
		@liveroom = Liveroom.new(params[:liveroom])
	
		if @liveroom.save
		      	redirect_back_or_to root_url, :notice => "成功创建直播间"
    		else
      			render 'liverooms/new', :status => 422
		end
	end

	def index
		@liverooms = Liveroom.order("created_at DESC").limit(10)
	end

	def show
		
		@liveroom = Liveroom.find(params[:id])
	end

	def edit
		if current_user.id == 1
			@liveroom = Liveroom.find(params[:id])
		else
		      	redirect_back_or_to root_url, :notice =>"你没有权限"
		end
	end
	def update
		
	end
end
