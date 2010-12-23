require 'rubygems'
require 'hpricot'
require 'open-uri'

class Gym
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :url
  field :wod_xpath
  field :current_id
  field :id_xpath
  field :approved, :type => Boolean, :default => false
  field :has_errors, :type => Boolean, :default => false
  field :created_by_user_id

  references_many :gym_wod, :inverse_of => :gym

  key :name

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :url
  validates_presence_of :wod_xpath, :if => :approved?
  validates_presence_of :id_xpath, :if => :approved?

  class << self
    def approved
      criteria.where(:approved => true)
    end
    def unapproved
      criteria.where(:approved => false)
    end
    def with_errors
      criteria.where(:has_errors => true)
    end
    def without_errors
      criteria.where(:has_errors => false)
    end
  end

  def wods
    self.gym_wod
  end

  def has_wods?
    self.gym_wod.present?
  end

  def approved?
    self.approved
  end

  def has_errors?
    self.has_errors
  end

  def created_by
    User.find(self.created_by_user_id) if has_created_by?
  end

  def has_created_by?
    self.created_by_user_id.present?
  end

  def created_by=(user)
    self.created_by_user_id = user if user.is_a?(String)
    self.created_by_user_id = user.id.to_s if user.is_a?(User)
  end

  def check_for_new_wod
    returning Hash.new do |status|
      begin
        page = Hpricot(open(self.url))
        id = page.at(self.id_xpath).to_s
        if id != self.current_id
          self.current_id = id
          self.save
          self.wods.each do |wod|
            wod.destroy
          end
          create_gym_wod(page.at(self.wod_xpath))
          status[:updated] = true
        else
          status[:latest] = true
        end
        self.has_errors = false
        self.save
      rescue
        self.has_errors = true
        self.save
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
    html.search("*").each{ |e| (lst = e.parent.children; e.parent = nil; lst.delete(e)) if e.comment? }
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
