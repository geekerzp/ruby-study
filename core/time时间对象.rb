#
# ==========
# |  Time  |
# ==========
#
# Creating Time Objects 
Time.now    # Returns a time object that represents the current time 
Time.new    # A synonym for Time.now 

Time.local(2007, 7, 8)          # July 8, 2007 
Time.local(2007, 7, 8, 9, 10)   # July 8, 2007, 09:10am, local time 
Time.utc(2007, 7, 8, 9, 10)     # July 8, 2007, 09:10 UTC
Time.gm(2007, 7, 8, 9, 10, 11)  # July 8, 2007, 09:10:11 GMT(same as UTC)

# One microsecond before the new millennium before in London
# We'll use this Time object in many examples below.
t = Time.utc(2000, 12, 31, 23, 59, 59, 999999)

# Components of a Time 
t.year    # => 2000
t.month   # => 12: December
t.day     # => 31
t.wday    # => 0: day of week: 0 is Sunday 
t.yday    # => 366: day of year: 2000 was a leap year 
t.hour    # => 23: 24-hour clock 
t.min     # => 59 
t.sec     # => 59
t.usec    # => 999999: microseconds, not milliseconds 
t.zone    # => "UTC": timezone name 

# Get all Components in an array that holds 
# [sec, min, hour, day, month, year, wday, yday, isdst, zone]
# Note that we lose microseconds
values = t.to_a   # => [59, 59, 23, 31, 12, 2000, 0, 366, false, "UTC"]

values[5] += 1    # Increment the year 
Time.utc(*values) # => Mon Dec 31 23:59:59 UTC 2001 

# Timezones and daylight savings time 
t.zone            # => "UTC": return the timezone
t.utc?            # => true 
t.utc_offset      # => 0
t.localtime       
t.zone            # => +0800
t.utc?            # => false 
t.utc_offset      # => ...
t.gmtime      
t.getlocal
t.getutc
t.isdst           # => false: UTC does not have DST. 
t.getlocal.isdst  # => false: no daylight savings time in winter.

# Weekday predicates
t.sunday?         # => true 
t.monday?         # => false 

# Formatting Times and Dates 
t.to_s            
t.to_i, t.to_f    # => 获取时间戳timestamp
t.ctime

# strftime interpolates date and time components into a template string. 
# Local-independent formatting 
t.strftime("%Y-%m-%d %H:%M:%S") # => "2000-12-31 23:59:59" PHP: date 
t.strftime("%H:%M")             # => "23:59"
t.strftime("%I:%M %p")          # => "11:59 PM"

# Local-dependent formats 
t.strftime("%A, %B %d")         # => "Sunday, December 31"
t.strftime("%a, %b %d %y")      # => "Sun, Dec 31 00"
t.strftime("%x")                # => "12/31/00"
t.strftime("%X")                # => "23:59:59"
t.strftime("%c")                # => "Sun Dec 31 23:59:59 2000"

# Parsing Times and Dates
require 'parsedate'
include ParseDate
datestring = "2001-01-01"
values = parsedate(datestring)  # [2001,1,1,nil,nil,nil,nil,nil]
t = Time.local(*values)   
s = t.ctime
Time.local(*parsedate(s))==t    # true

# Time arithmetic
now = Time.now
past = now - 10
future = now + 10 
future - now 

# Time comparisons 
past <=> future
past < future
now >= future
now == now 

# Helper methods for working with time units other than seconds 
class Numeric
  # Convert time intervals to seconds
  def seconds; self; end 
  def milliseconds; seconds/1000.0; end 
  def minutes; seconds*60; end 
  def hours; minutes*60; end 
  def days; hours*24; end 
  def weeks; days*7; end 

  # Convert seconds to other intervals
  def to_seconds; self; end 
  def to_milliseconds; to_seconds*1000; end 
  def to_minutes; to_seconds/60; end 
  def to_hours; to_minutes/60; end 
  def to_days; to_hours/24; end 
  def to_weeks; to_days/7; end 
end 

expires = now + 10.days   # 10 days from now 
expires - now             # => 864000.0 seconds
(expires - now).to_hours  # => 240.0 hours

# Time represented internally as seconds since the epoch
t = Time.now.to_i 
Time.at(t)
t = Time.now.to_f
Time.at(0)
#
# ------------------------------------------------------------------------------
