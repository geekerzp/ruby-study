class Encrypter
  def initialize(key)
    @key = key
  end

  def encrypt(reader, writer)
    key_index = 0
    until reader.eof?
      clear_char = reader.getc
      encryped_char = clear_char ^ @key[key_index]
      writer.putc(encryped_char)
      key_index = (key_index + 1) % @key.size
    end
  end
end

class StringIOAdapter
  def initialize(string)
    @string = string
    @position = 0
  end

  def getc
    if @position >= @string.length
      raise EOFError
    end

    ch = @string[@position]
    @position += 1
    ch
  end

  def eof?
    @position >= @string.length
  end
end

class Renderer
  def render(text_object)
    text = text_object.text
    size = text_object.size_inches
    color = text_object.color

    # render the text ...
  end
end

class TextObject
  attr_reader :text, :size_inches, :color

  def initialize(text, size_inches, color)
    @text = text
    @size_inches = size_inches
    @color = color
  end
end

class BritishTextObject
  attr_reader :string, :size_mm, :colour
  # ...
end

class BritishTextObjectAdapter
  def initialize(bto)
    @bto = bto
  end

  def text
    @bto.string
  end

  def size_inches
    @bto.size_mm / 25.4
  end

  def color
    @bto.colour
  end
end

#*******************************************************************************

# Make sure the original class is loaded

require 'british_text_object'

# Now add some methods to the original class

class BritishTextObject
  def color
    colour
  end

  def text
    string
  end

  def size_inches
    size_mm / 25.4
  end
end

#*******************************************************************************

bto = BritishTextObject.new('hello', 50.8, :blue)

class << bto
  def color
    colour
  end

  def text
    string
  end

  def size_inches
    size_mm / 25.4
  end
end

#*******************************************************************************
