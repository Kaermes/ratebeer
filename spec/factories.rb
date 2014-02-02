FactoryGirl.define do
  factory :user do
    username "Pekka"
    password "Foobar1"
    password_confirmation "Foobar1"
  end

  factory :style do
    name "Lager"
    description "durr"
  end

  factory :rating do
    score 10
  end

  factory :rating2, :class => Rating do
    score 20
  end

  factory :brewery do
    name "Testbrewery1"
    year 1900
  end
  
  factory :brewery2, :class => Brewery do
    name "Testbrewery2"
    year 1900
  end

  factory :beer do
    name "anonymous"
    brewery
    style
  end

  factory :beer2, :class => Beer do
    name "anon"
    brewery
    style
  end
end
