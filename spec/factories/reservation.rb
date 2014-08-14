FactoryGirl.define do
  factory :reservation do
    table { create(:table) }
    start_time { Time.zone.now }
    end_time { (rand(12) + 1).hours.since }
  end
end