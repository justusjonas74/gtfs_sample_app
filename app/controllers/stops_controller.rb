class StopsController < ApplicationController
    helper StopsHelper
    before_action :get_center_stop, only: [:search, :index]

    def index
        @stops = Stop.search(params[:term]).paginate(:page => params[:page], :per_page => 30)
    end

    def show

      @stops = Stop.get_with_childs(params[:id])
      arr = @stops.map(&:id)
      @stop_times = Trip.next_trips(arr)
    end

    def find_stop
      @stop = Stop.search(params[:term], true)
      case @stop.length
      when 0
        flash[:warning] = "Sorry, no stops found with name: <strong>\"#{params[:term]}\".</strong> Please try again"
        redirect_to root_path
      when 1
        redirect_to stop_path(@stop.take.id)
      else
        redirect_to stops_path(:term => params[:term])
      end
    end


    def stops_list
      #if params[:term] && params[:term].length > 1
      if params[:term]
        @stops = Stop.search(params[:term]).limit(20)
      else
        @stops = Stop.none
      end
      render json: @stops.map(&:stop_name)
  end

    def search

    end



    def stop_params
      params.require(:stop).permit(:term)
    end

    private

    def get_center_stop
       @center = Stop.center_pos
    end
end
