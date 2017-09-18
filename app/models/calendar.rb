class Calendar < ApplicationRecord
    scope :goes_on, ->(time) { where("? LIKE 1", time.strftime("%A").downcase) }

    #alias_attribute :calendar_id, :service_id
    has_many :trips
    has_many :calendar_dates

end
