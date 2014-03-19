class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, :omniauth_providers => [:google_oauth2]
  # attr_accessible :title, :body
  # Setup accessible (or protected) attributes for your model
  # attr_accessible :name, :description
  # attr_accessible :email, :password, :password_confirmation, :remember_me
  has_many :music, :dependent => :destroy

  validates :name, :email, presence: true
  validates :email, uniqueness: true

  def self.find_for_open_id(auth, signed_in_resource=nil)
    user = User.where(provider: auth.provider, email: auth.info.email).first
    unless user
      data = auth.info
      user_info = {
        provider:auth.provider, name: data.name, email: data.email, password:Devise.friendly_token[0,20] }
      user = User.create!( user_info )
    end
    user
  end

end
