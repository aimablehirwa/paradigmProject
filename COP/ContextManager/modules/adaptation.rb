module Adaptation
  ##############
  # Adaptation #
  ##############
  
  def activateAdaptation(aContextAdaptation)
    #self.activeAdaptations.add(aContextAdaptation)
    #self.deployBestAdaptationForClass(aContextAdaptation.adaptedClass, aContextAdaptation.adaptedSelector)
    
    #adapt = false
    #self.activeAdaptations.each do |adaptation| 
    #  adapt = (adaptation.sameTarget(aContextAdaptation) && adaptation.context != Context.default)
    #end
    
    #throw :cannotActiveAdaptation 
    #if adapt == true
    #  raise "Conflicting adaptation for #{aContextAdaptation.adaptedClass.name} >> #{aContextAdaptation.adaptedSelector}"
    #end
    self.activeAdaptations.add(aContextAdaptation)
    ContextManager.singletonActiveAdaptations.add(aContextAdaptation)
    deployBestAdaptationForClass(aContextAdaptation.adaptedClass, aContextAdaptation.adaptedSelector)
    #aContextAdaptation.deploy
    #self.deployBestAdaptationForClass(aContextAdaptation.adaptedClass, aContextAdaptation.adaptedSelector)
  end
  
  def adaptationChainForClass(aClass, aSymbol)
    relevantAdaptations = self.activeAdaptations.clone.keep_if{|adaptation|(adaptation.adaptedClass.name == aClass.name) && (adaptation.adaptedSelector.to_s == aSymbol.to_s)}
    
    #relevantAdaptations = self.activeAdaptations.clone.keep_if{|adaptation| adaptation.adaptsClass(aClass, aSymbol)}
    if(relevantAdaptations == [])
      raise "No adaptations found for #{aClass} >> #{aSymbol}"
    end 
    
    a = relevantAdaptations.sort {|adaptation1, adaptation2| self.ageResolutionPolicy.call(adaptation1, adaptation2)} 
    return a
  end
  
  def deactivateAdaptation(aContextAdaptation)
    if self.activeAdaptations.delete?(aContextAdaptation) == nil
      raise "Attempt to deactivate unmanaged adaptation."
    end
    ContextManager.singletonActiveAdaptations.delete?(aContextAdaptation)
    #defaultAdaptation = nil
    #Context.default.adaptations.each do |adaptation| 
    #  if adaptation.isClassAndSelector(aContextAdaptation.adaptedClass, aContextAdaptation.adaptedSelector)
    #    defaultAdaptation = adaptation
    #  end
    #end

    #if defaultAdaptation == nil
    #  raise "Could not find default behaviour for removed adaptation."
    #end
    #defaultAdaptation.deploy
    if !self.activeAdaptations.empty?
      self.deployBestAdaptationForClass(aContextAdaptation.adaptedClass, aContextAdaptation.adaptedSelector)
    end
  end
  
  def deployBestAdaptationForClass(aClass, aSymbol)
    adaptations = self.adaptationChainForClass(aClass, aSymbol)
    if !adaptations.empty?
      adaptations[0].deploy
    end
  end
  
end