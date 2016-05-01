
require "./main/context.rb"
require "test/unit"

class TestContext < Test::Unit::TestCase
  
  def setup
    @context = Context.new
    Context.default= nil
  end

  def teardown
    ## Nothing really
  end

  def testActivation
    #TODO
  end

  def testAnonymousContextName
    #TODO
  end
  
  def testContextCreation
    #TODO
  end
  
  def testContextDisposal
    #TODO
  end
  
  def testContextProtocol
    #TODO
  end
  
  def testDefaultContext
    #TODO
  end
  
  def testDefaultContextName
    #TODO
  end
  
  def testNamedContext
    #TODO
  end
  
  def testRedundantActivation
    #TODO
  end
  
  def testRedundantDeactivation
    #TODO
  end

  
end