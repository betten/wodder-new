class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text

  referenced_in :user

  embedded_in :wod, :inverse_of => :comments

  validates_presence_of :text
  validates_presence_of :user
  validates_length_of :text, :minimum => 4

end
