module Accessing
  #############
  # Accessing #
  #############
  
  def activeCall()
    return @activeCall
  end
  
  def activeCall=(aPhoneCall)
    @activeCall = aPhoneCall
  end
  
    def incomingCalls()
    return @incomingCalls
  end
  
  def incomingCalls(anOrderedCollection)
    @incomingCalls = anOrderedCollection
  end
  
  def missedCalls()
    return @missedCalls
  end
  
  def missedCalls(anOrderedCollection)
    @missedCalls = anOrderedCollection
  end
  
  def ongoingCalls()
    return @ongoingCalls 
  end
  
  def ongoingCalls(anOrderedCollection)
    @ongoingCalls = anOrderedCollection
  end
  
  def terminatedCalls()
    return @terminatedCalls
  end
  
  def terminatedCalls=(anOrderedCollection)
    @terminatedCalls = anOrderedCollection
  end
end