#
# 状态模式（state_pattern）
#
# 在State内部实现了状态的转换
#

class State
  def handle(context)
    if context.state.class == self.class
      context.state = Nonestate.new
      handle(context)
    else
      context.state.handle(context)
    end
  end
end


class Nonestate < State
  def handle(context)
    puts 'in Nonestate'
    context.state = Astate.new
  end
end


class Astate < State
  def handle(context)
    puts 'in Astate'
    context.state = Bstate.new
  end
end


class Bstate < State
  def handle(context)
    puts 'in Bstate'
    context.state = Astate.new
  end
end


class Content
  attr_accessor :state

  def initialize
    @state = State.new
  end

  def change_state(state)
    @state = state
  end

  def request
    @state.handle(self)
  end
end

content = Content.new
content.request     #=> 'in Nonestate'
content.request     #=> 'in Astate'
content.request     #=> 'in Bstate'
