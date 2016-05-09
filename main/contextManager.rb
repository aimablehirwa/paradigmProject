

require "set"

class ContextManager
  
  
  def initialize()
    @dictionary = Hash.new(nil)
    @activeAdaptations = Set.new
  end
  
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
  
  def activeAdaptations
    return @activeAdaptations
  end
  
  def activeAdaptations=(aCollection)
    @activeAdaptations = aCollection
  end
  
  def activeContexts
    #Return set of active contexts
    return self.activeAdaptations.select{|adaptation| adaptation.context}
  end 
  
  def dictionary()
    return @dictionary
  end
  
  def dictionary=(aDictionary)
    @dictionary = aDictionary
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
  
  
  def printOn
    activeAdaptationCount = self.activeAdaptations.size
    puts "#{self.class.name} #{activeAdaptationCount.asString}"
  end
  
end