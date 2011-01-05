class Wod
  include Mongoid::Document
  include Mongoid::Timestamps
  field :workout
  field :points, :type => Integer, :default => 0
  field :points_from, :type => Array, :default => []

  embeds_many :comments

  references_many :saved_by, :stored_as => :array, :inverse_of => :saved_wods, :class_name => "User"

  class << self
    def ranked
      criteria.descending(:points)
    end
    def most_recent
      criteria.descending(:created_at).first
    end
    def within_past_24h
      criteria.where(:created_at.gte => ( Time.now - ( 60*60*24 ) ) )
    end
  end

  #def self.all_by_rank
  #  rank_metrics = []
  #  self.all.each do |wod|
  #    rank_metrics.push([wod.rank_metric, wod])
  #  end
  #  rank_metrics.sort{ |a,b| b[0] <=> a[0] }.collect{ |x| x[1] }
  #end

  #def rank_metric
    # http://news.ycombinator.com/item?id=231209
    #t = (Time.now - self.created_at.to_i).to_i / 3600
    #p = self.points - 1
    #p / (t + 2)^1.5
    # so the current plan is to just show wods for the
    # past 24 hours, so we don't really have to correct
    # for time like hn, each wod will have it's 24hr period
    # to make it to the top, and newer ones should be at
    # the bottom to start
    #self.points
    # actually, there should be some correction for time,
    # although having a wod with 2 points ranked ahead of
    # a wod with 12 doesn't make sense, unless we show when
    # a wod was added - not sure what to do here yet...
  #end

  def has_point_from_user?(user)
    user = User.find(user) if user.is_a?(String) # something doesn't feel right here - should do something if user is nil - not sure what
    return false if user.is_admin?
    return self.points_from.include?(user.id.to_s) 
  end

  def points_from_users
    returning [] do |users|
      self.points_from.each do |from|
        users << User.first(:conditions => { :id => from })
      end
      users.compact!
    end
  end

  def has_comments?
    self.comments.present?
  end

  def upvote(by_user)
    return false unless by_user.is_a?(User) or by_user.is_a?(String)
    return false if has_point_from_user?(by_user)
    self.points = self.points + 1
    self.points_from << by_user if by_user.is_a?(String)
    self.points_from << by_user.id.to_s if by_user.is_a?(User)
    self.save
  end

end

class GymWod < Wod
  referenced_in :gym, :inverse_of => :gym_wod
end

class UserWod < Wod
  referenced_in :user, :inverse_of => :user_wods 

  field :title

  validates_presence_of :title
  validates_presence_of :workout
  validates_length_of :title, :minimum => 3, :maximum => 40
  # more validation needed for workout - length, chars, etc.
end
