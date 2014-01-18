module RatingAverage

def average_rating
  if !ratings.empty?
    ratings.inject(0) {|result, element| result + element.score}.to_f/ratings.count
  end
end

end

