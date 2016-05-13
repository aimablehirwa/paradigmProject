require "../COP/context.rb"
require "../COP/phone.rb"
require "../COP/phoneCall.rb"


@quietContext = Context.named("quiet")
# "This adaptation definition is known to work from testAdaptationDefinition."
@quietContext.adaptClass(Phone, "advertise", Phone.advertiseQuietly)

context = Context.new 
context.name="jos"

phone = Phone.new
call = PhoneCall.new 
call.from = "Bob"
phone.receive(call) 
@quietContext.activate
puts Phone.advertise 
@quietContext.deactivate
puts Phone.advertise 

puts Phone.advertiseQuietly.call
