
#$LOAD_PATH << '.' #to make Ruby aware that included files must be searched in the current directory.
require "set"
require_relative "contextManager.rb"
require_relative "contextAdaptation.rb"

class Context
  
   ##################
   # Initialization #
   ##################
   
   def initialize()
     @activationCount = 0 
     @adaptations = Set.new # use add to put an object
     @manager = nil
     @adaptations = Set.new 
   end
   
   #############
   # Accessing #
   #############
   
   # getter du manager
   def manager()
     # verifier si le manager est nil
     if @manager == nil
       # si le manager est nil alors verifier si self est le context par defaut
       if self == Context.default
         # si self est le context par defaut alors cree un nouveau manager
         # definir le nom de self aupres du manager comme etant le default
         @manager = ContextManager.new
         self.name= "default"
       else
         # si self n'est pas context par defaut
         # definir le manager comme etant le manager par defaut
         @manager = Context.default.manager
       end
     end
     return @manager
   end
   
   # getter du manager
   def name()
     return self.manager.dictionary[self]
   end
   
   # setter du nom de self
   def name=(aString)
     if aString == nil
       # si le nom en param est nil alors supprimer le context du manager si il y est sinon rien faire
       self.manager.dictionary.delete(self)  
     else
       # si le nom n'est pas nil alors ajouter self au manager
       self.manager.dictionary[self] = aString 
     end 
     return self
   end
   
   ##############
   # Activation #
   ##############
   
   # activation du context, incrementation du conteur d'activation + 1 pour le mettre actif
   def activate()
     if self.activationCount == 0
       # on demande a active l'activer les adaptations du context
       self.activateAdaptations
     end
     self.activationCount= @activationCount + 1
     return self
   end
   
   def activationAge()
   end
   
   def deactivate()
     if @activationCount == 1
       self.deactivateAdaptations
     end
     if @activationCount > 0
       self.activationCount = @activationCount -1
     end
     return self
   end
   
   # activation du context en incrementant le conteur d'activation
   def isActive()
     return @activationCount > 0
   end
   
   ##############
   # Adaptation #
   ##############
   
   # la methode recoit des noms en paramettres
   def adaptClass(aClass, aSelector, aMethod)
      
     if aClass.methods.grep(/#{aSelector}/) == []
       raise "Cannot adapt inexistent method  #{aSelector} in  #{aClass.class.name}."   
     else
       _currentMethod = aClass.send(aSelector.to_sym)
     end

     ifOverridding = proc {"preserve"}
     _defaultAdaptation = ContextAdaptation.createAdaptation(Context.default, aClass, aSelector, _currentMethod) 
     Context.default.addAdaptationOverrid(_defaultAdaptation, ifOverridding)
     
     _contextAdaptation = ContextAdaptation.createAdaptation(self, aClass, aSelector, aMethod)
     self.addAdaptation(_contextAdaptation)
     return self
     
   end
   
   ##############
   # Life cycle #
   ##############
   
   # suppression du context dans le manager
   # le context demande au manager de le supprimer
   def discard()
       self.manager.discardContext(self)
       if self == Context.default
         Context.default= nil
       end
       copy = self.adaptations.clone
       copy.each do |adaptation | 
         self.removeExistingAdaptation(adaptation)
       end
   end
   
   ############
   # Printing #
   ############
   
   def printOn()
     if self.name == nil
       _s = "anonymous context"
     else
       _s = self.name + " context"
     end 
     return _s
   end
   
   ###########
   # Private #
   ###########
   
   def activateAdaptations
      self.adaptations.each do |adaptation|
        self.manager.activateAdaptation(adaptation)
        #TODO attraper l'exception et ...
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
     if aContextAdaptation.adaptedImplementation != nil
       #TODO
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
     aBlock = proc {}
     if aContextAdaptation.adaptedImplementation != nil
       #TODO
     end
   end
   
   
   def rollbackAdaptations
     #Removes all active adaptations corresponding to self. This set of adaptations 
     #might not necessarily be the same set stored in the 'adaptations' instance variable."

     deployedAdaptations = self.manager.activeAdaptations.initialize_clone.keep_if{|adaptation| adaptation.context == self } 
     deployedAdaptations.each do |adaptation| 
       self.manager.deactivateAdaptation(adaptation)
     end
   end
   
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
     
   end
   
end