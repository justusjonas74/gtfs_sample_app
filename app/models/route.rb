class Route < ApplicationRecord
    belongs_to :agency, optional: true
end
