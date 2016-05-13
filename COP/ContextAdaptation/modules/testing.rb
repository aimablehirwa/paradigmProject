module Testing
  ###########
  # Testing #
  ###########
  
  def adaptsClass(aClass, aSymbol)
    return (self.adaptedClass == aClass) && (self.adaptedSelector == aSymbol) 
  end
  
  def sameTarget(aContextAdaptation)
    return self.isClassAndSelector(aContextAdaptation.adaptedClass, aContextAdaptation.adaptedSelector)
  end
  
  def equals(aContextAdaptation)
    return ((self.context == aContextAdaptation.context) && 
      (self.adaptedClass == aContextAdaptation.adaptedClass) && 
      (self.adaptedSelector == aContextAdaptation.adaptedSelector)  && 
      (self.adaptedImplementation == aContextAdaptation.adaptedImplementation)) 
  end
end