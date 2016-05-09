require "set"

class ContextManager
  
  ##################
  # Initialization #
  ##################
  
  def initialize()
    @dictionary = Hash.new(nil)
    @activeAdaptations = Set.new
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
    #TODO
  end
  
  def resolutionPlolicy(aBlock)
    #TODO
  end
  
  ##############
  # Activation #
  ##############
  
  def contextActivationAge(aContext)
    #TODO
  end
  
  def signalActivationRequest(aContext)
    #TODO
  end
  
  def signalDeactivationRequest(aContext)
    #TODO
  end
  
  ##############
  # Adaptation #
  ##############
  
  def activateAdaptation(aContextAdaptation)
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
  end
  
  def adaptationChainForClass(aClass, aSymbol)
    #TODO
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
    #TODO
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
    @dictionary.delete(aContext)
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
    #TODO
  end
  
  def defaultResolutionPolicy()
    #TODO
  end
  
  def findNextMethodForClass(aClass, aSymbol, aMethod)
    #TODO
  end
  
  def noResolutionPolicy()
    #TODO
  end
  
  def singleAdaptationResolutionPolicy()
    #TODO
  end 
end