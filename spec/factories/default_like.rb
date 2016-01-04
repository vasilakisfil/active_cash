FactoryGirl.define do
  factory :default_like do
    video_id { rand(1...10000) }
    user_id { rand(1...10000) }
  end
end

FactoryGirl.define do
  factory :empty_like do
    video_id { rand(1...10000) }
    user_id { rand(1...10000) }
  end
end
