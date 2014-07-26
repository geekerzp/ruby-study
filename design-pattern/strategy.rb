class Formatter
  def output_report(title, text)
    raise 'Abstract method called'
  end 
end 

class HTMLFormatter < Formatter
  def output_report(title, text)
    puts '<html>'
    puts '  <head>'
    puts "    <title>#{title}</title>"
    puts '  </head>'
    puts '  <body>'
    text.each do |line|
      puts "    <p>#{line}</p>"
    end 
    puts '  </body>'
    puts '</html>'
  end  
end

class PlainTextFormatter < Formatter
  def output_report(title, text)
    puts "***** #{title} *****"
    text.each do |line|
      puts line
    end 
  end 
end

class Report
  attr_reader :title, :text
  attr_accessor :formatter
  
  def initialize(formatter)
    @title = 'Monthly Report'
    @text = [ 'Things are going', 'really, really well.' ]
    @formatter = formatter
  end 
  
  def output_report
    @formatter.output_report(@title, @text)
  end
end 

# -------------------------------------------------------------------------------

class Report
  attr_reader :title, :text
  attr_accessor :formatter

  def initialize(formatter)
    @title = 'Monthly Report'
    @text = [ 'Things are going', 'really, really well.' ]
    @formatter = formatter
  end
  
  def formatter
    @formatter.output_report(self)
  end
end

class Formatter
  def output_report(title, text)
    raise 'Abstract method called'
  end 
end 

class HTMLFormatter < Formatter
  def output_report(context)
    puts '<html>'
    puts '  <head>'
    puts "    <title>#{context.title}</title>"
    puts '  </head>'
    puts '  <body>'
    context.each do |line|
      puts "    <p>#{line}</p>"
    end 
    puts '  </body>'
    puts '</html>'
  end  
end

# -----------------------------------------------------------------------------

class HTMLFormatter
  def output_report(context)
    puts '<html>'
    puts '  <head>'
    puts "    <title>#{context.title}</title>"
    puts '  </head>'
    puts '  <body>'
    context.each do |line|
      puts "    <p>#{line}</p>"
    end 
    puts '  </body>'
    puts '</html>'
  end  
end

class PlainTextFormatter < Formatter
  def output_report(context)
    puts "***** #{title} *****"
    context.each do |line|
      puts line
    end 
  end 
end

class Report
  attr_reader :title, :text
  attr_accessor :formatter
  
  def initialize(formatter)
    @title = 'Monthly Report'
    @text = [ 'Things are going', 'really, really well.' ]
    @formatter = formatter
  end 
  
  def output_report
    @formatter.output_report(self)
  end
end 

# --------------------------------------------------------------------------

class Report
  attr_reader :title, :text
  
  def initialize(&formatter)
    @title = 'Monthly Report'
    @text = [ 'Things are going', 'really, really well.' ]
    @formatter = formatter
  end 
  
  def output_report
    @formatter.call(self)
  end
end 

report = Report.new do |context|
  puts "***** #{context.title} *****"
  context.text.each { |line| puts line }
end 

# --------------------------------------------------------------------------
