class Brewery < ActiveRecord::Base
	include RatingAverage

	has_many :beers, :dependent => :destroy
	has_many :ratings, :through => :beers

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1042,
                                    only_integer: true }
  validate :year, :year_cannot_be_in_the_future

  def print_report
    puts name
    puts "Established year: #{year}"
    puts "Number of beers #{beers.count}"
    puts "Number of ratings #{ratings.count}"
  end


  def restart
    self.year = 2014
    puts "changed year to #{year}"
  end


  def year_cannot_be_in_the_future
    errors.add(:year, 'cannot be in the future') unless year <= Time.now.year
  end

  def to_s
    "#{name} #{year}"
  end

end
