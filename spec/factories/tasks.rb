FactoryBot.define do
  factory :task do
    name { Faker::StarWars.character }
    done false
    deadline Date.current
    project_id nil
  end
end
