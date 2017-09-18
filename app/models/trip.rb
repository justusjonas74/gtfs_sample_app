class Trip < ApplicationRecord
    belongs_to :calendar
    has_many :stop_times
end
