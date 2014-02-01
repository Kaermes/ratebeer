require 'spec_helper'

describe User do
  it "has the username set correctly" do
    user = User.new :username => "Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a password" do
    user = User.create :username => "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with too short password" do
    user = User.create :username => "Pekka", password: "Pw1"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a password consisting of only letters" do
    user = User.create :username => "Pekka", password: "letters"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end

  end

  describe "favorite style" do

    let(:user){ FactoryGirl.create(:user) }
    
    it "has method for determining one" do
      user.should respond_to :favorite_style
    end

    it "does not exist without ratings" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only style if only one rating" do
      beer = create_beer_with_rating(10, user)
      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one with highest average rating if several rated" do
      create_beers_with_ratings_and_style(10, 20, 30, 40, 49, user, "Lager")
      create_beers_with_ratings_and_style(10, 20, 30, 40, 50, user, "Stout")
      create_beers_with_ratings_and_style(9, 19, 30, 40, 50, user, "Pils")

      expect(user.favorite_style).to eq("Stout")
    end

  end

  describe "favorite brewery" do
    let(:user){ FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_brewery
    end

    it "does not exist without ratings" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only brewery if only one rating" do
      beer = create_beer_with_rating("1", user)
      brewery = beer.brewery
      expect(user.favorite_brewery).to eq(brewery)
    end

    it "is the one with highest average rating if several rated" do
      brewery = FactoryGirl.create(:brewery)
      brewery2 = FactoryGirl.create(:brewery, name: "another")
      create_beers_with_ratings_and_brewery(1, 50, user, brewery)
      create_beers_with_ratings_and_brewery(2, 24, 50, user, brewery2)

      expect(user.favorite_brewery).to eq(brewery)
    end

  end

  def create_beer_with_rating(score,  user)
    beer = FactoryGirl.create(:beer)
    FactoryGirl.create(:rating, :score => score,  :beer => beer, :user => user)
    beer
  end

  def create_beer_with_rating_and_brewery(score, user, brewery)
    beer = FactoryGirl.create(:beer, brewery: brewery)
    FactoryGirl.create(:rating, :score => score,  :beer => beer, :user => user)
    beer  
  end
  
  def create_beer_with_rating_and_style(score, user, style)
    beer = FactoryGirl.create(:beer, :style => style)
    FactoryGirl.create(:rating, :score => score,  :beer => beer, :user => user)
    beer
  end

  def create_beers_with_ratings(*scores, user)
    scores.each do |score|
      create_beer_with_rating(score, user)
    end
  end

  def create_beers_with_ratings_and_brewery(*scores, user, brewery)
    scores.each do |score|
      create_beer_with_rating_and_brewery(score, user, brewery)
    end
  end

  def create_beers_with_ratings_and_style(*scores, user, style)
    scores.each do |score|
      create_beer_with_rating_and_style(score, user, style)
    end
  end
end
