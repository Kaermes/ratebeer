class BeermappingAPI
  def self.places_in(city)
    Place # varmistaa, että luokan koodi on ladattu
    Time

    city = city.downcase

    if Rails.cache.exist?(city) and not expired?(city)
      Rails.cache.read(city)[0]
    else
      Rails.cache.write city, [fetch_places_in(city), Time.now]
      Rails.cache.read(city)[0]
    end
  end

  def self.scores_for(place)
    url = "http://beermapping.com/webservice/locscore/#{key}/#{place.id}"

    response = HTTParty.get "#{url}"

    return place unless response and response["bmp_locations"]

    scores = response.parsed_response["bmp_locations"]["location"]

    place.fill_attributes(scores)
  end

  private

  def self.fetch_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{city.gsub(' ', '%20')}"

    #sometimes this fails
    #and we may cache bad results, better let it fail for now
    #return [] unless response
    #return [] unless response["bmp_locations"]

    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.inject([]) do | set, place |
      set << Place.new(place)
    end
  end

  def self.expired?(city) #tein itse ja säästin
    Rails.cache.read(city)[1] < Time.now.ago(1.hour.seconds)
  end

  def self.key
    Settings.beermapping_apikey
  end
end


