require 'spec_helper'

describe "Beer" do

  let!(:brewery) {FactoryGirl.create :brewery, name:"Koff"}
  let!(:style) {FactoryGirl.create :style, name:"Weizen"}
  
  describe "when signed in" do
    before :each do
      FactoryGirl.create :user
      sign_in(username:"Pekka", password:"Foobar1")
    end

    it "with a valid name should be saved" do
       
      create_beer("Olut")
    
      expect{
        click_button("Create Beer")
      }.to change{Beer.count}.from(0).to(1)
    end
   
    describe "with invalid name" do 
      it "should not be saved" do
        create_beer("")
        click_button("Create Beer")
        
        expect(Beer.count).to eq(0)
      end
    
      it "should redirect to same page" do
        create_beer("")
        click_button("Create Beer")
        expect(page).to have_content("Name can't be blank")
      end
    end
  end

  def create_beer(name)
    visit new_beer_path
    fill_in('beer_name', with: name)
    select('Weizen', from:'beer[style_id]')
    select('Koff', from:'beer[brewery_id]')
  end
end




