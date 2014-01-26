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
end
