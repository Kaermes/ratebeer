class User < ActiveRecord::Base
  include RatingAverage
  
  has_secure_password

  validates :username, uniqueness: true,
                       length: {minimum: 3, maximum: 15}
  validates :password, length: {minimum: 4}  

  validate :password_should_contain_upper_case,
           :password_should_contain_numbers

  has_many :memberships, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :beer_clubs, through: :memberships


  def password_should_contain_upper_case
    if password
      errors.add(:password, "has to contain at least one upper case letter") unless password.match(/\p{Upper}/)
    end
  end

  def password_should_contain_numbers
    if password
    errors.add(:password, "has to contain at least one number") unless password.match(/\p{Number}/)
    end
  end
  
  def favorite_beer
    favorite_x(:beer)
  end

  def favorite_style
    favorite_x(:style)
  end
  
  def favorite_brewery
    favorite_x(:brewery)
  end 




  private

  def favorite_x(x) #for beer/style/brewery
    return nil if ratings.empty?
    if x == :beer
      ratings.order(score: :desc).limit(1).first.beer
    else
      grouped = ratings.group_by {|r| r.beer.send(x)}
      grouped.keys.each {|key| grouped[key] = average_rating(grouped[key])}
      grouped.sort_by {|k, v| v}.last[0]
    end 
  end

end
