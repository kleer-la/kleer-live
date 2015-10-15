class Post
  
  attr_accessor :language, :title, :subtitle, :featured_image, 
                :date, :codename, :folder, :more, :body,:next, 
                :prev, :wordcount, :tags, :video_code
  
  MONTHS_ES = { "Jan" => "Ene", "Feb" => "Feb", "Mar" => "Mar", "Apr" => "Abr", "May" => "May", "Jun" => "Jun",
                  "Jul" => "Jul", "Aug" => "Ago", "Sep" => "Sep", "Oct" => "Oct", "Nov" => "Nov", "Dec" => "Dic"}
  
  def initialize
    @language = ""
    @title = ""
    @subtitle = ""
    @featured_image = ""
    @video_code = ""
    @date = ""
    @codename = ""
    @folder = ""
    @more = ""
    @body = ""
    @next = nil
    @prev = nil
    @tags = Hash.new
  end
  
  def filename
    @folder + "/" + @language + "/" + @codename + ".txt"
  end
  
  def human_date(locale = "es")
    if locale == "en"
      @date.strftime("%b") + " " + @date.strftime("%d") + ", " + @date.strftime("%Y") 
    else
      @date.strftime("%d") + "-" + MONTHS_ES[@date.strftime("%b")] + "-" + @date.strftime("%Y") 
    end
  end

  def day
    @date.strftime("%d")
  end

  def month(locale = "es")
    if locale == "en"
      @date.strftime("%b")
    else
      MONTHS_ES[@date.strftime("%b")]
    end
  end

  def year
    @date.strftime("%Y") 
  end
  
  def partial_body
    @body[0..@body.size/4]
  end
  
  def reading_time
    human_time = ""
    wordcount = @body.split.size
    secs = wordcount/3
    mins = secs/60
    secs = secs%60
    if mins > 0
      human_time += "#{mins} mins."
    end
    if secs > 0
      human_time += " #{secs} secs."
    end
    if mins == 0 && secs == 0
      human_time += " #{secs} secs."
    end
    human_time
  end
  
end