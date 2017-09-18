class CalendarDate < ApplicationRecord
    belongs_to :calendar

    #exception_type =
    # Indicates whether service is available on the date specified in the date field.
    # A value of 1 indicates that service has been added for the specified date.
    # A value of 2 indicates that service has been removed for the specified date.

end
