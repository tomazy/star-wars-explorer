module Api::JsonHelper
  def json_link_hash(href)
    {
      _href: href,
      _text: href,
    }
  end
end

