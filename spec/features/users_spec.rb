require 'spec_helper'

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'username and password do not match'
    end

    it "can delete ratings made by him" do
      sign_in(username:"Pekka", password:"Foobar1")
      user = User.first
      beer1 = FactoryGirl.create :beer
      user.ratings << (FactoryGirl.create :rating, beer: beer1, score: 15, user: user)
      visit user_path(user) 

      expect { 
        click_link('destroy')
      }.to change{Rating.count}.from(1).to(0)
    end
    
  end

  describe "own page" do
    let!(:user1) {FactoryGirl.create :user, username: "New"}    
    let!(:user2) {FactoryGirl.create :user, username: "Newer"}
    let!(:beer1) {FactoryGirl.create :beer}
    let!(:beer2) {FactoryGirl.create :beer2}
    let!(:rating1) {FactoryGirl.create :rating, beer: beer1, score: 15, user: user1}
    let!(:rating2) {FactoryGirl.create :rating, beer: beer2, score: 20, user: user1}
    let!(:rating3) {FactoryGirl.create :rating, beer: beer1, score: 25, user: user2}


    it "has a list of ratings made by this user" do
      visit user_path(user1)

      expect(page).to have_content("has given 2 ratings")
      expect(page).to have_content("#{beer1.name} #{beer1.brewery.name} 15")
      expect(page).to have_content("#{beer2.name} #{beer2.brewery.name} 20")
      expect(page).not_to have_content("#{beer1.name} #{beer1.brewery.name} 25")
    end

    it "shows user's favorite beer style" do
      visit user_path(user1)

      expect(page).to have_content("Favorite beer style: #{beer2.style} ")
    end

    it "shows user's favorite brewery" do
      visit user_path(user1)

      expect(page).to have_content("Favorite brewery: #{beer1.brewery}")
    end

  end
end

