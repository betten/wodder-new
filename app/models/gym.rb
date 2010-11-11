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
      wod.workout = "hi"
#      wod.workout = process_html(page.at(self.wod_xpath))
      wod.workout = page.at(self.wod_xpath)
      wod.gym = self
      wod.save # should check wod save success
    end
  end

  protected

  def process_html(html)
    html.search("hr").remove
    html = remove_all_attr(html, "style", "align", "id", "color" "font")
    html.search("[@class]").each do |e|
      e.remove_attribute("class")
    end
    html = convert_to_absolute(html, "a","href")
    html = convert_to_absolute(html, "img","src")
    html.search("a").each do |e|
      e.raw_attributes["target"] = '_blank'
    end
    html = Hpricot(html.to_s.gsub(/(\n*<br\s*\/?>){2,}/i,'<br /><br />'))
    return html
  end

  def convert_to_absolute(html, elem, attr)
    html.search(elem).each do |e|
      uri = e.attributes[attr]
      if uri.match('^http').nil?
        u = URI.parse(@href)
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
