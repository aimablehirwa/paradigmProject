
class Phone
  
  def initialize()
    @incomingCalls
    @ongoingCalls #= OrderedCollection new.
    @terminatedCalls #= OrderedCollection new.
    @missedCalls #= OrderedCollection new.
    @activeCall = nil
  end
  
  def activeCall()
    return @activeCall
  end
  
  def activeCall=(aPhoneCall)
    @activeCall = aPhoneCall
  end
  
  def advertise(aPhoneCall)
    return "ringtone"
  end
  
  def answer()
    
  end
  
  def answer(aPhoneCall)
    
  end
  
  def hangUp()
    
  end
  
  def hangUp(aPhoneCall)
    
  end
  
  def incomingCalls()
    
  end
  
  def incomingCalls(anOrderedCollection)
    
  end
  
  def miss(aPhoneCall)
    
  end
  
  def missedCalls()
    @missedCalls
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
  
  def receive(aPhoneCall)
    
  end
  
  def resume(aPhoneCall)
    
  end
  
  def suspend()
    @activeCall = nil
  end
  
  def terminatedCalls()
    return @terminatedCalls
  end
  
  def terminatedCalls=(anOrderedCollection)
    @terminatedCalls = anOrderedCollection
  end
  
end