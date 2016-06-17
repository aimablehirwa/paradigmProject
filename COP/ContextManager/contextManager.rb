require "set"

#Import file
require_relative "modules/accessing.rb"
require_relative "modules/activation.rb"
require_relative "modules/adaptation.rb"
require_relative "modules/life_cycle.rb"
require_relative "modules/printing.rb"
require_relative "modules/resolution.rb"


class ContextManager
  
  #INCLUDE MODULES
  include Accessing
  include Activation
  include Adaptation
  include Life_cycle
  include Printing
  include Resolution
  
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
  
  ###########
  # Private #
  ###########
  private
  def activeAdaptations=(aCollection)
    @activeAdaptations = aCollection
  end
  private
  def dictionary=(aDictionary)
    @dictionary = aDictionary
  end
  
  class << self
  
    #@singletonActiveAdaptations = Set.new
  
    def singletonActiveAdaptations
     if @singletonActiveAdaptations == nil
        @singletonActiveAdaptations = Set.new
     end
       return @singletonActiveAdaptations
    end
  
    def singletonActiveAdaptations=(aCollection)
       @singletonActiveAdaptations = aCollection
    end
  
    # recuperation de la methode de l'adapter precedent l'adapter courrant
    def proceed(aClass, aSymbol, aMethod) 
      
       currentadaptation = nil #@activeAdaptations[aClass.send(aMethod)]
     
       @singletonActiveAdaptations.each do |adaptation|#currentMethod properties at: #adaptation
         if (adaptation.adaptedClass.name == aClass.name) && (adaptation.adaptedSelector.to_s == aSymbol.to_s)
           currentadaptation = adaptation 
         end
       end

       if currentadaptation == nil
          raise "Proceed can only be used in adapted methods"
       end

       nextMethod = currentadaptation.context.manager.findNextMethodForClass(aClass, aSymbol, aMethod)
      return nextMethod.call
    end
  end
  
end