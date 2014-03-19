class Music < ActiveRecord::Base
  mount_uploader :song, SongUploader
  belongs_to :user
end

