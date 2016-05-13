module Life_cycle
   ##############
   # Life cycle #
   ##############
   
   # suppression du context dans le manager
   # le context demande au manager de le supprimer
   def discard()
       self.manager.discardContext(self)
       if self == Context.default
         Context.default = nil
       end
       copy = self.adaptations.clone
       copy.each do |adaptation | 
         self.removeExistingAdaptation(adaptation)
       end
   end
end