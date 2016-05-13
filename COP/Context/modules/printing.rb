module Printing
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
end