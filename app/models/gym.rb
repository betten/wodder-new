require 'rubygems'
require 'hpricot'
require 'open-uri'

class Gym
  include Mongoid::Document

  field :name
  field :url
  field :wod_xpath
  field :current_id
  field :id_xpath

  referenced_in :gym_wod, :inverse_of => :gym

  def check_for_new_wod
    page = Hpricot(open(self.url))
    id = page.at(self.id_xpath).to_s
    if id != self.current_id
      self.current_id = id
      self.save
      wod = GymWod.new
      wod.workout = process_html(page.at(self.wod_xpath))
      wod.gym = self
      wod.save # should check wod save success
    end
  end

  protected

  def process_html(html)
    return html
  end
end
