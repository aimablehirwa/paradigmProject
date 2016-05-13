
require_relative "../Phone/phone"

#Import file
require_relative "modules/accessing.rb"
require_relative "modules/installation.rb"
require_relative "modules/printing.rb"
require_relative "modules/testing.rb"

#INCLUDE MODULES
include Accessing
include Installation
include Printing
include Testing

class ContextAdaptation
  
  ##################
  # Initialization #
  ##################
  
  def initialize
    @adaptedClass = nil
    @adaptedImplementation = nil
    @adaptedSelector = nil
    @context = nil
  end
  
  class << self
     
     def createAdaptation(aContext, aClass, aSelector, aMethod)
       adaptation = self.new
       adaptation.context= aContext
       adaptation.adaptedClass= aClass
       adaptation.adaptedSelector= aSelector
       adaptation.adaptedImplementation= aMethod
       return adaptation
     end
     
  end
  
end