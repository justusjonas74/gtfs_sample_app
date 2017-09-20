class Route < ApplicationRecord
    belongs_to :agency, optional: true
    has_many :trips
end
