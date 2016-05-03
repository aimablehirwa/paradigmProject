

class ContextManager
  
  
  def initialize()
    @dictionary = Hash.new(nil)
  end
  
  def dictionary()
    return @dictionary
  end
  
  def dictionary=(aDictionary)
    @dictionary = aDictionary
  end
  
  # suppression d'un context
  def discardContext(aContext)
    test = Hash.new
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