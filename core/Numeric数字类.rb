#
# =============
# |  Numeric  |
# =============
#
#                              +---------+
#                              | Numeric |
#                              +---------+
#                                   |
#          ----------------------------------------------------------
#          |              |         |                |              |
#     +---------+     +-------+ +---------+   +------------+   +----------+
#     | Integer |     | Float | | Complex |   | BigDecimal |   | Rational |
#     +---------+     +-------+ +---------+   +------------+   +----------+
#          |
#     -----------
#     |         |
# +--------+ +--------+
# | Fixnum | | Bignum |
# +--------+ +--------+
# ------------------------------------------------------------------------------
#
# 1. 常量(Constants)
# ~~~~~~~~~~~~~~~~~~
Float::MAX
Float::MIN
Float::EPSILONG

# 2. 通用判断方法(General Predicates)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
0.zero?       # => true
1.0.zero?     # => false
0.0.nonzero?  # => nil
1.nonzero?    # => 1
1.integer?    # => true 
1.0.integer?  # => false 
1.scalar?     # => false
1.0.scalar?   # => false
Complex(1,2).scalar?  # => true

# 3. 整数判断方法(Integer Predicates)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
0.even?   # => true 
0.odd?    # => false

# 4. 浮点数判断方法(Float Predicates)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ZERO, INF, NAN = 0.0, 1.0/0.0, 0.0/0.0 

ZERO.finite?  # => true 
INF.finite?   # => false 
NAN.finite?   # => false 

ZERO.infinite?  # => nil 
INF.infinite?   # => 1
-INF.infinite?  # => -1
NAN.infinite?   # => true 

ZERO.nan?   # => false 
INF.nan?    # => false 
NAN.nan?    # => true

# 5. 舍入(Rounding methods)
# ~~~~~~~~~~~~~~~~~~~~~~~~~
1.1.ceil    # => 2.0
-1.1.ceil   # => -1.0
1.9.floor   # => 1.0
-1.9.floor  # => -2
1.1.round   # => 1
0.5.round   # => 1
-0.5.round  # => -1
1.1.truncate  # => 1
-1.1.to_i     # => -1

# 6. 绝对值(Absolute value and sign)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-2.0.abs
-2.0<=>0.0  # 常用来判断正负

# 7. 迭代器(iterator)
# ~~~~~~~~~~~~~~~~~~~
3.times
1.upto(5)
99.downto(95)
50.step(80, 5)
# ------------------------------------------------------------------------------
#
# ================
# |  BigDecimal  |
# ================
#
require 'bigdecimal'      # Load standard library
dime = BigDecimal("0.1")  # Pass a string to constructor, not a Float
4*dime - 3*dime == dime   # true with BigDecimal, but false if we use Float

# Compute monthly interest payments on a mortgage with BigDecimal.
# Use "Banker's Rounding" mode, and limit computations to 20 digits.
BigDecimal.mode(BigDecimal::ROUND_MODE, BigDecimal::ROUND_HALF_EVEN)
BigDecimal.limit(20)
principal = BigDecimal("200000")  # Always pass strings to constructor
apr = BigDecimal("6.5")           # Annual percentage rate interest 
years = 30                        # Term of mortgage in years 
payments = years*12               # 12 monthly payments in a year 
interest = apr/100/12             # Convert APR to monthly fraction
x = (interest+1)**payments        # Note exponentiation with BigDecimal
monthly = (principal * interest * x)/(x-1)  # Compute monthly payment 
monthly = monthly.round(2)        # Round to two deciaml places 
monthly = monthly.to_s("f")       # Convert to human-readable string 
#
# ------------------------------------------------------------------------------
#
# =================
# |  Complex 复数 |
# =================
#
require 'complex'
c = Complex(0.5,-0.2)
z = Complex(0.0,0.0)
10.times { z = z*z + c }    # Iteration for computing Julia set fractals
magnitude = z.abs           # Magnitude of a complex number 
x = Math.sin(z)             
Math.sqrt(-1.0).to_s        # => "1.0i": square root of -1
Math.sqrt(-1.0)==Complex::I # => true 
#
# ------------------------------------------------------------------------------
#
# ===================
# |  Rational 实数  |
# ===================
#
# 通常用来表示和计算分数
# 和mathn库协同工作，重新定义了整数除法，用于创建实数
#
require 'rational'
penny = Rational(1,100) # => 1/100 
require 'mathn'
nickel = 5/100 
dime = 10/100
quarter = 1/4
change = 2*quarter + 3*penny  # => 53/100
(1/2 * 1/3).to_s              # => 1/6
#
# ------------------------------------------------------------------------------
#
# =================
# |  Matrix 矩阵  |
# =================
#
# 使用矩阵实现放缩和旋转变换
require 'matrix'

# Represent the point(1,1) as the vector [1,1]
unit = Vector[1,1]

# The identity transformation matrix
identity = Matrix.identity(2)   # 2x2 matrix
identity*unit == unit           # true: no transformation

# This matrix scales a point by sx, sy
sx,sy = 2.0,3.0
scale = Matrix[[sx,0],[0,sy]]
scale*unit        # => [2.0, 3.0]: scaled point 

# This matrix rotates counterclockwise around the origin 
theta = Math::PI/2  # 90 degrees 
rotate = Matrix[[Math.cos(theta), -Math.sin(theta)],
                [Math.sin(theta), Math.cos(theta)]]
rotate*unit       # => [-1.0, 1.0]: 90 degree rotation 

# Two transformations in one 
scale * (rotate*unit) # => [-2.0, 3.0]
#
# ------------------------------------------------------------------------------
#
# ============
# |  随机数  |
# ============
#
# 使用Kernel#rand产生伪随机数
rand      # => 0.96...
rand(100) # => 81
# 使用Kernel#srand设置随机数种子
srand(0)
[rand(100),rand(100)] # => [44,47]
srand(0)
[rand(100),rand(100)] # => [44,47]
#
# ------------------------------------------------------------------------------





