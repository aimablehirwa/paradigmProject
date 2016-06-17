
#$LOAD_PATH << '.' #to make Ruby aware that included files must be searched in the current directory.
require "set"
require_relative "../ContextManager/contextManager.rb"
require_relative "../ContextAdaptation/contextAdaptation.rb"

#Import file
require_relative "modules/accessing.rb"
require_relative "modules/activation.rb"
require_relative "modules/adaptation.rb"
require_relative "modules/life_cycle.rb"
require_relative "modules/printing.rb"



class Context
   
   #INCLUDE MODULES
   include Accessing
   include Activation
   include Adaptation
   include Life_cycle
   include Printing
   
   ##################
   # Initialization #
   ##################
   
   def initialize()
     super
     @activationCount = 0 
     @adaptations = Set.new # use add to put an object
     @manager = nil
   end
   
   
   ###################
   # Singleton class #
   ###################
   
   # creation de methodes singleton pour la gestion du context par defaut
   class << self
     
     # getter pour un context par defaut
     # defini le context qui fait appel comme context par defaut si aucun autre context n'est defini
     def default()
       if @default == nil
         @default = self.new
         @default.activate
       end
       return @default
     end

     def default=(aContext)
       @default = aContext
     end
   
     def named(aString)
       _ctx = self.new
       _ctx.name= aString
       return _ctx
     end 
     
     def activeAdaptations
       if @activeAdaptations == nil
          @activeAdaptations = Set.new
       end
       return @activeAdaptations
     end
      
   end
   
   ###########
   # Private #
   ###########
   
   def activateAdaptations
      self.adaptations.each do |adaptation|
        #Catch error
        begin 
          self.manager.activateAdaptation(adaptation) 
          Context.activeAdaptations.add(adaptation)
        rescue Exception => error    
          raise error
        ensure
          #self.rollbackAdaptations  
        end      
      end
   end
   
   def activationCount()
     return @activationCount
   end
   
   def activationCount=(anInteger)
     @activationCount = anInteger
   end
   
   def adaptations
     @adaptations
   end
   
   def adaptations=(set)
     @adaptations = set  
   end
   
   
   def addAdaptation(aContextAdaptation)
     ifOverridding = proc {"overwrite"}
     self.addAdaptationOverrid(aContextAdaptation, ifOverridding)
   end
      
   def addAdaptationOverrid(aContextAdaptation, aBlock)
     existingAdaptation = nil
     self.adaptations.each do |adaptation| 
       # le meme context ne peut pas avoir deux adaptations differentes du meme selector
       if adaptation.sameTarget(aContextAdaptation)
         existingAdaptation = adaptation
       end
     end
     if existingAdaptation == nil
       existingAdaptation = aContextAdaptation
       self.addInexistentAdaptation(aContextAdaptation)
       return self
     end
     
     action = aBlock.call
     if action != "preserve"
       if action == "overwrite"
         self.removeExistingAdaptation(existingAdaptation)
         self.addInexistentAdaptation(aContextAdaptation)
       else
         raise "Unknown overridding action  #{action}."
       end
     end
   end  
   
   def addInexistentAdaptation(aContextAdaptation)
     if self != aContextAdaptation.context
       raise "Attempt to add foreign adaptation."
     end
     self.adaptations.add(aContextAdaptation)
     if self.isActive
       self.manager.activateAdaptation(aContextAdaptation)
     end
   end 
     
   def deactivateAdaptations
     self.adaptations.each do |adaptation|
       self.manager.deactivateAdaptation(adaptation)
     end
   end
   
   # setter du manager
   def manager=(aContextManager)
     @manager = aContextManager
   end
   
   def removeExistingAdaptation(aContextAdaptation)
     if self != aContextAdaptation.context 
       raise "Request to remove foreign adaptation."
     end
     if self.isActive
       self.manager.deactivateAdaptation(aContextAdaptation)
     end
     if self.adaptations.delete?(aContextAdaptation) == nil 
       raise "Inconsistent context state."
     end
   end
     
   def rollbackAdaptations
     #Removes all active adaptations corresponding to self. This set of adaptations 
     #might not necessarily be the same set stored in the 'adaptations' instance variable."

     deployedAdaptations =  self.manager.activeAdaptations.clone.keep_if{|adaptation| adaptation.context == self } 
     deployedAdaptations.each do |adaptation| 
       self.manager.deactivateAdaptation(adaptation)
       Context.activeAdaptations.delete(adaptation)
     end
   end
   
end

