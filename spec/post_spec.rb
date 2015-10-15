# encoding: utf-8

require File.join(File.dirname(__FILE__),'../lib/post')

describe Post do
  
  before(:each) do
      @post = Post.new
    end
    
    it "should have a language" do
      @post.language = "es"
      @post.language.should == "es"
    end

    it "should have a tags hash" do
      @post.tags.size.should == 0
    end

    it "should have a title" do
      @post.title = "pepepe"
      @post.title.should == "pepepe"
    end

    it "should have a fetured image" do
      @post.featured_image = "pepepe"
      @post.featured_image.should == "pepepe"
    end

    it "should have a subtitle" do
      @post.subtitle = "pepepe"
      @post.subtitle.should == "pepepe"
    end

    it "should have a date" do
      @post.date = "pepepe"
      @post.date.should == "pepepe"
    end
    
    it "should have a more text" do
      @post.more = "pepepe"
      @post.more.should == "pepepe"
    end
  
    it "should have a codename" do
      @post.codename = "pepepe"
      @post.codename.should == "pepepe"
    end
    
    it "should have a folder" do
      @post.folder = "pepepe"
      @post.folder.should == "pepepe"
    end
    
    it "should have a filename" do
      @post.codename = "pepepe"
      @post.language = "es"
      @post.folder = "ramon/falcon"
      @post.filename.should == "ramon/falcon/es/pepepe.txt"
    end
    
    it "should have a body" do
      @post.body = "pepepe"
      @post.body.should == "pepepe"
    end
end