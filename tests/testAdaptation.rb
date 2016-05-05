
require "../main/context.rb"
require "test/unit"

class TestContext < Test::Unit::TestCase
  
  def setup
    super.setup
    Context.default.deactivate
    Context.default.discard

    quietContext = Context.named("quiet")
    offHookContext = Context.named("off hook")
  end

  def teardown
    quietContext.deactivate
    quietContext.discard
    offHookContext.deactivate
    offHookCOntext.discard
    
    #"Throw away default context, to clean everything up."
    Context.default.deactivate
    COntext.default.discard

   super.tearDown
   
  end
  
  def testAdaptationAPI
    #TODO
  end
  
  def testAdaptationDefinition
    assert_raise(RuntimeError) {quietContext.adaptationClass(Phone, "advertise", "advertiseQuietly")}
  end
  
  def testConflictingActivation
    #"This adaptation is known to work from previous tests."
    quietContext.adaptationClass(Phone,"advertise","advertiseQuietly")
    assert_nothing_raised(RuntimeError){quietContext.adaptationClass(Phone, "advertise", "advertiseQuietly")}

    assert(!quietContext.isActive,"In normal conditions, the quiet context should be inactive")
    assert_nothing_raised(RuntimeError) {quietContext.active} 

    assert(quietContext.isActive,"The context activation should have taken place")
    assert(!offHookContext.isActive, "In normal conditions, the off-hook context should be inactive")
    assert_raise(RuntimeError) {offHookContext.active} 
    # description: 'Off-hook context should conflict with currently active quiet context';
    assert(!offHookContext.isActive, "Off-hook should not be mistakenly activated after error")
    assert_nothing_raised(RuntimeError) {quietContext.deactivate} 
    # description: 'It should be OK to deactivate the quiet context'.
    
  end
  
  def testConflictingAdaptation
    assert_nothing_raised(RuntimeError){quietContext.adaptationClass(Phone, "advertise", "advertiseQuietly")} 
    #  description: 'Call advertisement behaviour should be adaptable to quiet environments';
    assert_raise(RuntimeError) {quietContext.adaptationClass(Phone, "advertise", "advertiseDiscreteBeep")}
    #  description: 'A same context cannot have two different adaptations of the same method'.
  end
  
  def testInvalidAdaption
    assert_raise(RuntimeError) {quietContext.adaptationClass(Phone, "phonyAdvertise:", "advertiseQuietly").active}
    #  description: 'Adaptation of inexsistent methods should be forbidden'
  end
  
  def testOverridingAdaptation
    
  end
  
end