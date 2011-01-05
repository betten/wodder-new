require 'digest/md5'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  RESERVED_WORDS = %w(wods signup signin signout edit show create delete index update destroy donate)

  validates_presence_of :email, :username, :password
  validates_uniqueness_of :email
  validates_uniqueness_of :username
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of :username, :without => /\W/
  validates_length_of :username, :within => 4..20
  validates_length_of :password, :within => 4..40
  validates_confirmation_of :password
  validate do |user|
    user.errors[:username] << "is already taken" if RESERVED_WORDS.include?(user.username)
  end

  field :username
  field :email
  field :password
  field :salt
  field :admin, :type => Boolean, :default => false
  field :paid, :type => Boolean, :default => false

  key :username

  references_many :user_wods, :inverse_of => :user
  references_many :comments, :inverse_of => :user
  references_many :saved_wods, :stored_as => :array, :inverse_of => :saved_by, :class_name => "Wod"

  before_save :hash_password

#  class << self
#    def that_have_created_wods
#      criteria.select{ |user| user.wods.present? }
#    end
#  end

  def self.all_that_have_created_wods
    User.all.select{ |user| user.has_wods? }.sort { |x,y| y.wods.most_recent.created_at.to_i <=> x.wods.most_recent.created_at.to_i }
  end

  def self.authenticate(email, password)
    u = User.first(:conditions => { :email => email })
    return u unless u.nil? or u.password != User.digest(password, u.salt)
    return nil
  end

  def self.digest(password, salt)
    return Digest::MD5.hexdigest(password + salt)
  end

  def wods
    self.user_wods
  end

  def has_wods?
    self.wods.present?
  end

  def is_admin?
    self.admin
  end

  def is?(user)
    return true if user.is_a?(User) and self.id == user.id
    return true if user.is_a?(String) and self.id == user
    return false
  end

  def is_paid?
    self.paid
  end

  def has_saved_wod?(wod)
    return false unless has_saved_wods?
    return self.saved_wod_ids.include?(wod.id) if wod.is_a?(Wod)
    return self.saved_wod_ids.include?(wod) if wod.is_a?(String)
    return false
  end

  def has_saved_wods?
    self.saved_wods.present?
  end

  def points
    self.wods.inject(0) { |points, wod| points + wod.points }
  end

  protected

  def generate_salt
    return Time.now.to_i.to_s # a better salt most likely exists
  end

  def hash_password
    return true unless self.password_changed? or self.new_record?
    self.salt = generate_salt
    self.password = User.digest(self.password, self.salt)
  end
end
