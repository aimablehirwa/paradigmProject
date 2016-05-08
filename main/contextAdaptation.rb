
require_relative "phone"

class ContextAdaptation
  
  
  def initialize
    @adaptedClass = nil
    @adaptedImplementation = nil
    @adaptedSelector = nil
    @context = nil
  end
  
  def equals(aContextAdaptation)
    return ((self.context == aContextAdaptation.context) && 
      (self.adaptedClass == aContextAdaptation.adaptedClass) && 
      (self.adaptedSelector == aContextAdaptation.adaptedSelector)  && 
      (self.adaptedImplementation == aContextAdaptation.adaptedImplementation)) 
  end
  
  def adaptedClass
    return @adaptedClass
  end
  
  def adaptedClass=(aClass)
    @adaptedClass = aClass
  end
  
  def adaptedImplementation
    return @adaptedImplementation
  end
    
  def adaptedImplementation=(aCompiledMethod)
    @adaptedImplementation = aCompiledMethod
  end
  
  def adaptedSelector
    return @adaptedSelector
  end
  
  def adaptedSelector=(aSymbol)
    @adaptedSelector = aSymbol
  end
  
  def isClassAndSelector(aClass, aSelector)
    return (self.adaptedClass == aClass && self.adaptedSelector == aSelector)
  end
  
  def context
    return @context
  end
  
  def context=(aContext)
    @context = aContext
  end
  
  def deploy
   #"Install adapted method implementation.
   #(avoid #basicAddSelector:withMethod:, because it changes the class and selector of the method passed as argument."
    symbol = self.adaptedSelector.to_sym
    Phone.define_singleton_method(symbol, self.adaptedImplementation) 
  end
  
  def printOn
    puts "context >> #{context.printOn} : class >> #{self.adaptedClass} : selector >> #{self.adaptedSelector} : method >> #{self.adaptedImplementation}"
  end
  
  def sameTarget(aContextAdaptation)
    return self.isClassAndSelector(aContextAdaptation.adaptedClass, aContextAdaptation.adaptedSelector)
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