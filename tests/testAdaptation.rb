
require "../main/context.rb"
require "../main/phone.rb"
require "../main/phoneCall.rb"
require "../main/discreetPhone.rb"
require "../main/multicallPhone.rb"
require "test/unit"

class TestContext < Test::Unit::TestCase
  
  def setup
    #super.setup
    #Context.default.deactivate
    #Context.default.discard

    @quietContext = Context.named("quiet")
    @offHookContext = Context.named("offhook")
  end

  def teardown
    #@quietContext.deactivate
    #@quietContext.discard
    #@offHookContext.deactivate
    #@offHookContext.discard
    
    #"Throw away default context, to clean everything up."
    #Context.default.deactivate
    #Context.default.discard

    #super.tearDown
   
  end
  
  def testAdaptationAPI
    #TODO
  end
  
  def testAdaptationDefinition
    assert_nothing_raised(RuntimeError) {@quietContext.adaptationClass(Phone, "advertise", DiscreetPhone.advertiseQuietly)}
  end
  
  def testConflictingActivation
    #"This adaptation is known to work from previous tests."
    @quietContext.adaptationClass(Phone, "advertise", DiscreetPhone.advertiseQuietly)
    assert_nothing_raised(RuntimeError){@offHookContext.adaptationClass(Phone, "advertise", MulticallPhone.advertiseWaitingCall)}

    assert(!@quietContext.isActive, "In normal conditions, the quiet context should be inactive")
    assert_nothing_raised(RuntimeError) {@quietContext.active} 
    # description: 'It should be OK to activate the quiet context';
    assert(@quietContext.isActive,"The context activation should have taken place")
    assert(!@offHookContext.isActive, "In normal conditions, the off-hook context should be inactive")
    assert_raise(RuntimeError) {@offHookContext.active} 
    # description: 'Off-hook context should conflict with currently active quiet context';
    assert(!@offHookContext.isActive, "Off-hook should not be mistakenly activated after error")
    assert_nothing_raised(RuntimeError) {@quietContext.deactivate} 
    # description: 'It should be OK to deactivate the quiet context'.
    
  end
  
  def testConflictingAdaptation
    assert_nothing_raised(RuntimeError){@quietContext.adaptationClass(Phone, "advertise", DiscreetPhone.advertiseQuietly)} 
    #  description: 'Call advertisement behaviour should be adaptable to quiet environments';
    assert_nothing_raised(RuntimeError) {@quietContext.adaptationClass(Phone, "advertise", DiscreetPhone.advertiseDiscreteBeep)}
    #  description: 'A same context cannot have two different adaptations of the same method'.
  end
  
  def testInvalidAdaptation
    assert_raise(RuntimeError) {@quietContext.adaptationClass(Phone, "phonyAdvertise", DiscreetPhone.advertiseQuietly).active}
    #  description: 'Adaptation of inexsistent methods should be forbidden'
  end
  
  def testOverridingAdaptation
    # "This adaptation definition is known to work from testAdaptationDefinition."
    @quietContext.adaptationClass(Phone, "advertise", DiscreetPhone.advertiseQuietly)
    
    # "The following tests plain behaviour adaptation to context.
    # The adaptation completely overrides the original behaviour."
    phone = Phone.new
    call = PhoneCall.new 
    call.from= "Bob"
    phone.receive(call)
    assert(phone.class.advertise == "ringtone", "A phone should play a ringtone by default")
    
    @quietContext.active
    assert(phone.class.advertise == "vibrator", "The vibration behavior for quiet environments should be expressed")
    
    @quietContext.deactivate
    assert(phone.class.advertise == "ringtone", "The default behaviour should be restored once the quiet context is deactivated")
    
  end
  
end