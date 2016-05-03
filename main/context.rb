
#$LOAD_PATH << '.' #to make Ruby aware that included files must be searched in the current directory.
require "set"
require_relative "contextManager.rb"

class Context
  
   def initialize()
     @activationCount = 0 
     @adaptations = Set.new # use add to put an object
     @manager = nil
   end
   
   # activation du context, incremenation du conteur d'activation + 1 pour le mettre actif
   def active()
     self.activationCount= @activationCount + 1
     return self
   end
   
   def activationCount()
     return @activationCount
   end
   
   def activationCount=(anInteger)
     @activationCount = anInteger
   end
   
   def deactivate()
     if @activationCount > 0
       self.activationCount= @activationCount -1
     end
     return self
   end
   
   # suppression du context dans le manager
   # le context demande au manager de le supprimer
   def discard()
       self.manager.discardContext(self)
       if self == Context.default
         Context.default= nil
       end
   end
   
   # activation du context en incrementant le conteur d'activation
   def isActive()
     return @activationCount > 0
   end
   
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
   
   # setter du manager
   def manager=(aContextManager)
     @manager = aContextManager
   end
   
   
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
   
   def printOn()
     _s = ""
     if self.name == nil
       _s = "anonymous context"
     else
       _s = self.name + " context"
     end 
     return _s
   end
   
   # creation de methodes singleton pour la gestion du context par defaut
   class << self
     
     # getter pour un context par defaut
     # defini le context qui fait appel comme context par defaut si aucun autre context n'est defini
     def default()
       if @default == nil
         @default = self.new
         @default.active
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