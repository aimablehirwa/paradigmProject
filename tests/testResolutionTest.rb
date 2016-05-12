require "../main/context.rb"
require "../main/phone.rb"
require "../main/phoneCall.rb"
require "../main/discreetPhone.rb"
require "../main/multicallPhone.rb"
require "../main/screeningPhone.rb"
require "test/unit"

class TestContext < Test::Unit::TestCase
  
  ###################################
  # The tests are automatically run #
  ###################################
  
  #TEST 0 : Protocol
  def testContextProtocol
    assert(Context.method_defined?(:activationAge), "Context age method should exist")
    assert_instance_of(Fixnum, Context.default.activationAge, "Context age should be a Numeric")
  end
  
  #TEST 1 : Activation 
  def testConflictingActivation
    @quietContext = Context.named("quiet")
    @offHookContext = Context.named("offhook")
    @quietContext.activate
    assert_nothing_raised(RuntimeError, "Off-hook context should not cause a conflict with previous adaptations") {@offHookContext.activate}
    @offHookContext.deactivate
    @quietContext.deactivate
  end

  #TEST 2 : Context age
  def testContextAge
    @quietContext = Context.named("quiet")
    @screeningContext = Context.named("screening")
    assert(Context.default.isActive, "The default context should normally be active")
    assert(!@quietContext.isActive, "quietContext must be inactive.")
    assert(!@screeningContext.isActive, "screeningContext must be inactive.")
    
    @screeningContext.activate
    assert(@screeningContext.activationAge < Context.default.activationAge, "Screening context has been activated more recently than default context")
    @quietContext.activate
    assert(@quietContext.activationAge < @screeningContext.activationAge, "Quiet context has been activated more recently than Screening context")
    assert(@screeningContext.activationAge < Context.default.activationAge, "Screening context is still more recently activated than default context")
    @quietContext.deactivate
    @screeningContext.deactivate
    
    @screeningContext.activate
    assert(@screeningContext.activationAge < @quietContext.activationAge, "The order between screening and quiet contexts should be inverted after activation of the former")
    @screeningContext.deactivate
  end
  
  #TEST 3 : Composition
  def testInterleavedActivation
       
    phone = Phone.new
    call = PhoneCall.new
    call.from = "Alice"
    phone.receive(call)
    
    assert(phone.class.advertise == "ringtone", "Call should be advertised with default ringtone")
    
    @quietContext.activate
    assert(phone.class.advertise == "vibrator", "Call advertisement should adapt to quiet context")
    
    @screeningContext.activate
    assert(phone.class.advertise == "vibrator", "Screening information should be overlaid over quiet context behaviour (vibrator)")
    
    #The activation spans of screeningContext and quietContext are overlapped
    @quietContext.deactivate
    assert(phone.class.advertise == "ringtone with screening", "Screening information should be overlaid over default context behaviour (ringtone)")
    @screeningContext.deactivate
    assert(phone.class.advertise == "ringtone", "Call advertisement should be reverted to the default")
  end
  
  def testNestedActivation
    
    @quietContext = Context.named("quiet")
    @screeningContext = Context.named("screening")
    # "This adaptation definition is known to work from testAdaptationDefinition."
    @quietContext.adaptClass(Phone, "advertise", DiscreetPhone.advertiseQuietly)
    
    phone = Phone.new
    call = PhoneCall.new
    call.from = "Alice"
    phone.receive(call)
    
    puts phone.class.advertise
    assert(phone.class.advertise == "ringtone", "Call should be advertised with default ringtone")
    
    @quietContext.activate
    puts phone.class.advertise
    assert(phone.class.advertise == "vibrator", "Call advertisement should adapt to quiet context")
    
    @screeningContext.activate
    puts phone.class.advertise
    assert(phone.class.advertise == "vibrator with screening", "Screening information should be overlaid over quiet context behaviour (vibrator)")
    
    #The activation span of screeningContext is completely nested within that of quietContext
    @screeningContext.deactivate
    assert(phone.class.advertise == "vibrator", "Call advertisement should adapt to quiet context")
    @quietContext.deactivate
    assert(phone.class.advertise == "ringtone", "Call advertisement should be reverted to the default") 
  end
  
  #Running
  def setUp
    @quietContext.adaptClass(Phone, "advertise", DiscreetPhone.advertiseQuietly)
    @offHookContext.adaptClass(Phone, "advertise", DiscreetPhone.advertiseQuietly)
  end
end