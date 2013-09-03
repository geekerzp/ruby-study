# ====================
# |  三种方法可见性  |
# ====================
# 
# 1.public
# ~~~~~~~~
# 能被外部访问
#
# 2.private
# ~~~~~~~~~
# 只能被这个类或其子类的self隐式的所调用，如果m是一个私有方法，
# 那么只能m这种方式调用它，而不能用o.m或self.m来调用
#
# 3.protected
# ~~~~~~~~~~~
# protected方法和private方法的相似之处在与它也只能在该类或子类的内部调用，
# 它与private方法的不同之处在于它可以被该类的实例显式调用，
# 而不仅仅是被self所隐式调用。
#
# 一个被类C所定义的保护方法，只有当对象o和p的类都是C的子类时，
# p中的方法才可以调用对象o上的该方法，而类C的用户则无法访问，
# 通常用于同一个类的不同对象间共享内部状态。
# ------------------------------------------------------------------------------
# 
# =================
# | 两种声明方法  |
# =================
#
# 1.
# ~~
class Point
  # public methods go here

  # The following methods are protected
  protected

  # protected methods go here

  # The following methods are private
  private

  # private methods go here
end
#
# 2.
# ~~
class Widget 
  def x                     # Accessor method for @x
    @x
  end
  protected :x              # Make it protected

  def utility_method        # Define a method 
    nil
  end
  private :utility_method   # And make it private
end
# ---------------------------------------------------------------------------------------------------------------------------------------------------
