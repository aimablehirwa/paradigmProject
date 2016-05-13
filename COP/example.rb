#import file
require "../COP/Context/context.rb"
require "../COP/Phone/phone.rb"
require "../COP/Phone/phoneCall.rb"

# name the contexts
@quietContext = Context.named("quiet") # Context named quiet
@screeningContext = Context.named("screening") # Context named screening
# adapt the class phone to contexts
@quietContext.adaptClass(Phone, "advertise", Phone.advertiseQuietly) # for the context quiet
@screeningContext.adaptClass(Phone, "advertise", Phone.advertiseWithScreening) # for the context screening


phone = Phone.new # new phone object
call = PhoneCall.new  # new phoneCall object 
call.from = "Alice" # assign call to Alice
phone.receive(call) # phone receive a call

puts phone.class.advertise # out : "ringtone" the default behaviour
@quietContext.activate # quietContext is actived
puts phone.class.advertise # out : "vibrator" the quiet behaviour
@quietContext.deactivate # quietContext is deactived
puts phone.class.advertise # out : "ringtone" back to default behaviour
@screeningContext.activate # screeningContext is actived
puts phone.class.advertise # out : "ringtone with screening" the screening behaviour




