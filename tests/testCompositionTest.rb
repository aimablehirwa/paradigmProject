
require "../main/context.rb"
require "../main/phone.rb"
require "../main/phoneCall.rb"
require "../main/screeningPhone.rb"
require "test/unit"

class TestContext < Test::Unit::TestCase
  
  def setUp
    #"Adapt #advertise: for situations in which call screening is active."
  end

  def teardown
    # nothing to do   
  end

  def testNestedActivation
    @screeningContext = Context.named("screening")
    @screeningContext.adaptationClass(Phone, "advertise", ScreeningPhone.advertiseWithScreening) 
    
    phone = Phone.new
    call = PhoneCall.new
    call.from= "Alice"
    phone.receive(call)
    #puts "#{phone.class.advertise.call}"
    assert(phone.class.advertise == "ringtone", "Call should be advertised with default ringtone")
  
    @screeningContext.active
    assert(phone.class.advertise == "ringtone with screening", "Screening information should be overlaid over the default ringtone advertisement")
    
    @screeningContext.deactivate
    assert(phone.class.advertise == "ringtone", "Call advertisement should have been reverted to default")
  end

end

