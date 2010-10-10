require 'digest/md5'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  validates_presence_of :email, :password
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_length_of :password, :within => 4..20
  validates_confirmation_of :password

  field :email
  field :password
  field :salt

  embeds_many :saved_wods
  referenced_in :user_wod

  before_create :hash_password
  before_save :hash_password, :if => :password_changed?

  def self.authenticate(email, password)
    u = User.first(:conditions => { :email => email })
    return u unless u.nil? or u.password != User.digest(password, u.salt)
    return nil
  end

  def self.digest(password, salt)
    return Digest::MD5.hexdigest(password + salt)
  end

  protected

  def generate_salt
    return Time.now.to_i.to_s # a better salt most likely exists
  end

  def hash_password
    self.salt = generate_salt
    self.password = User.digest(self.password, self.salt)
  end
end
