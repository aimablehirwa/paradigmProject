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
  
end
