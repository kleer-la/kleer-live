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
require './lib/team_member'

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

  @team = [

    TeamMember.new('Israel Antezana','Agile Coach & Trainer','Bolivia','#israel','http://www.gravatar.com/avatar/8f90ff5fd8ecf9d6fe54953d856bba45?size=125'),
    TeamMember.new('Yamit Cárdenas','Agile Coach & Trainer','Colombia','#yamit','https://s.gravatar.com/avatar/ce5bae662027787ad70ba1f7add1eaff?size=125'),
    TeamMember.new('Ricardo Colusso','Agile Coach & Trainer','Argentina','#rick','https://s.gravatar.com/avatar/d3968e159690384999aebc9f0f62b828?size=125'),
    TeamMember.new('Juan Gabardini','Agile Coach & Trainer','Argentina','#juan','http://www.gravatar.com/avatar/72c191f31437b3250822b38d5f57705b?size=125'),
    TeamMember.new('Hiroshi Hiromoto','Agile Coach & Trainer','Perú','#hiro','https://s.gravatar.com/avatar/3a39c4fe86b368b3d7499ab28997541d?size=125'),
    TeamMember.new('Luis Mulato','Agile Coach & Trainer','Colombia','#luis','https://s.gravatar.com/avatar/a116e2b230e6738dc704cedd3662f07e?size=125'),
    TeamMember.new('Angel Núñez','Agile Coach & Trainer','Perú','#angel','https://s.gravatar.com/avatar/a7119e9b6be678f43708b31d0258c37c?size=125'),
    TeamMember.new('Gustavo Quiroz','Agile Coach & Trainer','Perú','#gustavo','https://s.gravatar.com/avatar/d884bfc94976ad940fc40e12dc156758?size=125'),
    TeamMember.new('Martín Salías','Agile Coach & Trainer','Argentina','#martin','http://www.gravatar.com/avatar/d30d818ef612cb5f4de1b8514a8b1996?size=125'),
    TeamMember.new('Pablo Tortorella','Agile Coach & Trainer','Argentina','#pablo','https://s.gravatar.com/avatar/74734f9ceda241e1b2f5c3174e47158c?size=125')

  ]

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
