
check("test1.rb", __FILE__, "Check __FILE__. (This test fails on CRuby.)")
check("main.rb", $shared, "Global variable should be shared.")
check("main.rb", test_method, "Method should be shared.")
check("main.rb", Test1Class.new.method, "Class should be shared.")


shared = "test1.rb"
$shared = "test1.rb"

def test_method
  return "test1.rb"
end

class Test1Class
  def method
    return "test1.rb"
  end

  def method2
    return "test1.rb"
  end
end

