require "set"

class ContextManager
  
  ##################
  # Initialization #
  ##################
  
  def initialize()
    super
    @dictionary = Hash.new(nil)
    @activeAdaptations = Set.new
    @resolutionPolicy = self.defaultResolutionPolicy
    @totalActivations = 0
    @activationStamps = Hash.new(0)
  end
  
  #############
  # Accessing #
  #############
  
  def activeAdaptations
    return @activeAdaptations
  end
  
  def activeContexts
    #Return set of active contexts
    return self.activeAdaptations.select{|adaptation| adaptation.context}
  end 
  
  def dictionary()
    return @dictionary
  end
  
  def resolutionPlolicy()
    return @resolutionPolicy
  end
  
  def resolutionPolicy=(aBlock)
    
    @resolutionPolicy = aBlock
    adaptedTarget = Set.new
    
    @activeAdaptations.each do |adaptation| 
      adaptedTarget.add(adaptation.adaptedClass, adaptation.adaptedSelector)
    end
    
    adaptedTarget.each do |target|
      self.deployBestAdaptationForClass(target[1], target[2])
    end
  end
  
  ##############
  # Activation #
  ##############
  
  def contextActivationAge(aContext)
    #return 0 sinon
    return @totalActivations - @activationStamps[aContext]  
  end
  
  #to check
  def signalActivationRequest(aContext)
    @totalActivations = @totalActivations + 1
    @activationStamps[aContext] = @totalActivations
  end
  
  def signalDeactivationRequest(aContext)
    #This callback is invoked whenever a context becomes inactive
  end
  
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
  
  ##############
  # Life cycle #
  ##############
  
  # suppression d'un context
  def discardContext(aContext)
    test = Hash.new
    # lancer exception si le context n'a pas de manager
    if aContext.manager != self
      raise "Attempt to discard foreign context."
    end
    if aContext.isActive
      raise "Attempt to discard active context."
    end
    # si la cle n'est pas presente alors rien n'est fait
    self.dictionary.delete(aContext)
    @activationStamps.delete(aContext)
  end
  
  ############
  # Printing #
  ############
  
  def printOn(aStream)
    activeAdaptationCount = self.activeAdaptations.size
    puts "#{self.class.name} #{activeAdaptationCount.asString}"
  end
  
  ###########
  # Private #
  ###########
  
  def activeAdaptations=(aCollection)
    @activeAdaptations = aCollection
  end
  
  def dictionary=(aDictionary)
    @dictionary = aDictionary
  end
  
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