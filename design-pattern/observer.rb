class Employee
  attr_reader :name
  attr_accessor :title, :salary
  
  def initialize(name, title, salary)
    @name = name
    @title = title
    @salary = salary
    @observers = []
  end
  
  def add_observer(observer)
    @observers << observer
  end
  
  def delete_observer(observer)
    @observer.delete(observer)
  end
  
  def salary=(new_salary)
    @salary = new_salary
    notify_observers
  end
  
  def notify_observers
    @observers.each { |observer| observer.update(self)  }
  end
end 

class Payroll
  def update(changed_employee)
    puts "Cut a new check for #{changed_employee.name}!"
    puts "His salary is now #{changed_employee.salary}!"
  end
end 

# --------------------------------------------------
class Subject
  def initialize
    @observers = []
  end
  
  def add_observer(observer)
    @observers << observer
  end
  
  def delete_observer(observer)
    @observers.delete(observer)
  end

  def notify_observers
    @observers.each do |observer|
      observer.update(self)
    end 
  end 
end

class Employee < Subject
  attr_reader :name, :address
  attr_accessor :salary

  def initialize(name, title, salary)
    super
    @name = name
    @title = title
    @salary = salary
  end
  
  def salary=(new_salary)
    @salary = new_salary
    notify_observers
  end
  
end

# --------------------------------------------------------

module Subject
  def initialize
    @observers = []
  end

  def add_observer(observer)
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer)
  end

  def notify_observers
    @observers.each do |observer|
      observer.update(self)
    end
  end
end

class Employee
  include Subject

  attr_reader :name, :address
  attr_accessor :salary
  
  def initialize(name, address, salary)
    super()
    @name = name
    @address = address
    @salary = salary
  end

  def salary=(new_salary)
    @salary = new_salary
    notify_observers
  end
end

# ---------------------------------------------------------

require 'observer'

class Employee
  include Observable

  attr_reader :name, :title
  attr_accessor :salary

  def initialize(name, title, salary)
    @name = name
    @title = title
    @salary = salary
  end

  def salary=(new_salary)
    @salary = new_salary
    changed
    notify_observers(self)
  end
end

# ----------------------------------------------------

module Subject
  def initialize
    @observers = []
  end
  
  def add_observer(&observer)
    @observers << observer
  end
  
  def delete_observer(observer)
    @observers.delete(observer)
  end
  
  def notify_observers 
    @observers.each do |observer|
      observer.call(self)
    end
  end
end

class Employee
  include Observable

  attr_reader :name, :title
  attr_accessor :salary

  def initialize(name, title, salary)
    super()
    @name = name
    @title = title
    @salary = salary
  end

  def salary=(new_salary)
    @salary = new_salary
    notify_observers
  end
end

fred = Employee.new('Fred', 'Crane Operator', 30000)

fred.add_observer do |changed_employee|
  puts "Cut a new check for #{changed_employee.name}!"
  puts "His salary is now #{changed_employee.salary}!"
end
