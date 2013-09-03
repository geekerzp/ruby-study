#
# =================
# | regexp字面量  |
# =================
#
# 1.使用/.../生成正则表达式
# ~~~~~~~~~~~~~~~~~~~~~~~~~
#   /\\/
# 2.使用%r生成正则表达式
# ~~~~~~~~~~~~~~~~~~~~~~
#   %r[/(.*)]i
# 3.插入表达式
# ~~~~~~~~~~~~
#   prefix = ','
#   /#{prefix}\t/
# 4.o选项
# ~~~~~~~
#   o选项使正则表达式中插入表达式只在正则表达式第一次求值前被展开计算
[1,2].map {|x| /#{x}/}  # => [/1/, /2/]
[1,2].map {|x| /#{x}/o} # => [/1/, /1/]
#
# ------------------------------------------------------------------------------
#
# ====================
# |  regexp工厂方法  |
# ====================
#
# 1.Regexp.new
   Regexp.new("Ruby?")
# 2.Regexp.compile
   Regexp.compile(".", Regexp::MULTILINE, "u")   # /./mu
# 3.Regexp.escape
#   在把一个字符串传给Regexp的构造方法之前，可以对其转义。
pattern = "[a-z]+"
suffix = Regexp.escape("()")
r = Regexp.new(pattern + suffix)    # /[a-z]+\(\)/
# 4.Regexp.union
#   多个模式组合成一个，自动转义。
Regexp.union("()", "[]", "{}")    # => /\(\)\[\]\{\}/
#
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# ====================
# |  正则表达式句法  |
# ====================
#
# 字面量 literal characters
/ruby/
/￥/

# 字符族 character classes
/[Rr]uby/
/[aeiou]/
/[0-9]/
/[a-z]/
/[A-Z]/
/[a-zA-Z0-9]/
/[^aeiou]/
/[^0-9]/

# 特殊字符 special character 
/./
/./m 
/\d/
/\D/
/\s/
/\S/
/\w/
/\W/

# 重复 repetition
/ruby?/
/ruby*/
/ruby+/
/\d{3}/
/\d{3,}/
/\d{3,5}/

# 贪婪和懒惰 greedy
/<.*>/    # greedy repetition 贪婪匹配
/<.*?>/   # nongreedy repetition 非贪婪匹配

# 团体化 grouping 
/\D\d+/
/(\D\d)+/

# 后向引用 backreferences
/([Rr]uby&\1ails)/
/(['"])[^\1]*\1/    # single or double-quoted string
                    # \1 matches whatever the 1st group matched.
                    # \2 matches whatever the 2st group matched. 
# 命名后向引用 named group backreferences
/(?<first>\w)(?<second>\w)\k<second>\k<first>/
/(?'first'\w)(?'second'\w)\k'second'\k'first'/    # alternate syntax 

# 选择 alternatives
/ruby|rube/
/rub(y|le)/
/ruby(!+|\?)/

# 锚点 anchors
/^ruby/   # start of a string or line 
/ruby$/   # end of a string or line 
/\Aruby/  # start of a string
/ruby\Z/  # end of a string or before if a '\n'
/ruby\z/  # end of a string
/\bruby\b/
/\brub\B/
/Ruby(?=!)/ # match 'Ruby', if followed by an exclamation point
/Ruby(?!!)/ # match 'Ruby', if not...
/(?<=!)Ruby/  # match 'Ruby', if the header an exclamation point
/(?<!!)Ruby/  # match 'Ruby', if not 

# 特殊语法 special syntax with parentheses
/R(?#comment)/  # match "R". All the rest is a comment 
/R(?i)uby/      # case-insensitive while matching "uby"
/R(?i:uby)/     # same thing 
/rub(()?:y|le)/ # without backreferences
#
# 特殊匹配模式
# ~~~~~~~~~~~~
# (? onflags - offflags )     什么也不匹配，不过会打开onflags指定的标志，同时关闭offflags指定的标志。
#                             这两个字符串可以是i，m和x的任意组合。这种方式设置的标志在指定位置处
#                             立刻生效，在所在表达式结束时失效。
#
# (? onflags - offflags : x)  用给定的标志对当前子表达式匹配x。这是一个非捕获性的分组。
#
# (?#...)                     注释，括号内的所有文本被忽略。
#
# (?> re )                    独立于表达式中的其余部分对re进行匹配，而不管这个匹配是否会导致其余部分失效。
#                             通常用于优化特定复杂的表达式。
#                             括号不用于捕获匹配文本。
#
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# ==============
# |  模式匹配  |
# ==============
#
# MatchData对象
# ~~~~~~~~~~~~~
# This is a pattern with three subpatterns
pattern = /(Ruby|Perl)(\s+)(rocks|sucks)!/
text = "Ruby\trocks!"
pattern =~ text
data = Regexp.last_match    # 获得一个MatchData对象
data.size 
data[0]
data[1]
data[2]
data[3]
data[1,2]             # => ["Ruby","\t"]
data[1..3]            # => ["Ruby","\t","rocks"]
data.values_at(1,3)   # => ["Ruby","rocks"]: only selected indexes
data.captures         # => ["Ruby","\t","rocks"]: only subpatterns
Regexp.last_match(3)  # => "rocks": same as Regexp.last_match[3]

data.begin(0)
data.begin(2)
data.end(2)
data.offset(3)
# 如果分组使用有名捕获，MatchData可以像哈希表一样被使用
pattern = /(?<langRuby|Perl>) (?<ver>\d(\.\d)+) (?<review>rocks|sucks)!/
if (pattern =~ "Ruby 1.9.1 rocks!")
  $~[:lang]
  $~[:ver]
  $~[:review]
  $~.offset(:ver)
end 
pattern.names           # => ["lang","ver","review"]
pattern.named_captures  # => {"lang"=>[1], "ver"=>[2], "review"=>[3]}
#
# 获取MatchData对象
# ~~~~~~~~~~~~~~~~~
# if data = pattern.match(text)
# 返回一个MatchData
# pattern.match(text) {|data| handle_match(data)}
# 将产生的MatchData传入代码块中 
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# =============
# | 全局变量  |
# =============
#
# 变量             |English              |等价于
# -----------------+---------------------+---------------------------------------
#  $~              |$LAST_MATCH_INFO     |Regexp.last_match
# -----------------+---------------------+---------------------------------------
#  $&              |$MATCH               |Regexp.last_match[0]
# -----------------+---------------------+---------------------------------------
#  $`              |$PREMATCH            |Regexp.last_match.pre_match
# -----------------+---------------------+---------------------------------------
#  $'              |$POSTMATCH           |Regexp.last_match.post_match
# -----------------+---------------------+---------------------------------------
#  $1              |none                 |Regexp.last_match[1]
# -----------------+---------------------+---------------------------------------
#  $2, etc         |none                 |Regexp.last_match[2], etc 
# -----------------+---------------------+---------------------------------------
#  $+              |$LAST_PATEN_MATCH    |Regexp.last_match[-1]
# 
# 这些变量都是方法局部和线程局部的，
# 两个线程不会互相干扰，
# 方法内部不会影响方法调用者。
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# ========================
# |  字符串进行模式匹配  |
# ========================
#
# 1.[]
# ~~~~~~~~~~~~~~~~~~
"ruby123"[/\d+/]              # "123"
"ruby123"[/([a-z]+)(\d+)/,1]  # "ruby"
"ruby123"[/([a-z]+)(\d+)/,2]  # "123"

# 2.slice,slice!
# ~~~~~~~~~~~~~~~~~~
r = "ruby123"
r.slice!(/\d+/) # Returns "123", change r to "ruby"

# 3.split
# ~~~~~~~~~~~~~~~~~~
s = "one, two, three"
s.split             # ["one,","two,","three"]
s.split(", ")       # ["one","two","three"]
s.split(/\s*,\s*/)  # ["one","two","three"]

# 4.index 
# ~~~~~~~
text = "hello world"
pattern = /l/
first = text.index(pattern)     # => 2
n = Regexp.last_match.end(0)    # => 3
second = text.index(pattern,n)  # => 3
last = text.rindex(pattern)     # => 9
#
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# ================
# |  搜索和替换  |
# ================
phone = gets
phone.sub!(/#.*$/, "")
phone.gsub!(/\D/, "")

text.gsub(/\bruby\b/i, '<b>\0</b>')

re = /(?<quote>['"])(?<body>[^'"]*)\k<quote>/
puts "These are 'quotes'".gsub(re, '\k<body>')

text = "RUBY Java perl PyThOn"
lang = /ruby|java|perl|python/i
text.gsub!(lang) {|l| l.capitalize }

pattern = /(['"])([^\1]*)\1/
text.gsub!(pattern) do 
  if ($1 == '"')
    "'#$2'"
  else 
    "\"#$2\""
  end 
end 
#
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# ==========
# |  编码  |
# ==========
#
# Regexp.encoding方法指定编码:
# u->utf-8: s->sjis: e->euc-jp: n->none 
#
# 在正则表达式中可以显式使用\u指定utf-8编码，
# 如果不显式指定编码，则使用源程序编码，
# 不过如果正则表达式中所有字符都是ASCII编码，那么源程序编码是ASCII编码的超集，
# 也使用ASCII编码。
#
# 如果试图匹配的模式与文本编码不兼容，抛出一个异常。
#
# 如果Regexp对象的编码不是ASCII编码，fixed_encoding?返回true。
#
# ---------------------------------------------------------------------------------------------------------------------------------------------------



