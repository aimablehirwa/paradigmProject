

class ContextManager
  
  def initialize()
    @directory = Hashes.new#todo
  end
  
  def directory()
    return @dictionary
  end
  
  def directory=(aDictionary)
    @directory = aDictionary
  end
  
  def discardContext(aConctext)
    if aContext.manager != self
      #todo
    end
    if aContext.isActive
      #todo
    end
    #todo
  end
  
end