module Activation
   ##############
   # Activation #
   ##############
   
   # activation du context, incrementation du conteur d'activation + 1 pour le mettre actif
   def activate()
     self.manager.signalActivationRequest(self)
     
     if self.activationCount == 0
       # on demande à activate d'activer les adaptations du context
       self.activateAdaptations
     end
     self.activationCount = self.activationCount + 1
     return self
   end
   
   def activationAge()
     return self.manager.contextActivationAge(self)
   end
   
   def deactivate()
     self.manager.signalDeactivationRequest(self)
     if self.activationCount == 1
       self.deactivateAdaptations
     end
     if @activationCount != 0
       @activationCount = @activationCount - 1
     end
     return self
   end
   
   # activation du context en incrementant le conteur d'activation
   def isActive()
     return @activationCount > 0
   end
end