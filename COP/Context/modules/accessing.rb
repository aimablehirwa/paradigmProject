module Accessing
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
         #@manager = ContextManager.new
         self.manager = ContextManager.new
         self.name = "default"
       else
         # si self n'est pas context par defaut
         # definir le manager comme etant le manager par defaut
         #@manager = Context.default.manager
         self.manager = Context.default.manager
       end
     end
     return @manager
   end
   
   # getter du nom du context qui est connu par le manager
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
   end
end
