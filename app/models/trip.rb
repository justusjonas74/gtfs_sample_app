class Trip < ApplicationRecord
    belongs_to :calendar
    belongs_to :route
    has_many :stop_times

    def self.next_trips(arr, time = Time.current, number = 20)
        col = Calendar.connection.quote_column_name(Time.now.strftime("%A").downcase)
        searchblock = "calendars.#{col} = 1"
        includes(:route, :stop_times, calendar: [:calendar_dates])
        .order('stop_times.departure_time')
        .where('stop_times.stop_id IN (?)', arr)
        .where("(calendar_dates.date = ? AND calendar_dates.exception_type = 1) OR (#{searchblock})", Time.now)
        .where('NOT EXISTS ( SELECT 1 FROM calendar_dates WHERE (calendars.id = calendar_dates.calendar_id) AND (calendar_dates.date = ? AND calendar_dates.exception_type = 2))', Time.now)
        .where('stop_times.departure_time > ?', time.strftime("%T"))
        .where('calendars.start_date < ?', time)
        .where('calendars.end_date > ?', time)
        .limit(number)
      end
end
