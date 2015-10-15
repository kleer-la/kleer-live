# encoding: utf-8

require File.join(File.dirname(__FILE__),'../lib/post')
require 'date'

class Store

  def initialize(blog_folder="store", blog_post_index="blog-posts.txt" )
    @blog_folder = blog_folder
    @blog_post_index = blog_post_index
    
    @blog_posts_hash = Hash.new
    @blog_posts_by_tag_hash = Hash.new
    @tags_hash = Hash.new


    load_posts
  end

  def parse_post_from( line )
    post_line = line.split("|")

    post = nil
        
    if post_line.size > 1
      post = Post.new
      
      post.language = post_line[0]
      post.date = Date.parse( post_line[1] )
      post.codename = post_line[2]
      post.title = post_line[3]
      post.featured_image = post_line[4]
      post.video_code = post_line[5]
      post.more = post_line[6]
      
      tags_line = post_line[7]

      tags = Array.new
      tags = tags_line.split(",") unless tags_line.nil?
      tags.each do |tag_name|

        tag_name = tag_name.strip
        tag_code = to_tag_code(tag_name)

        post.tags[tag_code] = tag_name

        if @tags_hash[post.language].nil?
          @tags_hash[post.language] = Hash.new
        end

        if @tags_hash[post.language][tag_code].nil?
          @tags_hash[post.language][tag_code] = tag_name
        end

      end


      post.folder = @blog_folder

    end
  
    post
  end

  def load_posts_from_index_file
    File.open("#{File.dirname(__FILE__)}/../" + @blog_folder + "/" + @blog_post_index , 'r') do |f1|  
      while line = f1.gets

        post = parse_post_from(line)

        if !post.nil?

          if @blog_posts_hash[post.language].nil?
            @blog_posts_hash[post.language] = Hash.new
          end
          
          @blog_posts_hash[post.language][post.codename] = post
        end
        
      end

    end
  end

  def link_posts_between_eachother
    @blog_posts_hash.each do |language_key, posts|
      if !posts.nil?
        previous_post = nil

        posts.reverse_each do |key, current_post|

          if !previous_post.nil?
            previous_post.next = current_post
            current_post.prev = previous_post
          end

          previous_post = current_post

        end
      end
    end
  end

  def index_all_tags

    @blog_posts_hash.each do |language_key, posts|

      if @blog_posts_by_tag_hash[language_key].nil?
        @blog_posts_by_tag_hash[language_key] = Hash.new
      end

      if !posts.nil?

        posts.each_value do |post|

          post.tags.each do |tag_code, tag_name|

            if @blog_posts_by_tag_hash[language_key][tag_code].nil?
              @blog_posts_by_tag_hash[language_key][tag_code] = Hash.new
            end

            @blog_posts_by_tag_hash[language_key][tag_code][post.codename] = post

          end

        end

      end
    end
  end

  def load_posts
    load_posts_from_index_file
    link_posts_between_eachother
    index_all_tags
  end
  
  def blog_posts( language, tag_code = nil )
    if tag_code.nil?
      @blog_posts_hash[language]
    else
      @blog_posts_by_tag_hash[language][tag_code]
    end
  end
  
  def blog_post(language, codename)
    post = @blog_posts_hash[language][codename]
    
    if post.body == ""
      File.open("#{File.dirname(__FILE__)}/../#{post.filename}", 'r') do |f1|  
        while line = f1.gets
          post.body += line
        end
      end
    end
    
    post
  end

  def tags( language )
    @tags_hash[language]
  end

  private

  def to_tag_code(tag_name)
    tag_code = tag_name
    tag_code = tag_code.gsub('á', 'a')
    tag_code = tag_code.gsub('é', 'e')
    tag_code = tag_code.gsub('í', 'i')
    tag_code = tag_code.gsub('ó', 'o')
    tag_code = tag_code.gsub('ú', 'u')
    tag_code = tag_code.gsub('Á', 'a')
    tag_code = tag_code.gsub('É', 'e')
    tag_code = tag_code.gsub('Í', 'i')
    tag_code = tag_code.gsub('Ó', 'o')
    tag_code = tag_code.gsub('Ú', 'u')
    tag_code = tag_code.gsub(' ', '-')
    tag_code.downcase
  end

end