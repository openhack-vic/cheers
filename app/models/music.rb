class Music < ActiveRecord::Base
  mount_uploader :song, SongUploader
  # attr_accessible :title, :body
  include ActiveModel::ForbiddenAttributesProtection
  
  belongs_to :user
end

