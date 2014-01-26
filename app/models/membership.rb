class Membership < ActiveRecord::Base
  belongs_to :beer_club
  belongs_to :user

  validate :user_is_not_a_member_yet

  def user_is_not_a_member_yet
    errors.add(:user_id, "user is already a member") if beer_club.members.include?(User.find_by_id(user_id))
  end
end
