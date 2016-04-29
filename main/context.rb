
$LOAD_PATH << '.' #to make Ruby aware that included files must be searched in the current directory.
require "set"
require "context"

class Context
  
   def initialize()
     @activationCount = 0 
     @adaptations = Set.new # use add to put an object
     @manager = nil
   end
   
   def active()
     if @activationCount == 0
      activationCount= @activationCount + 1
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
       activationCount= @activationCount -1
     end
   end
   
   def discard()
     # todo
   end
   
   def isActive()
     return @activationCount > 1
   end
   
   def manager()
     if @manager == nil
       #todo
     else
       #todo
     end
     return @manager
   end
   
   def manager=(aContextManager)
     @manager = aContextManager
   end
   
   def name()
     #todo
   end
   
   def name=(aString)
     
   end
   
   def printOn(aStream)
     #todo
   end
   
end