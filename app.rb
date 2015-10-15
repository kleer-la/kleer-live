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

get '/blog/tag/:tag_code' do

  tag_code = params[:tag_code]

  @active_section = "blog"
  
  @page_title = "Blog | " + @page_title
  
  @twitter_card.title = @page_title
  @twitter_card.description = t("martin.twittercard.bio")
  
  @facebook_og.title = @twitter_card.title
  @facebook_og.description = @twitter_card.description

  @blog_posts = settings.store.blog_posts( session[:locale], tag_code )
  @tags = settings.store.tags( session[:locale] )
  
  erb :blog
end

get '/blog/:post_codename' do
  
  @active_section = "blog"
  
  codename = params[:post_codename]
  
  @post = settings.store.blog_post( session[:locale], codename )
  
  @page_title = @post.title + " | " + @page_title

  @twitter_card.title = @post.title
  @twitter_card.description = @post.more
  
  @facebook_og.title = @twitter_card.title
  @facebook_og.description = @twitter_card.description

  @tags = settings.store.tags( session[:locale] )

  if @post.featured_image != ""
    @twitter_card.image_url = "http://#{request.host}#{@post.featured_image}"
    @facebook_og.image = @twitter_card.image_url
    erb :post_with_image
  else
    erb :post
  end
end

get '/libros' do
  @active_section = "books"
  erb :libros
end

get '/books' do
  @active_section = "books"
  erb :libros
end

get '/enloqueando' do
  @active_section = "enloqueando"
  erb :enloqueando
end

get '/conferencias' do
  @active_section = "conferences"
  
  @page_title = "Conferencias | " + @page_title
  
  @twitter_card.title = @page_title
  @twitter_card.description = t("martin.twittercard.bio")
  
  @facebook_og.title = @twitter_card.title
  @facebook_og.description = @twitter_card.description

  @conferences = settings.store.conferences( session[:locale] )
  erb :conferencias
end

get '/conferences' do
  @active_section = "conferences"
  
  @page_title = "Conferences | " + @page_title
  
  @twitter_card.title = @page_title
  @twitter_card.description = t("martin.twittercard.bio")
  
  @facebook_og.title = @twitter_card.title
  @facebook_og.description = @twitter_card.description

  @conferences = settings.store.conferences( session[:locale] )

  erb :conferencias
end

get '/mas-productivos' do
  
  if session[:locale] == "en"
    redirect "/en/high-performing"
  else
    @active_section = "mas-productivos"
    
    @page_title = t("mas_productivos.title") + " | " + @page_title
  
    @twitter_card.title = @page_title
    @twitter_card.description = t("mas_productivos.twittercard.description")
  
    @facebook_og.title = @twitter_card.title
    @facebook_og.description = @twitter_card.description
  
    erb :mas_productivos
  end
end

get '/high-performing' do
  
  @active_section = "mas-productivos"
    
  @page_title = t("mas_productivos.title") + " | " + @page_title
  
  @twitter_card.title = @page_title
  @twitter_card.description = t("mas_productivos.twittercard.description")
  
  @facebook_og.title = @twitter_card.title
  @facebook_og.description = @twitter_card.description
  
  erb :mas_productivos
end

get '/mas-productivos/:chapter_codename' do
  
  codename = params[:chapter_codename]
  
  blog_post_url = "/blog/#{codename}"
  if !session[:locale].nil?
    blog_post_url = "/#{session[:locale]}#{blog_post_url}"
  end
  
  redirect blog_post_url
end

get '/agenda' do
  @active_section = "agenda"
  @events = settings.keventer_reader.events
  erb :agenda
end

get '/scrum' do
  @active_section = "scrum"
  @page_title = "Proyectos Ágiles con Scrum (Libro) | " + @page_title
  erb :scrum
end

get '/feed' do
  redirect '/feed/'
end

get '/medium' do
  
  @active_section = "blog"
  
  url = 'https://medium.com/feed/@martinalaimo'
  
  begin
    @rss = RSS::Parser.parse(url)
  rescue RSS::InvalidRSSError
    @rss = RSS::Parser.parse(url, false)
  end
  
  erb :medium
end

get '/feed/' do
  @blog_posts = settings.store.blog_posts( session[:locale] )
  
  rss = RSS::Maker.make("2.0") do |maker|
    #xss = maker.xml_stylesheets.new_xml_stylesheet
    #xss.href = "http://example.com/index.xsl"

    maker.channel.title = t("martin.name")
    maker.channel.description = "Blog | #{t("martin.name")} | Agile Coach & Trainer"
    maker.channel.link = "http://martinalaimo.com/"

    maker.items.do_sort = true

    @blog_posts.each do |key, post|
      
      maker.items.new_item do |item|
        item.link = "http://martinalaimo.com/#{post.language}/blog/#{post.codename}"
        item.title = post.title
        item.date = Time.parse( post.date.to_s )
        item.description = @markdown_renderer.render( parse_footnotes( settings.store.blog_post(session[:locale], post.codename).body ) )
      end
      
    end

  end
  
  content_type 'text/xml'
  erb rss.to_s, :layout => :layout_empty
  
end

post '/xacars/flightinfo' do
  settings.xacars.start( params[:DATA1], params[:DATA2] )
end

get '/xacars/flightinfo' do
  settings.xacars.start( params[:DATA1], params[:DATA2] )
end

post '/xacars/address' do
  settings.xacars.address( params[:DATA1], params[:DATA2], params[:DATA3], params[:DATA4] )
end

post '/xacars/pirep' do
  settings.xacars.pirep( params[:DATA1], params[:DATA2], params[:DATA3], params[:DATA4] )
end