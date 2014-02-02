require 'spec_helper'

describe "BeermappingAPI" do
  it "When HTTP GET returns one entry, it is parsed and returned" do

   s = <<-END_OF_STRING
    <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>13307</id><name>O'Connell's Irish Bar</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=13307</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=13307&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=13307&amp;d=1&amp;type=norm</blogmap><street>Rautatienkatu 24</street><city>Tampere</city><state></state><zip>33100</zip><country>Finland</country><phone>35832227032</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*/).to_return(:body => s, :headers => { 'Content-Type' => "text/xml" })

    places = BeermappingAPI.places_in("tampere")

    expect(places.size).to eq(1)
    place = places.first
    expect(place.name).to eq("O'Connell's Irish Bar")
    expect(place.street).to eq("Rautatienkatu 24")
  end

  it "When HTTP GET returns multiple entries, they are parsed and returned" do

   s = <<-END_OF_STRING
    <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>13307</id><name>O'Connell's Irish Bar</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=13307</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=13307&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=13307&amp;d=1&amp;type=norm</blogmap><street>Rautatienkatu 24</street><city>Tampere</city><state></state><zip>33100</zip><country>Finland</country><phone>35832227032</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>18418</id><name>Bryggeri Helsinki</name><status>Brewpub</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=18418</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18418&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18418&amp;d=1&amp;type=norm</blogmap><street>Sofiankatu 2</street><city>Helsinki</city><state></state><zip>FI-00170</zip><country>Finland</country><phone>010 235 2500</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*/).to_return(:body => s, :headers => { 'Content-Type' => "text/xml" })

    places = BeermappingAPI.places_in("helsinki")

    expect(places.size).to eq(2)
    place = places[0]
    expect(place.name).to eq("O'Connell's Irish Bar")
    expect(place.street).to eq("Rautatienkatu 24")
    place2 = places[1]
    
    expect(place2.name).to eq("Bryggeri Helsinki")
    expect(place2.street).to eq("Sofiankatu 2")
  end

  it "When HTTP GET returns no entries, only empty list is returned" do

   s = <<-END_OF_STRING
    <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*/).to_return(:body => s, :headers => { 'Content-Type' => "text/xml" })

    places = BeermappingAPI.places_in("nowhere")

    expect(places.size).to eq(0)
  end



end
