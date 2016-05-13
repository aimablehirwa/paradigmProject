module Accessing
  #############
  # Accessing #
  #############
  
  def activeAdaptations
    return @activeAdaptations
  end
  
  def activeContexts
    #Return set of active contexts
    return self.activeAdaptations.clone.keep_if{|adaptation| adaptation.context}
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
end