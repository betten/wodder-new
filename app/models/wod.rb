class Wod
  include Mongoid::Document
  include Mongoid::Timestamps
  field :workout
end

class UserWod < Wod
  references_one :user
end

class SavedWod < Wod
  embedded_in :user, :inverse_of => :saved_wods
end

class GymWod < Wod
  embedded_in :gym, :inverse_of => :wod
end
