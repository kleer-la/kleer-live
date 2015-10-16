# encoding: utf-8

require 'date'
require File.join(File.dirname(__FILE__),'../lib/store')
require File.join(File.dirname(__FILE__),'../lib/post')

describe Store do
  
  before(:each) do
    @store = Store.new("spec/store","blog-posts.txt")
  end
  
  it "should have two blog-post" do
   @store.blog_posts("es").size.should == 2
  end
  
  it "should have a 'trust' blog-post in spanish" do
    post = @store.blog_posts("es")["que-es-extreme-programming"]
    post.codename.should == "que-es-extreme-programming"
    post.title.should == "¿Qué es Extreme Programming?"
    post.date.should == Date.parse( "2015-10-7" )
  end
  
  it "should have two blog-post in spanish" do
   @store.blog_posts("es").count.should == 2
  end
  
  it "should have one blog-post in english" do
   @store.blog_posts("en").count.should == 1
  end
  
  it "should have no blog-post in french" do
   @store.blog_posts("fr").should be nil
  end

  it "should have 16 tags in spanish" do
    @store.tags("es").count.should == 16
  end

  it "should have two blog-post in spanish with tag kleer" do
   @store.blog_posts("es", "kleer").count.should == 2
  end

  it "should have one blog-post in spanish with tag retrospectiva" do
   @store.blog_posts("es", "retrospectiva").count.should == 1
  end

end