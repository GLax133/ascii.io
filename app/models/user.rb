class User < ActiveRecord::Base

  attr_accessible :email, :passwd, :passwd_confirmation
  attr_accessible :name,:nickname
  
  attr_accessor :passwd
  before_save :encrypt_password

  has_many :user_tokens, :dependent => :destroy
  has_many :asciicasts, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :likes, :dependent => :destroy


  validates_confirmation_of :passwd
  validates_presence_of :passwd, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  has_many :user_tokens, :dependent => :destroy
  has_many :asciicasts, :dependent => :destroy
  has_many :comments, :dependent => :destroy


  def self.create_with_omniauth(auth)
    user = new
    user.provider   = auth["provider"]
    user.email   = auth["email"]
    user.uid        = auth["uid"]
    user.nickname   = auth["info"]["nickname"]
    user.name       = auth["info"]["name"]
    user.avatar_url = OauthHelper.get_avatar_url(auth)
    user.save
    user
  end


  def add_user_token(token)
    user_tokens.find_or_create_by_token(token)
  end

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if passwd.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password = BCrypt::Engine.hash_secret(passwd, password_salt)
    end
  end
end
