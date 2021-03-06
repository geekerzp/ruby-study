#
# ==========
# |  注解  |
# ==========
#
# 注解应该直接写在相关代码那行之前。
# 注解关键字后面，跟着一个冒号及空格，接着是描述问题的文字。
# 如果需要用多行来描述问题，后续行要放在 # 号后面并缩排两个空格。

def bar
  # FIXME: 这在 v3.2.1 版本之后会异常崩溃，或许与
  #   BarBazUtil 的版本更新有关
  baz(:quux)
end 

# 在问题是显而易见的情况下，任何的文档会是多余的，注解应放在有问题的那行的最后，
# 并且不需更多说明。这个用法应该是例外而不是规则。

def bar
  sleep 100 # OPTIMIZE
end 

# 使用 TODO 标记以后应加入的特征与功能。
# 使用 FIXME 标记需要修复的代码。
# 使用 OPTIMIZE 标记可能影响性能的缓慢或效率低下的代码。
# 使用 HACK 标记代码异味，即那些应该被重构的可疑编码习惯。
# 使用 REVIEW 标记需要确认其编码意图是否正确的代码。举例来说： REVIEW: 我们确定用户现在是这么做的吗？
# 如果你觉得恰当的话，可以使用其他定制的注解关键字，但别忘记录在项目的 README 或类似文档中。

# ------------------------------------------------------------------------------
#
# ==========
# |  注释  |
# ==========
#
# 规则只有一条：如果需要注释，那么就应该被重构！
