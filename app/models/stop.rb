class Stop < ApplicationRecord
  has_many :stop_times

  scope :no_childs, -> { where(parent_station: "") }
  scope :center_pos, -> {[average(:stop_lat), average(:stop_lon)]}

  def self.search(term, strict = false)
    if term
      if strict
        querry = "#{term.downcase}"
      else
        querry = "%#{term.downcase}%"
      end
      where('lower(stop_name) LIKE ?', querry).no_childs
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
