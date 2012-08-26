
check("test10.rb", __FILE__, "Check __FILE__. (This test fails on CRuby.)")
check("main.rb", $shared, "Global variable should be shared.")
check("main.rb", test_method, "Method should be shared.")
check("main.rb", Test10Class.new.method, "Class should be shared.")


shared = "test10.rb"
$shared = "test10.rb"

def test_method
  return "test10.rb"
end

class Test10Class
  def method
    return "test10.rb"
  end

  def method2
    return "test10.rb"
  end
end

