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
    post = @store.blog_posts("es")["trust"]
    post.codename.should == "trust"
    post.title.should == "Inspeccionar y adaptar las posibilidades personales"
    post.date.should == Date.parse( "2012-09-03" )
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

  it "should have four tags in spanish" do
    @store.tags("es").count.should == 4
  end

  it "should have two blog-post in spanish with tag por-comas" do
   @store.blog_posts("es", "por-comas").count.should == 2
  end

  it "should have one blog-post in spanish with tag los-tags" do
   @store.blog_posts("es", "los-tags").count.should == 1
  end

  it "should have two spanish conference" do
    @store.conferences("es").size.should == 2
  end

  it "should have one english conference" do
    @store.conferences("en").size.should == 1
  end

end