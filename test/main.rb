################################################
# Run this test in 'test_require' directory.
#
# e.g.
#  > ../bin/mruby main.rb
################################################

# If you use Ruby 1.9, uncomment the following line.
# $:.unshift(".")

$counter = 0
$ok_counter = 0
$ko_counter = 0
def check(expected, value, msg="")
  if (expected == value)
    puts "OK:  #{msg}"
    $ok_counter += 1
  else
    puts "KO:* expected=#{expected}, value=#{value}: #{msg}"
    $ko_counter += 1
  end
  $counter += 1
end

################################################
# test for 'require'

##
# 1. Check sharing variables and methods.
shared = "main.rb"
$shared = "main.rb"
def test_method; return "main.rb"; end
class Test1Class
  def method; return "main.rb"; end
end
ret = require("test1.rb")
check("main.rb", shared, "Local variable should not be changed.")
check("test1.rb", $shared, "Global variable should be shared")
check("test1.rb", test_method, "Method should be overridden.")
check("test1.rb", Test1Class.new.method, "Class should be overridden. (method)")
check("test1.rb", Test1Class.new.method2, "Class should be overridden. (method2)")
check(true, ret, "'require' should return true if it succeeded to load.")

counter = $counter
ret = require("test1.rb")
check(counter, $counter, "require should load file once.")
check(false, ret, "'require' should return false if it failed to load.")

##
# 2. Check nested 'require'
$loaded = []
require("test2.rb")
check([ "test2.rb" ], $loaded, "Recursive loading check.")

$loaded = []
require("test3_1.rb")
check([ "test3_1.rb", "test3_2.rb" ], $loaded, "Nested and recursive loaded check.")

##
# 3. Check exception handling while loading.
begin
  $loaded = []
  exception = false
  require("test4.rb")
rescue => e
  exception = true
end
check([ "test4.rb" ], $loaded, "Exception while loading")
check(true, exception, "Exception should be handled.")

# If exception is raised while loading, 'require' can try to load again.
begin
  $loaded = []
  exception = false
  require("test4.rb")
rescue => e
  exception = true
end
check([ "test4.rb" ], $loaded, "Exception while loading again")
check(true, exception, "Exception should be handled again.")

##
# 4. If invalid file is passed, exception should be raised.
begin
  exception = false
  require("unknown.rb")
rescue Exception => e
  # Currently, LoadError is not defined, so ScriptError is raised instead of it.
  exception = (e.class == ScriptError)
end
check(true, exception, "ScriptError should be raised if invalid file is passed to 'require'.")

# ##
# # 5. If parse error occurs, exception should be raised.
# begin
#   exception = false
#   require("test5.rb")
# rescue Exception => e
#   exception = (e.class == ScriptError || e.class == SyntaxError)
# end
# check(true, exception, "ScriptError or SyntaxError should be raised if parse error occurs.")

################################################
# test for 'load'
shared = "main.rb"
$shared = "main.rb"
def test_method; return "main.rb"; end
class Test10Class
  def method; return "main.rb"; end
end
load("test10.rb")
check("main.rb", shared, "Local variable should not be changed.")
check("test10.rb", $shared, "Global variable should be shared")
check("test10.rb", test_method, "Method should be overridden.")
check("test10.rb", Test10Class.new.method, "Class should be overridden. (method)")
check("test10.rb", Test10Class.new.method2, "Class should be overridden. (method2)")

# Recursive loading
$num = 0
load("test11.rb")
check(100, $num, "Recursive loading check.")

################################################
# Results
puts ""
puts "Total:"
puts "  OK: #{$ok_counter}"
puts "  KO: #{$ko_counter}"

