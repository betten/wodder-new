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
  embeds_many :saved_wods
  referenced_in :user_wod

end
