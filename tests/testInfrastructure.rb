
require "../main/context.rb"
require "test/unit"

class TestContext < Test::Unit::TestCase
  
  ###################################
  # The tests are automatically run #
  ###################################
  
  #Running
  def setup
    Context.default= nil
  end

  def teardown
    ## Nothing really
  end
  
  #TEST 0 : Protocol
  def testContextProtocol
    _context = Context.new
    assert(defined?Context, "The Context should exist")
    assert(Context.kind_of?(Class), "Context should be a class")
    assert(Context.method_defined?(:activate), "Context activation method should exist")
    assert(Context.method_defined?(:deactivate), "Context deactivation method should exist")
    assert(Context.method_defined?(:isActive), "Context activation state test method should exist")
  end
  
  #TEST 1 : Instantiation
  def testContextCreation
    _context = Context.new #Fresh instance    
    assert_instance_of(Context, _context, "Fresh instances should be Contexts indeed" )
    assert_instance_of(FalseClass || TrueClass, _context.isActive, "The context should be either active (true) or inactive (false)")
    assert(!_context.isActive, "A fresh context should be initially inactive")
  end
  
  #TEST 2 : Activation
  def testActivation
    _context = Context.new #Fresh instance
    assert(!_context.isActive, "Context must be inactive.")
    assert(_context.active == _context, "Activate function should return self")
    assert(_context.isActive, "Activation should leave the context in an active state")
    assert(_context.deactivate == _context, "Deactivate function should return self")
    assert(!_context.isActive, "Deactivation should leave the context in an inactive state")
  end
  
  def testRedundantActivation
    _context = Context.new
    assert(!_context.isActive, "Newly created contexts should be initially inactive")
    10.times do _context.active  end
    assert(_context.isActive, "The context must be active 10 times")
    9.times do _context.deactivate end
    assert(_context.isActive, "Context should stay active for fewer deactivations than activations")
  
    _context.deactivate
    assert(!_context.isActive, "Context should become inactive after a matching number of deactivations")
  end
  
  def testRedundantDeactivation
    _context = Context.new
    assert(!_context.isActive, "Newly created contexts should be initially inactive")
    3.times do _context.active end
    assert(_context.isActive)
    9.times do _context.deactivate end
    assert(!_context.isActive, "The context should be inactivate")
    
    _context.active
    assert(_context.isActive, "Deactivation does not accumulate once the context is already inactive")
  
    _context.deactivate
    assert(!_context.isActive, "Context should be inactive")
  end
  
  #TEST 3 : Naming
  def testAnonymousContextName
    _context = Context.new
    assert(Context.method_defined?(:name), "Context name method should exist so Contexts can have a name")
    assert(_context.name == nil, "Fresh contexts are not assigned a default name")
    assert(_context.printOn == "anonymous context", "Fresh contexts should be described as anonymous")
  end
  
  def testNamedContext
    _ctx = nil
    _ctx2 = nil
    assert(Context.method_defined?(:name), "Context should have a name: constructor")
    _ctx = Context.named("low battery")
    assert(_ctx.printOn == "low battery context", "The printed representation of the context should be consistent with the name")
    _ctx2 = Context.named("afternoon")
    assert(_ctx != _ctx2, "The #name: constructor shourd return a new context object upon each invocation")
  end
  
  #TEST 4 : Default context
  def testDefaultContext
    _currentCtx = Context.default
    assert(_currentCtx == Context.default, "The default context is persistent")
    assert(Context.default != nil, "The default context is never nil")
    assert(Context.default.isActive, "The default context should normally be active")
    assert_nothing_raised(RuntimeError) {Context.default= nil}
    assert(_currentCtx != Context.default, "The default context should be created anew after a reset")
  end
  
  def testDefaultContextName
    assert(Context.default.name == "default", "The name of the default context should be (non-surprisingly) 'default'")
    assert(Context.default.printOn == "default context", "The printed representation of the default context should be consistent with its name")
  end
  
  #TEST 5 : Life circle
  def testContextDisposal
    _previousDefault = Context.default
    assert(Context.default.isActive)
    assert_raise(RuntimeError) {Context.default.discard}
    
    Context.default.deactivate
    assert(!Context.default.isActive, "The default context should be inactive")
    assert_nothing_raised(RuntimeError){Context.default.discard}
    assert_nothing_raised(RuntimeError){self.testDefaultContext}
    assert(!(Context.default == _previousDefault), "Fresh default context should not be the default context just discarded")
  end
  
end