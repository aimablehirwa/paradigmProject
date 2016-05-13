module Adaptation
   ##############
   # Adaptation #
   ##############
   
   # la methode recoit les nom d'une classe, un selector et d'une méthode en paramettres
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
end