class StopsController < ApplicationController
    def index
        @stops = Stop.search(params[:term]).paginate(:page => params[:page], :per_page => 30)
    end

    def show
      @stops = Stop.get_with_childs(params[:id])
      arr = @stops.map(&:id)
      col = Calendar.connection.quote_column_name(Time.now.strftime("%A").downcase)

      searchblock = "calendars.#{col} = 1"
      @stop_times = Trip
        .includes(:stop_times, calendar: [:calendar_dates])
        .order('stop_times.departure_time')
        .where('stop_times.stop_id IN (?)', arr)
        .where("(calendar_dates.date = ? AND calendar_dates.exception_type = 1) OR (#{searchblock})", Time.now)
        .where('NOT EXISTS ( SELECT 1 FROM calendar_dates WHERE (calendars.id = calendar_dates.calendar_id) AND (calendar_dates.date = ? AND calendar_dates.exception_type = 2))', Time.now)
        .where('stop_times.departure_time > ?', Time.now.strftime("%T"))
        .where('calendars.start_date < ?', Time.now)
        .where('calendars.end_date > ?', Time.now)
        .limit(20)
    end

    def find_stop
      @stop = Stop.where('stop_name LIKE ?', params[:term])
      if @stop.one?
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
end
