

class ContextManager
  
  def initialize()
    @directory = Hash.new
  end
  
  def directory()
    return @dictionary
  end
  
  def directory=(aDictionary)
    @directory = aDictionary
  end
  
  # suppression d'un context
  def discardContext(aContext)
    # lancer exception si le context n'a pas de manager
    if aContext.manager != self
      raise 'Attempt to discard foreign context.'
    end
    if aContext.isActive
      raise 'Attempt to discard active context.'
    end
    # si la cle n'est pas presente alors rien n'est fait
    @dictionary.delete(aContext)
  end
  
end