require 'uri'
require 'cgi'

module Jekyll
  class YouTubeTag < Liquid::Tag
    def initialize(tag_name, video_url, tokens)
      super
      query = URI::parse(video_url).query
      params = CGI::parse(query)
      @vid = params["v"][0]
    end

    def render(context)
      %|<iframe width="560" height="315" src="http://www.youtube.com/embed/#{@vid}" frameborder="0" allowfullscreen></iframe>|
    end
  end
end

Liquid::Template.register_tag('youtube', Jekyll::YouTubeTag)
