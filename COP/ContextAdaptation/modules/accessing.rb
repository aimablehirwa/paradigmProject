module Accessing
  #############
  # Accessing #
  #############
  
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
end