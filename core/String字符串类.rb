#
# ======================
# |  字符串的替换规则  |
# ======================
#
# 1. 单引号字符串
# ~~~~~~~~~~~~~~~
# 1.在单引号字符串中，两个连续的反斜线会被一个反斜线替换。
# 2.后面跟有一个单引号的反斜线会被替换成一个单引号。
#
print 'escape using "\\"'   # => escape using "\"
print 'That\'s right'       # => That's right

# 2. 双引号字符串
# ~~~~~~~~~~~~~~~
# 支持转移序列，
# 字符串内插。
#
print "This is good\n"              # => This is good\n
print "#{'Ho! '*3}Merry Christmas!" # => Ho! Ho! Ho! Merry Christmas
# ------------------------------------------------------------------------------
#
# ==================
# |  字符串字面量  |
# ==================
#
# 1. %q
# ~~~~~
# 相当于单引号
#
%q{general single-quoted string}

# 2. %Q
# ~~~~~
# 相当于双引号
#
%Q{general double-quoted string}

# 3. here document
# ~~~~~~~~~~~~~~~~
# 1.不包括终结符开始和结束的两行
#
string = <<END_OF_STRING
  The body of the string 
  is the input lines up to 
  one ending with the same 
  text that followed the '<<'
END_OF_STRING

# 2.使用'-'可以缩进编排终结符
#
print <<-STRING1, <<-STRING2
  Concat
  STRING1
    enate
    STRING2
#-------------------------------------------------------------------------------
#
# =====================
# | 字符串的基本操作  |
# =====================
#
# 基本操作
# ~~~~~~~~
s = "hello"
s.concat(" world")
s.insert(5, " world")
s.slice(0,5)
s.slice!(5,6)
s.eql?("hello world")
#
# 获取长度
# ~~~~~~~~
s.length 
s.size 
s.bytesize
s.empty?
"".empty?
#
# 查找和替换文本
# ~~~~~~~~~~~~~~
s = "hello"
s.index("l")
s.index(?l)   # ?l代表字符字面量
s.index(/l+/)
s.index('l', 3)
s.index('ruby')
s.rindex('l')
s.rindex('l', 2)

s.start_with? "hell"
s.end_with? "bells"

s.include? "ll"
s.include? ?H

"this is it".split
"hello".split('l')
"1, 2 ,3".split(/\s*,\s*/)
# 字符串中查找特定串
"banana".partition("an")
"banana".rpartition("an")
"a123b".partition(/\d+/)

s.sub("l","L")
s.gsub("l","L")
s.sub!(/(.)(.)/, '\2\1')
s.sub!(/(.)(.)/, "\\2\\1")

"hello world".gsub(/\b./) {|match| match.upcase}
#
# 大小写转换
# ~~~~~~~~~~
s = "world"
s.upcase 
s.upcase!
s.downcase
s.downcase!
s.capitalize 
s.capitalize!
s.swapcase 

"world".casecmp("WORLD")
"a".casecmp("B")
#
# 删除空白
# ~~~~~~~~
s = "hello\r\n"
s.chomp!
s.chomp
s.chomp!
s.chomp("o")
$/ = ";"
"hello".chomp

s = "hello\n"
s.chop!
s.chop
"".chop
"".chop!

s = "\t hello \n"
s.strip   # PHP: trim
s.lstrip  # PHP: ltrim
s.rstrip  # PHP: rtrim

s = "x"
s.ljust(3)        # PHP: str_pad
s.rjust(3)
s.center(3)
s.center(5, '-')
s.center(7, '-=')

s = "A\nB"
s.each_byte {|b| print b," " }
s.each_line {|l| print l }
s.each_char {|c| print c," " }    # works for multibyte characters

0.upto(s.length-1) {|n| print s[n]," " }    # for multibyte characters

s.bytes.to_a 
s.lines.to_a
s.chars.to_a
#
# 字符串解析数字
# ~~~~~~~~~~~~~~
"10".to_i
"10".to_i(2)
"10x".to_i
"ten".to_i
" 10".to_i
"10".oct
"10".hex
"0xff".hex
" 1.1 dozen".to_f
"6.02e23".to_f
#
# 符号化
# ~~~~~~
"one".to_sym
"two".intern
# 
# 其他的方法
# ~~~~~~~~~~
"a".succ
"aaz".next
"a".upto("e") {|c| print c }

"hello".reverse
"hello\n".dump    # PHP: addslashes
"hello\n".inspect

"hello".tr("aeiou", "AEIOU")
"hello".tr("aeiou", " ")
"hello".tr_s("aeiou", " ")

"hello".sum
"hello".sum(8)
"hello".crypt("zp")

"hello".count('aeiou')    # PHP: count 
"hello".delete('aeiou')
"hello".squeeze("a-z")
"hello".count('a-z', '^aeiou')
"hello".delete('a-z', '^aeiou')
#
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# ===============
# | 格式化文本  |
# ===============
n, animal = 2, "mice"
"#{n+1} blind #{animal}"

printf('%d blind %s', n+1, animal)    # PHP: printf
sprintf('%d blind %s', n+1, animal)   # PHP: sprintf
'%d blind %s' % [n+1, animal]

'%d' % 10
'%x' % 10
'%x' % 10 
'%o' % 10

'%f' % 1234.567
'%e' % 1234.567
'%E' % 1234.567
'%g' % 1234.567
'%g' % 1.23456E12

'%5s' % '<<<'
'%-5s' % '>>>'
'%5d' % 123 
'%05d' % 123 

'%.2f' % 123.456
'%.2e' % 123.456 
'%.6e' % 123.456 
'%.4g' % 123.456 

'%6.4g' % 123.456
'%3s' % 'ruby'
'%3.3s' % 'ruby'

args = ['Syntax Error', 'test.rb', 20]
"%s: in '%s' line %d" % args
"%2$s:%3$d: %1$s" % args 
#
# ---------------------------------------------------------------------------------------------------------------------------------------------------
#
# ======================
# |  序列化和反序列化  |
# ======================
#
# 使用Array.pack,String.unpack
a = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
b = a.pack('i10') 
c = b.unpack('i*')
c == a

m = 'hello world'
data = [m.size, m]
template = 'Sa*'
b = data.pack(template)
b.unpack(template)










