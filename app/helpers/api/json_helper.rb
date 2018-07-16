module Api::JsonHelper
  def json_link_hash(href, text)
    {
      _href: href,
      _text: text,
    }
  end
end

