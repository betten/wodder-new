require 'digest/md5'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  validates_presence_of :email, :password
  validates_uniqueness_of :email
  validates_format_of :email, :with => /[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/
  validates_length_of :password, :within => 4..20
  validates_confirmation_of :password

  field :email
  field :password
  field :salt

  embeds_many :saved_wods
  referenced_in :user_wod

  before_save :hash_password  

  def self.authenticate(email, password)
    u = User.first(:conditions => { :email => email })
    return u if u.password == hash(password, u.salt)
    return nil
  end

  protected

  def hash(password, salt)
    return Digest::MD5.hexdigest(password + salt)
  end

  def generate_salt
    return Time.now.to_s # a better salt most likely exists
  end

  def hash_password
    self.password = hash(self.password, generate_salt) if self.password_changed?
  end
end
