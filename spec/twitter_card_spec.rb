# encoding: utf-8

require 'date'
require File.join(File.dirname(__FILE__),'../lib/twitter_card')

describe TwitterCard do
  
  before(:each) do
    @tc = TwitterCard.new
  end
  
  it "should have one card_type" do
    @tc.card_type = "fsdfsfd"
    @tc.card_type.should == "fsdfsfd"
  end
  
  it "should have one site" do
    @tc.site = "fsdfsfd"
    @tc.site.should == "fsdfsfd"
  end
  
  it "should have one creator" do
    @tc.creator = "fsdfsfd"
    @tc.creator.should == "fsdfsfd"
  end
  
  it "should have one title" do
    @tc.title = "fsdfsfd"
    @tc.title.should == "fsdfsfd"
  end
  
  it "should have one description" do
    @tc.description = "fsdfsfd"
    @tc.description.should == "fsdfsfd"
  end  

  it "should have one image_url" do
    @tc.image_url = "fsdfsfd"
    @tc.image_url.should == "fsdfsfd"
  end        
end