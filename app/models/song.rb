class Song < ApplicationRecord
  validates :title, presence: true
  validates :released, inclusion: {in: [true, false]}
  validates :artist_name, presence: true
  validate :release_year_not_blank, :title_not_repeated

  def title_not_repeated
    songs_artist = Song.all.select{|song| self.artist_name == song.artist_name}
    songs_year = Song.all.select{|song| self.release_year == song.release_year}
    songs_title = Song.all.select{|song| self.title == song.title}
    if (songs_artist & songs_year & songs_title).size > 0
      errors.add(:title, "cannot be repeated by same artist in the same year")
    end
  end

  def release_year_not_blank
    if self.released && !self.release_year.present?
      errors.add(:release_year, "must be filled in")
    elsif self.release_year.present? && self.release_year > Time.now.year
      errors.add(:release_year, "must be less than or equal to #{Time.now.year}")
    end
  end
end
