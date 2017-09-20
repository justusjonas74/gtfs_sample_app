class CreateTableGtfs < ActiveRecord::Migration[5.1]
# SQL-Source https://raw.githubusercontent.com/mauryquijada/gtfs-mysql/master/gtfs-sql.sql
  def change
    create_table :agencies do |t|
        #t.string :transit_system, :null => false
        t.string :agency_id
        t.string :agency_name, :null => false
        t.string :agency_url, :null => false
        t.string :agency_timezone, :null => false
        t.string :agency_lang
        t.string :agency_phone
        t.string :agency_fare_url
        t.string :agency_email
     end

     create_table :calendars do |t|
         #t.string :transit_system, :null => false
         t.string :calendar_id, :null => false
         t.integer :monday, :null => false
         t.integer :tuesday, :null => false
         t.integer :wednesday, :null => false
         t.integer :thursday, :null => false
         t.integer :friday, :null => false
         t.integer :saturday, :null => false
         t.integer :sunday, :null => false
         t.date :start_date, :null => false
         t.date :end_date, :null => false
      end

    create_table :calendar_dates do |t|
        #t.string :transit_system, :null => false
        t.references :calendar, :null => false
        t.date :date, :null => false
        t.integer :exception_type, :null => false
        # t.index :calendar_id
        # t.index :exception_type
     end

    create_table :fare_attributes do |t|
        #t.string :transit_system, :null => false
        t.string :fare_id
        t.float :price, :null => false
        t.string :currency_type, :null => false
        t.integer :payment_method, :null => false
        t.integer :transfers, :null => false
        t.string :transfer_duration
        #t.integer :exception_type, :null => false
        #t.string :agency_id
        t.index :fare_id
     end

    create_table :fare_rules do |t|
        #t.string :transit_system, :null => false
        t.string :fare_id, :null => false
        t.string :route_id
        t.string :origin_id
        t.string :destination_id
        t.string :contains_id
        t.index :fare_id
        t.index :route_id
     end

    create_table :feed_infos do |t|
        #t.string :transit_system, :null => false
        t.string :feed_publisher_name, :null => false
        t.string :feed_publisher_url, :null => false
        t.string :feed_lang, :null => false
        t.string :feed_start_date
        t.string :feed_end_date
        t.string :feed_version
     end

    create_table :frequencies do |t|
        #t.string :transit_system, :null => false
        t.string :trip_id, :null => false
        t.string :start_time, :null => false
        t.string :end_time, :null => false
        t.string :headway_secs, :null => false
        t.integer :exact_times
        t.index :trip_id
     end

    create_table :routes do |t|
        #t.string :transit_system, :null => false
        t.string :route_id, :null => false
        t.references :agency
        t.string :route_short_name, :null => false
        t.string :route_long_name, :null => false
        t.string :route_desc
        t.integer :route_type, :null => false
        t.string :route_url
        t.string :route_color
        t.string :route_text_color
        # t.index :agency_id
        # t.index :route_type
     end
     #add_reference :routes

    create_table :shapes do |t|
        #t.string :transit_system, :null => false
        t.string :shape_id, :null => false
        t.float :shape_pt_lat, :null => false
        t.float :shape_pt_lon, :null => false
        t.integer :shape_pt_sequence, :null => false
        t.string :shape_dist_traveled
        t.index :shape_id
     end

      create_table :stops do |t|
        #t.string :transit_system, :null => false
        t.string :stop_id, :null => false
        t.string :stop_code
        t.string :stop_name, :null => false
        t.string :stop_desc
        t.float :stop_lat, :null => false
        t.float :stop_lon, :null => false
        t.string :zone_id
        t.string :stop_url
        t.integer :location_type
        t.string :parent_station
        t.string :stop_timezone
        t.integer :wheelchair_boarding
        t.index :zone_id
        t.index :stop_lat
        t.index :stop_lon
        t.index :location_type
        t.index :parent_station
     end

     create_table :stop_times do |t|
        # t.string :transit_system , :null => false
         #t.string :trip_id_ref, :null => false
         t.references :trip, :null => false
         t.time :arrival_time
         #arrival_time_seconds INT(100)
         t.time :departure_time#, #:null => false
         #departure_time_seconds INT(100)
         #t.string :stop_id_ref, :null => false
         t.references :stop, :null => false
         t.integer :stop_sequence, :null => false
         t.string :stop_headsign
         t.integer :pickup_type
         t.integer :drop_off_type
         t.float :shape_dist_traveled
         t.integer :timepoint
        #  t.index :trip_id
        #  #t.index :arrival_time_seconds
        #  #t.index :departure_time_seconds
        #  t.index :stop_id
        #  t.index :stop_sequence
        #  t.index :pickup_type
        #  t.index :drop_off_type
      end

    create_table :transfers do |t|
        #t.string :transit_system, :null => false
        t.string :from_stop_id, :null => false
        t.string :to_stop_id, :null => false
        t.integer :transfer_type, :null => false
        t.string :min_transfer_time
     end

    create_table :trips do |t|
        #t.string :transit_system, :null => false
        t.string :route_id, :null => false
        t.string :calendar_id, :null => false
        t.string :trip_id, :null => false
        t.string :trip_headsign
        t.string :trip_short_name
        t.integer :direction_id #0 for one direction, 1 for another.
        t.string :block_id
        t.string :shape_id
        t.integer :wheelchair_accessible #0 for no information, 1 for at
        # least one rider accommodated on wheel chair, 2 for no riders
        # accommodated.
        t.integer :bikes_allowed  #0 for no information, 1 for at least
        # one bicycle accommodated, 2 for no bicycles accommodated
     end
  end
end
