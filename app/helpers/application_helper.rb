module ApplicationHelper

  def clean_user_input(text)
    text = sanitize(text, { :tags => %w(a) })
    text = auto_link(text)
    text = Hpricot(text)
    text.search("a").each{ |a| a.raw_attributes["target"] = "_blank" }
    text = text.to_s
    text.gsub!(/(\r\n){2,}/, "\r\n\r\n")
    text.gsub!("\r\n", tag('br'))
    return text
  end

  # see pluralize source at
  # http://api.rubyonrails.org/classes/ActionView/Helpers/TextHelper.html#method-i-pluralize
  # a method to pluralize just the given word was needed
  def pluralize_word(count, singular, plural = nil)
    (count == 1 || count =~ /^1(\.0+)?$/) ? singular : (plural || singular.pluralize)
  end

end
