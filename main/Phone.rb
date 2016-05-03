
require 'set'


class Phone
  
  def initialize()
    @incomingCalls = SortedSet.new
    @ongoingCalls = SortedSet.new #= OrderedCollection new.
    @terminatedCalls = SortedSet.new#= OrderedCollection new.
    @missedCalls = SortedSet.new#= OrderedCollection new.
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
  
  # repondre au premier appel dans la file si il y en a un
  def answer()
    _nextCall = @incomingCalls.first
    if _nextCall == nil
      raise 'No incoming calls to answer.' 
    end
    self.answer(_nextCall)
  end
  
  def answer(aPhoneCall)
    # rendre l'appel actif
    self.activeCall= aPhoneCall
    
    # supprimer l'appel on veut repondre dans la liste des incomingcalls
    # exception si il y en a pas
    if @incomingCalls.delete?(aPhoneCall) == nil
      raise 'Only incoming calls can be answered.'
    end
    # ???? suspendre l'appel
    self.suspend
    
    # ajouter l'appel dans les ongoingcalls
    @ongoingCalls.add?(aPhoneCall)
    
    # ???? recuperer l'appel
    self.resume(aPhoneCall)
  end
  
  # racrocher un appel si il y a en un qui est actif
  def hangUp()
    if @activeCall == nil
      raise 'No active call to hang up.'
    end
    self.hangUp(@activeCall)
  end
  
  def hangUp(aPhoneCall)
    if @ongoingCalls.delete?(aPhoneCall) == nil
      raise 'Only ongoing calls can be hung up.'
    end
    if @activeCall == aPhoneCall
      self.suspend
    end
    @terminatedCalls.add?(aPhoneCall)
  end
  
  def incomingCalls()
    return @incomingCalls
  end
  
  def incomingCalls(anOrderedCollection)
    @incomingCalls = anOrderedCollection
  end
  
  # les appels rater sont retire des appels entrant pour etre mis dans les appels rate
  def miss(aPhoneCall)
    if @incomingCalls.delete?(aPhoneCall) == nil
      raise 'Only incoming calls can be missed.'
    end
    @missedCalls.add?(aPhoneCall)
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
  
  def receive(aPhoneCall)
    @incomingCalls.add?(aPhoneCall)
    self.advertise
  end
  
  # recuperation d'un appel suspendu, il doit etre dans le ongoingcalls
  def resume(aPhoneCall)
    if @ongoingCalls.include?(aPhoneCall) == nil
      raise 'Only ongoing calls can be resumed.'
    end
    self.activeCall= aPhoneCall
  end
  
  def suspend()
    self.activeCall= nil
  end
  
  def terminatedCalls()
    return @terminatedCalls
  end
  
  def terminatedCalls=(anOrderedCollection)
    @terminatedCalls = anOrderedCollection
  end
  
end