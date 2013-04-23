class Asciicast < ActiveRecord::Base
  MAX_DELAY = 500.0

  mount_uploader :stdin, BasicUploader
  mount_uploader :stdin_timing, BasicUploader
  mount_uploader :stdout, BasicUploader
  mount_uploader :mp3, BasicUploader
  mount_uploader :picture_timing, BasicUploader
  mount_uploader :stdout_timing, BasicUploader

  validates :mp3, :stdout, :stdout_timing, :picture_timing,:presence => true
  validates :terminal_columns, :terminal_lines, :duration, :presence => true

  belongs_to :user
  has_many :comments, :order => :created_at, :dependent => :destroy
  has_many :likes, :dependent => :destroy
  has_many :pictures, :dependent => :destroy

  scope :featured, where(:featured => true)
  scope :popular, where("views_count > 0").order("views_count DESC")
  scope :newest, order("created_at DESC")

  scope(:newest_paginated, lambda do |page, per_page|
    newest.includes(:user).page(page).per(per_page)
  end)

  scope(:popular_paginated, lambda do |page, per_page|
    popular.includes(:user).page(page).per(per_page)
  end)

  before_create :assign_user, :unless => :user

  attr_accessible :meta, :stdout, :stdout_timing, :mp3,:picture_timing, :stdin, :stdin_timing,
                  :title, :description, :time_compression, :username

  def self.assign_user(user_token, user)
    where(:user_id => nil, :user_token => user_token).
    update_all(:user_id => user.id, :user_token => nil)
  end

  def self.cache_key
    timestamps = scoped.select(:updated_at).map { |o| o.updated_at.to_i }
    Digest::MD5.hexdigest timestamps.join('/')
  end

  def meta=(file)
    data = JSON.parse(file.tempfile.read)

    self.username         = data['username']
    self.user_token       = data['user_token']
    self.duration         = data['duration']
    self.recorded_at      = data['recorded_at']
    self.title            = data['title']
    self.command          = data['command']
    self.shell            = data['shell']
    self.uname            = data['uname']
    self.terminal_lines   = data['term']['lines']
    self.terminal_columns = data['term']['columns']
    self.terminal_type    = data['term']['type']
  end

  def assign_user
    if user_token.present?
      if ut = UserToken.find_by_token(user_token)
        self.user = ut.user
        self.user_token = nil
      end
    end
  end
end
