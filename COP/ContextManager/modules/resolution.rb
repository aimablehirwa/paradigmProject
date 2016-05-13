module Resolution
  ##############
  # Resolution #
  ##############
  
  def ageResolutionPolicy()
    return self.contextActivationAge(adaptation1.context) < self.contextActivationAge(adaptation2.context)
  end 
  
  def defaultResolutionPolicy()
    return self.singleAdaptationResolutionPolicy
  end
  
  def findNextMethodForClass(aClass, aSymbol, aMethod)
    applicableMethods = self.adaptationChainForClass(aClass, aSymbol).initialize_clone.keep_if{|adaptation| adaptation.adaptedImplementation}
    if(applicableMethods.empty)
      raise "No applicable methods remain for " + aClass.to_s + ">>" + aSymbol.to_s
    end
    if self.applicableMethods.after?(aMethod) == nil
      raise "The given method is not part of the active chain for " + aClass.to_s + ">>" + aSymbol.to_s
    else 
      return self.applicableMethods.after(aMethod)
    end
  end
  
  def noResolutionPolicy()
    adaptation1 = ContextAdaptation.new
    adaptation2 = ContextAdaptation.new
    return raise "Behaviour adaptations are disallowed by policy"
  end
  
  #to check
  def singleAdaptationResolutionPolicy()
    adaptation1 = ContextAdaptation.new
    adaptation2 = ContextAdaptation.new
    adaptation1.context = Context.default
    
    if(adaptation1.context == Context.default)
      return false
    end
    if (adaptation2.context == Context.default)
      return true
    else 
      myClass = adaptation1.adaptedClass
      selector = adaptedSelector
      return raise "Conflicting adaptations for " + myClass.to_s + ">>" + selector.to_s
    end     
  end 
end