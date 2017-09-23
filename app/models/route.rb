class Route < ApplicationRecord
    has_many :trips
    belongs_to :agency, optional: true

end
