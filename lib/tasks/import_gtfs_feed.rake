namespace :gtfs do
    desc "I am short, but comprehensive description for my cool task"
    task :import, [:file_name] => :environment do |t, args|
      puts "Environment Loaded."
      source = GTFS::Source.build(args.file_name)
      #binding.pry
      puts "Source Loaded."
      #puts source.agencies.first.name

    # i = 0
    # source.each_shape do |sh|
    #   binding.pry
    #   #Shape.create(sh.to_hash)
    #   puts "Import Shape Number #{i} \r"
    # end
    # puts "#{i} items from Shapes.txt added."# i = 0


    # i = 0
    # source.each_fare_attribute do |fa|
    #   binding.pry
    #   #FareAttribute.create(fa.to_hash)
    #   puts "Import Fare Attribute Number #{i} \r"
    # end
    # puts "#{i} items from Fare_attributes.txt added."

    # i = 0
    # source.each_fare_rule do |fr|
    #   binding.pry
    #   #FareRule.create(fr.to_hash)
    #   puts "Import Fare Rule Number #{i} \r"
    # end
    # puts "#{i} items from Fare_rules.txt added."

    # i = 0
    # source.each_feed_info do |fi|
    #   binding.pry
    #   #FeedInfo.create(fi.to_hash)
    #   puts "Import Feed Info Number #{i} \r"
    # end
    # puts "#{i} items from FeedInfo.txt added."


    # BUG: PRODUCES ERROR IF FILE NOT EXIST
    # TODO: NOT TESTED

    # i = 0
    # frequencies = []
    # binding.pry
    # source.try(:each_frequency) do |f|
    #   binding.pry
    #   frequencies << Frequency.new(f.to_hash)
    #   i += 1
    #   print "Import Frequency Number #{i} \r"
    #   $stdout.flush
    # end
    # puts "#{i} items from frequencies.txt added to memory."
    # Frequency.import frequencies
    # puts "#{i} items from frequencies.txt added to Database."

    #####################

    import_gtfs_source(source, :agency, {
      :agency_id => :id,
      :agency_name => :name,
      :agency_url => :url,
      :agency_timezone => :timezone,
      :agency_lang => :lang,
      :agency_phone => :phone,
      :agency_fare_url => :fare_url,
      #:agency_email => :email BUG: Attribute not available in 'gtfs' gem
    })

    import_gtfs_source(source, :stop, {
      :stop_id => :id,
      :stop_code => :code,
      :stop_name => :name,
      :stop_desc => :desc,
      :stop_lat => :lat,
      :stop_lon => :lon,
      :stop_url => :url,
      :location_type => :location_type,
      :parent_station => :parent_station,
      :stop_timezone => :timezone,
      :wheelchair_boarding => :wheelchair_boarding,
      :zone_id => :zone_id
    })

    import_gtfs_source(source, :route, {
      :route_id => :id,
      :route_short_name => :short_name,
      :route_long_name => :long_name,
      :route_desc => :desc,
      :route_type => :type,
      :route_url => :url,
      :route_color => :color,
      :route_text_color => :text_color
    }, {
      :agency_id => :agency_id
    })

    import_gtfs_source(source, :calendar,{
      :calendar_id => :service_id,
      :monday => nil,
      :tuesday => nil,
      :wednesday => nil,
      :thursday => nil,
      :friday => nil,
      :saturday => nil,
      :sunday => nil,
      :start_date => nil,
      :end_date => nil
    })

    import_gtfs_source(source, :calendar_date, {
      #:service_id_ref => :service_id,
      :date => nil,
      :exception_type => nil
    },{
      :calendar_id => :calendar_id
    })

    import_gtfs_source(source, :trip, {
      :trip_id => :id,
      :trip_headsign => :headsign,
      :trip_short_name => :short_name,
      :block_id => :block_id,
      :shape_id => :shape_id,
      :direction_id => :direction_id,
      :wheelchair_accessible => :wheelchair_accessible
      #:bikes_allowed #:BUG!
    }, {
      :route_id => :route_id,
      :calendar_id => :calendar_id,
    })

    import_gtfs_source(source, :transfer, {
      :from_stop_id => :from_stop_id,
      :to_stop_id => :to_stop_id,
      :min_transfer_time => :min_transfer_time,
      :transfer_type => :type
    })

    import_gtfs_source(source, :stop_time, {
        :arrival_time => nil,
        :departure_time => nil,
        :stop_sequence => nil,
        :stop_headsign => nil,
        :pickup_type => nil,
        :drop_off_type => nil,
        :shape_dist_traveled => nil
        #:timepoint => nil
    },{
        :trip_id => :trip_id,
        :stop_id => :stop_id
    })

      #   i = 0
    #   calendar_dates = []
    #   source.each_calendar_date do |cd|
    # binding.pry
    #     calendar_dates << CalendarDate.new(cd.to_hash)
    #     i += 1
    #     print "Import Calendar Date Number #{i} \r"
    #     $stdout.flush
    #   end
    #   puts "#{i} items from calendar_dates.txt added to memory."
    #   CalendarDate.import calendar_dates
    #   puts "#{i} items from calendar_dates.txt added to Database."
    #   calendar_dates = nil

    #   i = 0
    #   routes = []
    #   source.each_route do |r|
    #     #binding.pry
    #     routes << Route.new do |rt|
    #       rt.route_id = r.id
    #       rt.agency_id = r.agency_id
    #       rt.route_short_name = r.short_name
    #       rt.route_long_name = r.long_name
    #       rt.route_desc = r.desc
    #       rt.route_type = r.type
    #       rt.route_url = r.url
    #       rt.route_color = r.color
    #       rt.route_text_color = r.text_color
    #     end
    #     i += 1
    #     #Route.create(r.to_hash)
    #     print "Import Route Number #{i} \r"
    #     $stdout.flush
    #   end
    #   puts "#{i} items from Routes.txt added to memory."
    #   Route.import routes
    #   puts "#{i} items from Routes.txt added to Database."
    #   routes = nil


    #   i = 0
    #   transfers = []
    #   source.each_transfer  do |c|
    #       transfers << Transfer.new do |tr|
    #       tr.from_stop_id = c.from_stop_id
    #       tr.to_stop_id = c.to_stop_id
    #       tr.min_transfer_time = c.min_transfer_time
    #       tr.transfer_type = c.type.to_i
    #     end
    #     i += 1
    #     print "Import Transfer Number #{i} \r"
    #     $stdout.flush
    #   end
    #   puts "#{i} items from transfers.txt added to memory."
    #   Transfer.import transfers
    #   puts "#{i} items from transfers.txt added to Database."
    #   transfers = nil


 #   i = 0
    #   trips = []
    #   source.each_trip  do |c|
    #     trips << Trip.new do |tr|
    #       tr.route_id = c.route_id
    #       tr.service_id = c.service_id
    #       tr.trip_id = c.id
    #       tr.trip_headsign = c.headsign
    #       tr.trip_short_name = c.short_name
    #       tr.block_id = c.block_id
    #       tr.shape_id = c. shape_id
    #       #:bikes_allowed #:BUG!
    #       tr.direction_id = c.direction_id.to_i #0 for one direction, 1 for another.
    #       tr.wheelchair_accessible = c.wheelchair_accessible.to_i #0 for no information, 1 for at
    #       # least one rider accommodated on wheel chair, 2 for no riders
    #       # accommodated.
    #     end
    #     i += 1
    #     print "Import Trips Number #{i} \r"
    #     $stdout.flush
    #   end
    # puts "#{i} items from trips.txt added to memory."
    #   Trip.import trips
    #   puts "#{i} items from trips.txt added to Database."
    #   trips = nil

    #   i = 0
    #   calendars = []
    #   source.each_calendar do |c|
    #     calendars << Calendar.new(c.to_hash)
    #       i += 1
    #       print "Import Calender Number #{i} \r"
    #       $stdout.flush
    #   end
    #   puts "#{i} items from calendars.txt added to memory."
    #   Calendar.import calendars
    #   puts "#{i} items from calendars.txt added to Database."
    #   calendars = nil


       #   i = 0
    #   agencies = []
    #   source.each_agency do |a|
    #     agencies << Agency.new(a.to_hash)
    #     i += 1
    #     print "Import Agency Number #{i} \r"
    #     $stdout.flush
    #   end
    #   puts "#{i} items from agencies.txt added to memory."
    #   Agency.import agencies
    #   puts "#{i} items from agencies.txt added to Database."
    #   agencies = nil


    #   i = 0
    #   stop_times = []
    #   source.each_stop_time do |st|
    #     stop_times << StopTime.create(st.to_hash)
    #     i +=1
    #     print "Import Stop Time Number #{i} \r"
    #     $stdout.flush
    #   end
    #   puts "#{i} items from stop_times.txt added to memory."
    #   StopTime.import stop_times
    #   puts "#{i} items from stop_times.txt added to Database."
    #   stop_times = nil

     #   i = 0
    #   stops = []
    #   source.each_stop do |st|
    #     stops << Stop.new do |s|
    #       s.stop_id = st.id
    #       s.stop_code = st.code
    #       s.stop_name = st.name
    #       s.stop_desc = st.desc
    #       s.stop_lat = st.lat.to_f
    #       s.stop_lon = st.lon.to_f
    #       s.stop_url = st.url
    #       s.location_type = st.location_type.to_i
    #       s.parent_station = st.parent_station
    #       s.stop_timezone = st.timezone
    #       s.wheelchair_boarding = st.wheelchair_boarding.to_i
    #       s.zone_id = st.zone_id
    #     end
    #       i += 1
    #       print "Import Stop Number #{i} \r"
    #       $stdout.flush
    #   end
    #   puts "#{i} items from stops.txt added to memory."
    #   Stop.import stops
    #   puts "#{i} items from stops.txt added to Database."
    #   stops = nil
    end
end
