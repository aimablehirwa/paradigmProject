
#$LOAD_PATH << '.' #to make Ruby aware that included files must be searched in the current directory.
require "set"
require "contextManager"

class Context
  
   def initialize()
     @activationCount = 0 
     @adaptations = Set.new # use add to put an object
     @manager = nil
   end
   
   # activation du context, incremenation du conteur d'activation + 1 pour le mettre actif
   def active()
     if @activationCount == 0
      self.activationCount= @activationCount + 1
     end
   end
   
   def activationCount()
     return @activationCount
   end
   
   def activationCount=(anInteger)
     @activationCount = anInteger
   end
   
   def deactivate()
     if @activationCount != 0
       self.activationCount= @activationCount -1
     end
   end
   
   # suppression du context dans le manager
   # le context demande au manager de le supprimer
   def discard()
     self.manager.discardContext(this)
     if self == Context.default
       Context.default= nil
     end
   end
   
   # activation du context en incrementant le conteur d'activation
   def isActive()
     return @activationCount > 1
   end
   
   # getter du manager
   def manager()
     # verifier si le manager est nil
     if @manager == nil
       # si le manager est nil alors verifier si self est le context par defaut
       if self == Context.default
         # si self est le context par defaut alors cree un nouveau manager
         # definir le nom de self aupres du manager comme etant le default
         self.manager= ContextManager.new
         self.name= "default"
       else
         # si self n'est pas context par defaut
         # definir le manager le manager comme etant le manager par defaut
         self.manager= Context.default.manager
       end
     end
     return @manager
   end
   
   # setter du manager
   def manager=(aContextManager)
     @manager = aContextManager
   end
   
   
   def name()
     return @manager.dictionary[:self]
   end
   
   # setter du nom de self
   def name=(aString)
     if aString == nil
       # si le nom en param est nil alors supprimer le context du manager
       # si il y est non, rien faire
       @manager.dictionary.delete(self)  
     else
       # si le nom n'est pas nil alors ajouter self au manager
       @manager.dictionary[:self] = aString 
     end 
   end
   
   def printOn(aStream)
     #TODO
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
   
     def named=(aString)
       return self.new.name= aString
     end
     
   end
   
end