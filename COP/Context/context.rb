
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
require_relative "modules/private.rb"

#INCLUDE MODULES
include Accessing
include Activation
include Adaptation
include Life_cycle
include Printing
include Private


class Context
      
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
   end
   
end

