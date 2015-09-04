class User < ActiveRecord::Base
  has_many :restaurants, dependent: :destroy
  has_many :reviews
  has_many :reviewed_restaurants, through: :reviews, source: :restaurant
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      name = auth.info.name.gsub(' ', '').downcase
      user.email = "#{name}@facebook.com"
      user.password = Devise.friendly_token[0,20]
    end
  end

end
