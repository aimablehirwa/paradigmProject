module Adaptation
  ##############
  # Adaptation #
  ##############
  
  def activateAdaptation(aContextAdaptation)
    #self.activeAdaptations.add(aContextAdaptation)
    #self.deployBestAdaptationForClass(aContextAdaptation.adaptedClass, aContextAdaptation.adaptedSelector)
    
    adapt = false
    self.activeAdaptations.each do |adaptation| 
      adapt = (adaptation.sameTarget(aContextAdaptation) && adaptation.context != Context.default)
    end
    #throw :cannotActiveAdaptation 
    if adapt == true
      raise "Conflicting adaptation for #{aContextAdaptation.adaptedClass.name} >> #{aContextAdaptation.adaptedSelector}"
    end
    
    self.activeAdaptations.add(aContextAdaptation)
    aContextAdaptation.deploy
    #self.deployBestAdaptationForClass(aContextAdaptation.adaptedClass, aContextAdaptation.adaptedSelector)
  end
  
  def adaptationChainForClass(aClass, aSymbol)
    relevantAdaptations = self.activeAdaptations.instance_eval{initialize_clone(self).keep_if{|adaptation| adaptation.adaptsClass(aClass, aSymbol)}}
    if(relevantAdaptations == nil)
      raise "No adaptations found for #{aClass} >> #{aSymbol}"
    end 
    
    if self.resolutionPolicy 
      return relevantAdaptations.sort
    end
  end
  
  def deactivateAdaptation(aContextAdaptation)
    if self.activeAdaptations.delete?(aContextAdaptation) == nil
      raise "Attempt to deactivate unmanaged adaptation."
    end

    defaultAdaptation = nil
    Context.default.adaptations.each do |adaptation| 
      if adaptation.isClassAndSelector(aContextAdaptation.adaptedClass, aContextAdaptation.adaptedSelector)
        defaultAdaptation = adaptation
      end
    end

    if defaultAdaptation == nil
      raise "Could not find default behaviour for removed adaptation."
    end
    defaultAdaptation.deploy
  end
  
  def deployBestAdaptationForClass(aClass, aSymbol)
    if self.adaptationChainForClass(aClass, aSymbol) != nil
      (self.adaptationChainForClass(aClass, aSymbol)).first.deploy
    end
  end
end