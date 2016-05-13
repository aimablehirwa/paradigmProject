module Private
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
       Context.activeAdaptations.delete(adaptation)
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
       Context.activeAdaptations.delete(adaptation)
     end
     if self.adaptations.delete?(aContextAdaptation) == nil 
       raise "Inconsistent context state."
     end

   end
   
   
   def rollbackAdaptations
     #Removes all active adaptations corresponding to self. This set of adaptations 
     #might not necessarily be the same set stored in the 'adaptations' instance variable."

     deployedAdaptations = self.manager.activeAdaptations.clone.keep_if{|adaptation| adaptation.context == self} 
     deployedAdaptations.each do |adaptation| 
       self.manager.deactivateAdaptation(adaptation)
       Context.activeAdaptations.delete(adaptation)
     end
   end
end