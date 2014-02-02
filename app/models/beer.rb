class Beer < ActiveRecord::Base
	include RatingAverage

	belongs_to :brewery
  belongs_to :style
	has_many :ratings, :dependent => :destroy
  has_many :raters, -> {uniq}, through: :ratings, source: :user


  validates :style, presence: true
  validates :name, presence: true

	def to_s
		"#{name} #{brewery.name}"
	end
	
end
