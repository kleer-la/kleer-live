# encoding: utf-8

require File.join(File.dirname(__FILE__),'../lib/conference')

describe Conference do
  
  before(:each) do
      @conference = Conference.new
    end
    
    it "should have a language" do
      @conference.language = "es"
      @conference.language.should == "es"
    end

    it "should have a title" do
      @conference.title = "pepepe"
      @conference.title.should == "pepepe"
    end

    it "should have a date" do
      @conference.date = "pepepe"
      @conference.date.should == "pepepe"
    end
    
    it "should have a link" do
      @conference.link = "pepepe"
      @conference.link.should == "pepepe"
    end
  
    it "should have an event name" do
      @conference.event_name = "pepepe"
      @conference.event_name.should == "pepepe"
    end
    
    it "should have a city" do
      @conference.city = "pepepe"
      @conference.city.should == "pepepe"
    end
    
    it "should have a country" do
      @conference.country = "pepepe"
      @conference.country.should == "pepepe"
    end

    it "should have a key" do
      @conference.language = "es"
      @conference.title = "pepepe"
      @conference.event_name = "un evento padre"

      @conference.key.should == "es|pepepe|un evento padre"
    end
end