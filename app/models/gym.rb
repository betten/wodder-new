class Gym
  include Mongoid::Document
  field :name
  embeds_one :wod
end
