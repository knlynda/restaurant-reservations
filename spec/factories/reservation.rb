FactoryGirl.define do
  factory :reservation do
    sequence(:table_number)

    start_time { Time.zone.now }
    end_time { (rand(12) + 1).hours.since }
  end
end