class Game < ApplicationRecord
  belongs_to :user
  has_many :positions

  before_save :sequence_coordinates

  def lat
    (lat1 + lat2) / 2.0
  end
  def lng
    (lng1 + lng2) / 2.0
  end

  def to_s
    "#{self.name} by #{self.user.name}"
  end

  private
  def sequence_coordinates
    if self.lat1 > self.lat2
      tmp_lat = self.lat1
      tmp_lng = self.lng1
      self.lat1 = self.lat2
      self.lng1 = self.lng2
      self.lat2 = tmp_lat
      self.lng2 = tmp_lng
    end
  end
end
