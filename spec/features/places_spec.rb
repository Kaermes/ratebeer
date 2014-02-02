require 'spec_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    BeermappingAPI.stub(:places_in).with("kumpula").and_return( [  Place.new(:name => "Oljenkorsi", id: 3) ] )

    visit places_path
    fill_in('city', :with => 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple are returned by the API, they are shown at the page" do
    BeermappingAPI.stub(:places_in).with("helsinki").and_return( [  Place.new(:name => "Oljenkorsi", id: 1), Place.new(:name => "Paikka nro2", id: 2) ] )

    visit places_path
    fill_in('city', :with => 'helsinki')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Paikka nro2"
  end

  it "if none are returned by the API, show no locations found" do
    BeermappingAPI.stub(:places_in).with("anywhere").and_return( [] )

    visit places_path
    fill_in('city', :with => 'anywhere')
    click_button "Search"

    expect(page).to have_content "No locations in anywhere"
  end
end
