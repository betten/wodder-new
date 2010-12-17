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

end
