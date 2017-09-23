# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170905123505) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agencies", force: :cascade do |t|
    t.string "agency_id"
    t.string "agency_name", null: false
    t.string "agency_url", null: false
    t.string "agency_timezone", null: false
    t.string "agency_lang"
    t.string "agency_phone"
    t.string "agency_fare_url"
    t.string "agency_email"
  end

  create_table "calendar_dates", force: :cascade do |t|
    t.bigint "calendar_id", null: false
    t.date "date", null: false
    t.integer "exception_type", null: false
    t.index ["calendar_id"], name: "index_calendar_dates_on_calendar_id"
  end

  create_table "calendars", force: :cascade do |t|
    t.string "calendar_id", null: false
    t.integer "monday", null: false
    t.integer "tuesday", null: false
    t.integer "wednesday", null: false
    t.integer "thursday", null: false
    t.integer "friday", null: false
    t.integer "saturday", null: false
    t.integer "sunday", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
  end

  create_table "fare_attributes", force: :cascade do |t|
    t.string "fare_id"
    t.float "price", null: false
    t.string "currency_type", null: false
    t.integer "payment_method", null: false
    t.integer "transfers", null: false
    t.string "transfer_duration"
    t.index ["fare_id"], name: "index_fare_attributes_on_fare_id"
  end

  create_table "fare_rules", force: :cascade do |t|
    t.string "fare_id", null: false
    t.string "route_id"
    t.string "origin_id"
    t.string "destination_id"
    t.string "contains_id"
    t.index ["fare_id"], name: "index_fare_rules_on_fare_id"
    t.index ["route_id"], name: "index_fare_rules_on_route_id"
  end

  create_table "feed_infos", force: :cascade do |t|
    t.string "feed_publisher_name", null: false
    t.string "feed_publisher_url", null: false
    t.string "feed_lang", null: false
    t.string "feed_start_date"
    t.string "feed_end_date"
    t.string "feed_version"
  end

  create_table "frequencies", force: :cascade do |t|
    t.string "trip_id", null: false
    t.string "start_time", null: false
    t.string "end_time", null: false
    t.string "headway_secs", null: false
    t.integer "exact_times"
    t.index ["trip_id"], name: "index_frequencies_on_trip_id"
  end

  create_table "routes", force: :cascade do |t|
    t.string "route_id", null: false
    t.bigint "agency_id"
    t.string "route_short_name", null: false
    t.string "route_long_name", null: false
    t.string "route_desc"
    t.integer "route_type", null: false
    t.string "route_url"
    t.string "route_color"
    t.string "route_text_color"
    t.index ["agency_id"], name: "index_routes_on_agency_id"
  end

  create_table "shapes", force: :cascade do |t|
    t.string "shape_id", null: false
    t.float "shape_pt_lat", null: false
    t.float "shape_pt_lon", null: false
    t.integer "shape_pt_sequence", null: false
    t.string "shape_dist_traveled"
    t.index ["shape_id"], name: "index_shapes_on_shape_id"
  end

  create_table "stop_times", force: :cascade do |t|
    t.bigint "trip_id", null: false
    t.interval "arrival_time"
    t.interval "departure_time"
    t.bigint "stop_id", null: false
    t.integer "stop_sequence", null: false
    t.string "stop_headsign"
    t.integer "pickup_type"
    t.integer "drop_off_type"
    t.float "shape_dist_traveled"
    t.integer "timepoint"
    t.index ["stop_id"], name: "index_stop_times_on_stop_id"
    t.index ["trip_id"], name: "index_stop_times_on_trip_id"
  end

  create_table "stops", force: :cascade do |t|
    t.string "stop_id", null: false
    t.string "stop_code"
    t.string "stop_name", null: false
    t.string "stop_desc"
    t.float "stop_lat", null: false
    t.float "stop_lon", null: false
    t.string "zone_id"
    t.string "stop_url"
    t.integer "location_type"
    t.string "parent_station"
    t.string "stop_timezone"
    t.integer "wheelchair_boarding"
    t.index ["location_type"], name: "index_stops_on_location_type"
    t.index ["parent_station"], name: "index_stops_on_parent_station"
    t.index ["stop_lat"], name: "index_stops_on_stop_lat"
    t.index ["stop_lon"], name: "index_stops_on_stop_lon"
    t.index ["zone_id"], name: "index_stops_on_zone_id"
  end

  create_table "transfers", force: :cascade do |t|
    t.string "from_stop_id", null: false
    t.string "to_stop_id", null: false
    t.integer "transfer_type", null: false
    t.string "min_transfer_time"
  end

  create_table "trips", force: :cascade do |t|
    t.bigint "route_id", null: false
    t.bigint "calendar_id", null: false
    t.string "trip_id", null: false
    t.string "trip_headsign"
    t.string "trip_short_name"
    t.integer "direction_id"
    t.string "block_id"
    t.string "shape_id"
    t.integer "wheelchair_accessible"
    t.integer "bikes_allowed"
    t.index ["calendar_id"], name: "index_trips_on_calendar_id"
    t.index ["route_id"], name: "index_trips_on_route_id"
  end

end
