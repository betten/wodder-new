class Wod
  include Mongoid::Document
  include Mongoid::Timestamps
  field :workout
  field :points, :type => Integer, :default => 0

  def self.all_by_rank
    rank_metrics = []
    self.all.each do |wod|
      rank_metrics.push([wod.rank_metric, wod])
    end
    x = rank_metrics.sort{ |a,b| a[0] <=> b[0] }.collect{ |x| x[1] }
  end

  def rank_metric
    # http://news.ycombinator.com/item?id=231209
    t = (Time.now - self.created_at.to_i).to_i / 3600
    self.points / (t + 2)^1.5
  end

end

class GymWod < Wod
  referenced_in :gym, :inverse_of => :gym_wod
end

class UserWod < Wod
  referenced_in :user, :inverse_of => :user_wods 
end
