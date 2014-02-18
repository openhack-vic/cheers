class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # attr_accessible :title, :body
  # Setup accessible (or protected) attributes for your model
  # attr_accessible :name, :description
  # attr_accessible :email, :password, :password_confirmation, :remember_me
  include ActiveModel::ForbiddenAttributesProtection
  has_many :music, :dependent => :destroy
end
