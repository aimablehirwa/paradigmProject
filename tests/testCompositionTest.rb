
require "../main/context.rb"
require "../main/phone.rb"
require "../main/phoneCall.rb"
require "../main/screeningPhone.rb"
require "test/unit"

class TestContext < Test::Unit::TestCase
  
  ###################################
  # The tests are automatically run #
  ###################################
  
  #TEST 1 : Composition
  def testInvalidProceed
    phone = Phone.new
    assert_raise(RuntimeError) {phone.class.proceed("advertise")}
    #Proceed cannot be used in methods that are not adaptations of other methods
  end

  def testNestedActivation
    @screeningContext = Context.named("screening")
    @screeningContext.adaptClass(Phone, "advertise", ScreeningPhone.advertiseWithScreening) 
    
    phone = Phone.new
    call = PhoneCall.new
    call.from= "Alice"
    phone.receive(call)
    
    assert(phone.class.advertise == "ringtone", "Call should be advertised with default ringtone")
  
    @screeningContext.activate
    assert(phone.class.advertise == "ringtone with screening", "Screening information should be overlaid over the default ringtone advertisement")
    
    @screeningContext.deactivate
    assert(phone.class.advertise == "ringtone", "Call advertisement should have been reverted to default")
  end
  
  #Running
  def setUp
    #"Adapt #advertise: for situations in which call screening is active."
  end

  def teardown
    # nothing to do   
  end

end

