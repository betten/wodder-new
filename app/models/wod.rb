class Wod
  include Mongoid::Document
  include Mongoid::Timestamps
  field :workout
end

class GymWod < Wod
  references_one :gym, :inverse_of => :gym_wod
end

class UserWod < Wod
  references_one :user 
end
