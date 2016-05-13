require "../COP/Context/context.rb"
require "../COP/phone.rb"
require "../COP/phoneCall.rb"


@screeningContext = Context.named("screening")
#adaptedMethod = Phone.send("advertise".to_sym)
@screeningContext.adaptClass(Phone, "advertise", Phone.advertiseWithScreening)

phone = Phone.new
call = PhoneCall.new 
call.from = "Alice"

puts phone.class.advertise
@screeningContext.activate
puts phone.class.advertise
