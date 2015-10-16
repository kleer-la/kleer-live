# encoding: utf-8
require 'rubygems' if RUBY_VERSION < '1.9'
require 'sinatra'
require 'sinatra/r18n'
require 'sinatra/flash'
require 'redcarpet'
require 'json'
require 'rss'
require 'i18n'

require File.join(File.dirname(__FILE__),'lib/store')
require File.join(File.dirname(__FILE__),'lib/twitter_card')
require File.join(File.dirname(__FILE__),'lib/facebook_open_graph')

helpers do
  
  def t(key, ops = Hash.new)
    ops.merge!(:locale => session[:locale])
    I18n.t key, ops
  end
  
end

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
  
  I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'locales', '*.yml').to_s]
  
  enable :sessions
  
  set :store, Store.new
end

before do
  if request.path.length < 3 || request.path[3] != "/" 
    redirect "http://" + request.host + ( request.port==80 ? "" : ":#{request.port}") + "/es" + request.path, 301
  end  
end

before '/:locale/*' do
    
  locale = params[:locale]
  
  if locale == "es"
    session[:locale] = locale
    request.path_info = '/' + params[:splat][0]
    
     @page_title = t("site.name")

      @twitter_card = TwitterCard.new
      @twitter_card.card_type = "summary"
      @twitter_card.site = "@kleer_la"
      @twitter_card.creator = "@kleer_la"
      @twitter_card.image_url = ""

      @facebook_og = FacebookOpenGraph.new
      @facebook_og.site_name = t("site.name")
      @facebook_og.og_type = "blog"
      @facebook_og.image = @twitter_card.image_url

      @active_section = ""
      flash.sweep 
      @markdown_renderer = Redcarpet::Markdown.new(
                                Redcarpet::Render::HTML.new(:hard_wrap => true), :autolink => true, :footnotes => true )
  end
end

get '/' do
    
  @active_section = "index"

  @twitter_card.title = @page_title
  @twitter_card.description = t("site.twittercard.description")
  
  @facebook_og.title = @twitter_card.title
  @facebook_og.description = @twitter_card.description
  
  @blog_posts = settings.store.blog_posts( session[:locale] )
  @tags = settings.store.tags( session[:locale] )
  
  erb :index
  
end

get '/tag/:tag_code' do

  tag_code = params[:tag_code]

  @active_section = "videos"
  
  @page_title = "Sesiones | " + @page_title
  
  @twitter_card.title = @page_title
  @twitter_card.description = t("site.twittercard.bio")
  
  @facebook_og.title = @twitter_card.title
  @facebook_og.description = @twitter_card.description

  @blog_posts = settings.store.blog_posts( session[:locale], tag_code )
  @tags = settings.store.tags( session[:locale] )
  
  erb :only_videos
end
