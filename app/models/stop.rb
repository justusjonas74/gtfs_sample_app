class Stop < ApplicationRecord
  has_many :stop_times

  scope :no_childs, -> { where(parent_station: "") }

  def self.next_departures(id)

    # find all related childs and parrents

    # select all VALID stop_times for given DateTime

  end


  def self.search(term)
    if term
      where('stop_name LIKE ?', "%#{term}%").no_childs
      #where('stop_name LIKE ?', "%#{term}%")
    else
      all.no_childs
    end
  end

  def self.get_with_childs(id)
    parent = where(id: id)
    #binding.pry
    return parent + where(parent_station: parent.take.stop_id)
  end
end
