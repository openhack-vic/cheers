FactoryGirl.define do
  factory :music do
    title "mario song"
    is_current_theme true
    user
    song File.open(File.join(Rails.root, '/spec/fixtures/song.mp3'))
  end
end
