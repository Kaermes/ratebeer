require 'spec_helper'

describe Beer do

  it "is saved if it has a name and a style" do
    beer = Beer.create name: "Olut", style: Style.new

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end 

  it "is not saved if it has no name" do
    beer = Beer.new style: Style.new

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved if it has no style" do
    beer = Beer.new name: "Olut"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

end
