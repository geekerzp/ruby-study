class Task
  attr_reader :name
  
  def initialize(name)
    @name = name
  end

  def get_time_required 
    0.0
  end
end

class AddDryIngredientsTask < Task
  def initialize
    super('Add dry ingredients')
  end

  def get_time_required 
    1.0
  end
end

class MixTask < Task
  def initialize
    super('Mix that batter up!')
  end

  def get_time_required 
    3.0
  end
end

class AddLiquidsTask < Task
  def initialize 
    super('Add liquds!')
  end
  
  def get_time_required 
    2.0
  end
end

class MakeBatterTask < Task
  def initialize 
    super('Make batter')
    @sub_tasks = []
    add_sub_task(AddDryIngredientsTask.new)
    add_sub_task(AddLiquidsTask.new)
    add_sub_task(MixTask.new)
  end
  
  def add_sub_task(task)
    @sub_tasks << task
  end
  
  def remove_sub_task(task)
    @sub_tasks.delete(task)
  end
  
  def get_time_required 
    @sub_tasks.inject(0) {|time, task| time += task }
  end
end

# -----------------------------------------------------------
class CompositeTask < Task
  def initialize(name)
    super(name)
    @sub_tasks = []
  end
  
  def [](index)
    @sub_tasks[index]
  end
  
  def []=(index, new_value)
    @sub_tasks[index] = new_value
  end
  
  def add_sub_task(task)
    @sub_tasks << task
  end
  
  aliases << add_sub_task
  
  def remove_sub_task(task)
    @sub_tasks.delete(task)
  end
  
  def get_time_required 
    @sub_tasks.inject(:+)
  end
end

class MakeBatterTask < CompositeTask
  def initialize 
    super('Make batter')
    @sub_tasks = []
    add_sub_task(AddDryIngredientsTask.new)
    add_sub_task(AddLiquidsTask.new)
    add_sub_task(MixTask.new)
  end
end

# ----------------------------------------------------------

class Task
  attr_accessor :name, :parent

  def initialize(name)
    @name = name
    @parent = nil
  end

  def get_time_required 
    0.0
  end
  
  def total_number_basic_tasks 
    1
  end
end

class CompositeTask <Task
  def initialize(name)
    super(name)
    @sub_tasks = []
  end
  
  def add_sub_task(task)
    @sub_tasks << task
    task.parent = self
  end

  def remove_sub_task(task)
    @sub_tasks.delete(task)
    task.parent = nil
  end
  
  def get_time_required
    @sub_tasks.inject(0) { |time, task| time =+ task.get_time_required }
  end
  
  def total_number_basic_tasks 
    @sub_tasks.inject(0) { |total, task| total =+ task.total_number_basic_tasks }
  end
end

