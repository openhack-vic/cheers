class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google]
  # attr_accessible :title, :body
  # Setup accessible (or protected) attributes for your model
  # attr_accessible :name, :description
  # attr_accessible :email, :password, :password_confirmation, :remember_me
  include ActiveModel::ForbiddenAttributesProtection
  has_many :music, :dependent => :destroy
  
  validates :name, :email, presence: true
  validates :email, uniqueness: true
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.google_data"] && data["info"]
        user.provider = data["info"].provider if user.provider.blank?
        user.google_uid = data["info"].uid if user.google_uid.blank?
        user.email = data["info"].email if user.email.blank?
        user.name = data["info"].name if user.name.blank?
      end
    end
  end
  
  def self.find_for_google_oauth(auth)
    u = where(auth.slice(:email)).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
    u.provider = auth.provider
    u.google_uid = auth.uid
    return u
  end

end
