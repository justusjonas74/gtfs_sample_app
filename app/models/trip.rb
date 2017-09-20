class Trip < ApplicationRecord
    belongs_to :calendar
    belongs_to :route
    has_many :stop_times
end
