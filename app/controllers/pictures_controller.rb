class PicturesController < ApplicationController
	before_filter :get_asciicast 

	def index
		@pictures = Picture.where("asciicast_id = ?", get_asciicast)
		@picture_timing = @asciicast.picture_timing

		respond_to do |format|
	      		format.html # index.html.erb
      			format.json { render :json => { 
					:pictures => @pictures,
					:picture_timing =>@picture_timing,
					}
				}
    		end

	end

	def create
    		@picture = @asciicast.pictures.new(params[:picture])
    		if @picture.save

    		else
      			render :json => { "errors" => @picture.errors }
    		end
  	end


end

private

def get_asciicast
	@asciicast = Asciicast.find(params['asciicast_id'])
end
