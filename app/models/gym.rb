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

  references_many :gym_wod, :inverse_of => :gym

  key :name

  def wods
    self.gym_wod
  end

  def check_for_new_wod
    returning Hash.new do |status|
      begin
        page = Hpricot(open(self.url))
        id = page.at(self.id_xpath).to_s
        if id != self.current_id
          self.current_id = id
          self.save
          create_gym_wod(page.at(self.wod_xpath))
          status[:updated] = true
        else
          status[:latest] = true
        end
      rescue
        status[:error] = true
      end
    end
  end

  private

  def create_gym_wod(raw_workout_html)
    wod = GymWod.new
    wod.workout = process_html(raw_workout_html)
    #wod.workout = page.at(self.wod_xpath)
    wod.gym = self
    wod.save # should check wod save success
  end

  def process_html(html)
    html.search("hr").remove
    html.search("img").remove
    html.search("object").remove
    html.search("embed").remove
    html = remove_all_attr(html, "style", "align", "id", "color" "font", "class")
    html = convert_to_absolute(html, "a","href")
    html = convert_to_absolute(html, "img","src")
    html.search("a").each do |e|
      e.raw_attributes["target"] = '_blank'
    end
    return html
  end
  
  def convert_to_absolute(html, elem, attr)
    html.search(elem).each do |e|
      uri = e.attributes[attr]
      if uri.match('^http').nil?
        u = URI.parse(self.url)
        href = u + uri
        e.raw_attributes[attr] = href.to_s
      end
    end
    return html
  end

  def remove_all_attr(html, *attrs)
    attrs.each do |attr|
      html.search("[@"+attr+"]").each do |e|
        e.remove_attribute(attr)
      end
    end
    return html
  end

end
