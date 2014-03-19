require 'spec_helper'
require 'carrierwave/test/matchers'

describe SongUploader do
  include CarrierWave::Test::Matchers
  let (:user) { create :user }
  let (:music) { create :music }
  let (:uploader) { SongUploader.new(music) }

  before do
    SongUploader.enable_processing = true
  end

  after do
    SongUploader.enable_processing = false
    uploader.remove!
  end

  describe '.store_dir' do
    it 'returns the corret file path' do
      expect(uploader.store_dir).to eq "uploads/#{music.class.to_s.underscore}/user_#{music.user_id}"
    end
  end

  describe '.identifier!' do
    it 'returns the corret file name' do
      expect(uploader.model.song.identifier!).to eq music.song.file.identifier
    end
  end
end
